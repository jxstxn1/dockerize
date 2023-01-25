import 'dart:io' as io;

import 'package:mason_logger/mason_logger.dart';
import 'package:sidekick_core/sidekick_core.dart' hide Progress;

/// Creates a docker image
Future<void> createDockerImage(
  String environmentName, {
  String? mainProjectName,
  required String entryPointPath,
  required Logger logger,
  bool buildScripts = true,
  bool buildFlutter = true,
  Directory? workingDirectoryPath,
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
    }
  }

  final buildProgess = logger.progress(
    '[dockerize] Creating image $containerName:$environmentName',
  );
  final workingDir = Directory('$entryPointPath/server');

  final process = await io.Process.run(
    'docker',
    [
      'buildx',
      'build',
      '-t',
      '$containerName:$environmentName',
      '.',
    ],
    workingDirectory: workingDir.path,
  );
  if (process.exitCode == 0) {
    buildProgess.complete('[dockerize] Built Docker Image 🎉');
  } else {
    buildProgess.fail('[dockerize] Failed to build Docker Image 😢');
    logger.err(process.stdout.toString());
    logger.err(process.stderr.toString());
  }
  logger.info(
    '${lightGreen.wrap('✓')} [dockerize] image name: ${lightGreen.wrap(styleBold.wrap('$containerName:$environmentName'))}',
  );
}
