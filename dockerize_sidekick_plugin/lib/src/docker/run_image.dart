import 'dart:convert';
import 'dart:io' as io;

import 'package:dockerize_sidekick_plugin/dockerize_sidekick_plugin.dart';
import 'package:path/path.dart' as path;
import 'package:sidekick_core/sidekick_core.dart' hide red;
import 'package:stream_transform/stream_transform.dart';
import 'package:watcher/watcher.dart';

typedef DirectoryWatcherBuilder = DirectoryWatcher Function(
  String directory,
);

/// Starting the docker image
Future<void> runImage({
  required DartPackage? mainProject,
  required bool withoutHotReload,
  required EnvironmentBase environment,
  String? port,
  List<String> buildArgs = const [],
}) async {
  final mainProjectName = mainProject?.name ?? 'app';
  final projectRoot = SidekickContext.projectRoot;
  final requiredEntryPoint = SidekickContext.entryPoint;
  final workingDir = projectRoot.directory('server');
  final DirectoryWatcher watcher = DirectoryWatcher(projectRoot.path);
  final Logger logger = Logger();
  Process? process;
  bool reloading = false;

  /// Runs the docker image
  Future<void> runImage() async {
    process = await io.Process.start(
      'docker',
      [
        'run',
        '--rm',
        '-p',
        '$port:8080',
        '--name',
        mainProjectName,
        '$mainProjectName:${environment.name}',
      ],
    );

    // Watches if the user is pressing ctrl+c and kills the process
    ProcessSignal.sigint.watch().listen(
          (_) => _killProcess(
            process,
            mainProjectName,
            workingDir,
            logger: logger,
          ),
        );

    // Listens to the process error output and prints it to the console
    process?.stderr.listen((_) {
      final message = utf8.decode(_).trim();
      if (message.isEmpty) return;
      logger.err('[dockerize] $message');
      _killProcess(process, mainProjectName, workingDir, logger: logger);
    });

    // Listens to the process output and prints it to the console
    process?.stdout.listen((_) {
      final message = utf8.decode(_).trim();
      if (message.isEmpty) return;
      logger.info('[dockerize] $message');
    });
  }

  runImage();

  if (!withoutHotReload) {
    /// Checks if the lib dir of the main project is changed
    /// If so, it will reload the whole project
    bool shouldReloadAll(WatchEvent event) {
      if (reloading) return false;
      final mainProjectPath = mainProject?.libDir.path;
      if (mainProjectPath == null) return false;
      final withinSidekick = () {
        return path.isWithin(
          SidekickContext.sidekickPackage.root.path,
          event.path,
        );
      }();
      return (path.isWithin(mainProjectPath, event.path) ||
              path.isWithin(
                projectRoot.directory('packages').path,
                event.path,
              )) &&
          !withinSidekick;
    }

    /// Checks if the server dir is changed
    bool shouldReloadDocker(WatchEvent event) {
      if (reloading) return false;
      return path.isWithin(
            projectRoot.directory('server').path,
            event.path,
          ) &&
          !path.isWithin(
            projectRoot.directory('server/www').path,
            event.path,
          );
    }

    /// Checks if the event should trigger a reload
    bool shouldReload(WatchEvent event) {
      if (reloading) return false;
      return shouldReloadAll(event) || shouldReloadDocker(event);
    }

    Future<void> cooldown() async {
      await Future.delayed(const Duration(seconds: 1));
      reloading = false;
    }

    /// Reloads the image
    Future<void> reload({required bool reloadAll}) async {
      // blocking watcher from triggering reload multiple times after build is done
      reloading = true;

      try {
        _killProcess(
          process,
          mainProjectName,
          workingDir,
          shouldExit: false,
          silent: true,
          logger: logger,
        );
        await createDockerImage(
          entryPointPath: requiredEntryPoint.path,
          logger: logger,
          mainProjectName: mainProjectName,
          buildFlutter: reloadAll,
          workingDirectoryPath:
              SidekickContext.projectRoot.directory('server').path,
          environment: environment,
          buildArgs: buildArgs,
        );
        final progress = logger.progress('[dockerize] Starting image...');
        runImage();
        progress.complete('[dockerize] Reload complete.');
        cooldown();
      } catch (e, stack) {
        logger.err('[dockerize] Failed to reload');
        logger.err('[dockerize] $e');
        logger.err('[dockerize] $stack');
      }
    }

    final subscription = watcher.events
        .where(shouldReload)
        .debounce(Duration.zero)
        .listen((WatchEvent event) {
      if (shouldReloadDocker(event) && !reloading) {
        reload(reloadAll: false);
      } else if (shouldReloadAll(event)) {
        reload(reloadAll: true);
      }
    });

    await subscription.asFuture<void>();
    await subscription.cancel();
  }
}

/// kills the Process and exits the application
Future<void> _killProcess(
  io.Process? process,
  String mainProjectName,
  Directory workingDir, {
  bool shouldExit = true,
  bool silent = false,
  required Logger logger,
}) async {
  await stopImage(
    mainProjectName: mainProjectName,
    workingDirectory: workingDir,
    silent: true,
    logger: logger,
  );
  if (process != null) process.kill();
  if (shouldExit) exit(1);
}
