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
  required String environmentName,
  required DartPackage? mainProject,
  String? port,
}) async {
  final mainProjectName = mainProject?.name ?? 'app';
  final repositoryRoot = repository.root;
  final requiredEntryPoint = Repository.requiredEntryPoint;
  final workingDir = repository.root.directory('server');
  final DirectoryWatcher watcher = DirectoryWatcher(repository.root.path);
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
        '$mainProjectName:$environmentName',
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

  /// Checks if the lib dir of the main project is changed
  /// If so, it will reload the whole project
  bool shouldReloadAll(WatchEvent event) {
    if (reloading) return false;
    final mainProjectPath = mainProject?.libDir.path;
    if (mainProjectPath == null) return false;
    final withinSidekick = () {
      if (Repository.cliPackageDir == null) return false;
      return path.isWithin(
        Repository.cliPackageDir!.path,
        event.path,
      );
    }();
    return (path.isWithin(mainProjectPath, event.path) ||
            path.isWithin(
              repositoryRoot.directory('packages').path,
              event.path,
            )) &&
        !withinSidekick;
  }

  /// Checks if the server dir is changed
  bool shouldReloadDocker(WatchEvent event) {
    if (reloading) return false;
    return path.isWithin(
          repositoryRoot.directory('server').path,
          event.path,
        ) &&
        !path.isWithin(
          repositoryRoot.directory('server/www').path,
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
    final progress = logger.progress('[dockerize] Reloading...');
    try {
      progress.update('[dockerize] Stopping image...');
      _killProcess(
        process,
        mainProjectName,
        workingDir,
        shouldExit: false,
        silent: true,
        logger: logger,
      );
      progress.update('[dockerize] Building image...');
      await createDockerImage(
        environmentName,
        logger: logger,
        mainProjectName: mainProjectName,
        buildFlutter: reloadAll,
        workingDirectoryPath: repositoryRoot,
        entryPoint: requiredEntryPoint.path,
      );
      progress.update('[dockerize] Starting image...');
      runImage();
      progress.complete('[dockerize] Reload complete.');
      cooldown();
    } catch (e, stack) {
      progress.fail('[dockerize] Failed to reload');
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
