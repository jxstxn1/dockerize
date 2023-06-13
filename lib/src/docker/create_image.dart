import 'dart:io' as io;

import 'package:dockerize_sidekick_plugin/dockerize_sidekick_plugin.dart';
import 'package:dockerize_sidekick_plugin/src/docker/collect_garbage.dart';
import 'package:dockerize_sidekick_plugin/src/util/create_registrant.dart';
import 'package:sidekick_core/sidekick_core.dart' hide Progress;

/// Creates a docker image
///
/// Use [buildArgs] to pass additional arguments to the docker build command.
Future<void> createDockerImage({
  String? mainProjectName,
  required String entryPointPath,
  required String workingDirectoryPath,
  required Logger logger,
  required EnvironmentBase environment,
  bool buildFlutter = true,

  /// Build arguments to pass into the docker command
  /// `--build-arg` will be added to each argument automatically
  List<String> buildArgs = const [],
}) async {
  final containerName = mainProjectName ?? mainProject!.name;
  if (buildFlutter) {
    final buildProgess = logger.progress(
      '[dockerize] Building Flutter App',
    );
    final process = await io.Process.run(
      entryPointPath,
      [
        'docker',
        'build',
        'app',
        '--env=${environment.name}',
      ],
    );
    if (process.exitCode == 0) {
      buildProgess.complete('[dockerize] Built flutter app 🎉');
    } else {
      buildProgess.fail('[dockerize] Failed to build flutter app 😢');
      logger.err(process.stdout.toString());
      logger.err(process.stderr.toString());
    }
  }

  writeToVersionFile(
    versionFile: SidekickContext.projectRoot.file('server/www/version.json'),
    entries: environment.versionFileEntries,
  );
  final hashes = hashScripts(
    hashType: sha256,
    logger: logger,
    htmlFile:
        SidekickContext.projectRoot.directory('server/www').file('index.html'),
  );

  final dockerizeBuildDir =
      SidekickContext.projectRoot.directory('server/.dockerize_build');
  if (dockerizeBuildDir.existsSync()) {
    dockerizeBuildDir.deleteSync(recursive: true);
  }
  dockerizeBuildDir.createSync();

  createDockerizeRegistrant(
    registrantDir: dockerizeBuildDir,
    cspHashes: hashes,
    shouldEnforceCsp: environment.shouldEnforceCSP,
    logger: logger,
  );

  final buildProgess = logger.progress(
    '[dockerize] Creating image $containerName:${environment.name}',
  );

  final process = await io.Process.run(
    'docker',
    [
      'build',
      for (final buildArg in buildArgs) ...['--build-arg', buildArg],
      '-t',
      '$containerName:${environment.name}',
      '.',
    ],
    workingDirectory: workingDirectoryPath,
  );
  if (process.exitCode == 0) {
    buildProgess.complete('[dockerize] Built Docker Image 🎉');
  } else {
    buildProgess.fail('[dockerize] Failed to build Docker Image 😢');
    logger.err(process.stdout.toString());
    logger.err(process.stderr.toString());
  }
  garbageCollector(logger: logger);
  logger.info(
    '${lightGreen.wrap('✓')} [dockerize] image name: ${lightGreen.wrap(styleBold.wrap('$containerName:${environment.name}'))}',
  );
}
