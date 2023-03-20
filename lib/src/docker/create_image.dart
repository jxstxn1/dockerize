import 'dart:io' as io;

import 'package:dockerize_sidekick_plugin/src/docker/collect_garbage.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:sidekick_core/sidekick_core.dart' hide Progress;

/// Creates a docker image
///
/// Use [buildArgs] to pass additional arguments to the docker build command.
Future<void> createDockerImage(
  String environmentName, {
  String? mainProjectName,
  required String entryPointPath,
  required String workingDirectoryPath,
  required Logger logger,
  bool buildScripts = true,
  bool buildFlutter = true,
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
        '--env=$environmentName',
      ],
    );
    if (process.exitCode == 0) {
      buildProgess.complete('[dockerize] Built flutter app 🎉');
    } else {
      buildProgess.fail('[dockerize] Failed to build flutter app 😢');
      logger.err(process.stdout.toString());
      logger.err(process.stderr.toString());
      exit(1);
    }
  }
  if (buildScripts) {
    final buildProgess = logger.progress(
      '[dockerize] Running BuildScripts',
    );
    final process = await io.Process.run(
      entryPointPath,
      [
        'docker',
        'build',
        'scripts',
        '--env=$environmentName',
      ],
    );
    if (process.exitCode == 0) {
      buildProgess.complete('[dockerize] Executed Build Scripts 🎉');
    } else {
      buildProgess.fail('[dockerize] Failed to execute BuildScripts 😢');
      logger.err(process.stdout.toString());
      logger.err(process.stderr.toString());
      exit(1);
    }
  }

  final buildProgess = logger.progress(
    '[dockerize] Creating image $containerName:$environmentName',
  );

  final process = await io.Process.run(
    'docker',
    [
      'buildx',
      'build',
      ...buildArgs,
      '-t',
      '$containerName:$environmentName',
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
    exit(1);
  }
  garbageCollector(logger: logger);
  logger.info(
    '${lightGreen.wrap('✓')} [dockerize] image name: ${lightGreen.wrap(styleBold.wrap('$containerName:$environmentName'))}',
  );
}
