import 'dart:io' as io;
import 'package:mason_logger/mason_logger.dart';
import 'package:sidekick_core/sidekick_core.dart' hide Progress;

/// Creates a docker image
Future<void> createDockerImage(
  String environmentName, {
  String? mainProjectName,
  String? entryPoint,
  Logger? logger,
  bool buildScripts = true,
  bool buildFlutter = true,
  Directory? workingDirectoryPath,
}) async {
  final entryPointPath = entryPoint ?? Repository.requiredEntryPoint.path;
  final containerName = mainProjectName ?? mainProject!.name;
  final Logger buildLogger = logger ?? Logger();
  final buildProgess = buildLogger.progress(
    '[dockerize] Creating image $containerName:$environmentName',
  );
  if (buildFlutter) {
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
      buildProgess.update('[dockerize] Built flutter app 🎉');
    } else {
      buildProgess.fail('[dockerize] Failed to build flutter app 😢');
      buildLogger.err(process.stdout.toString());
      buildLogger.err(process.stderr.toString());
    }
  }
  if (buildScripts) {
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
      buildProgess.update('[dockerize] Executed Build Scripts 🎉');
    } else {
      buildProgess.fail('[dockerize] Failed to execute BuildScripts 😢');
      buildLogger.err(process.stdout.toString());
      buildLogger.err(process.stderr.toString());
    }
  }

  final workingDir =
      (workingDirectoryPath ?? repository.root).directory('server');
  final process = await io.Process.run(
    'docker',
    [
      'buildx',
      'build',
      '-t',
      '$mainProjectName:$environmentName',
      '.',
    ],
    workingDirectory: workingDir.path,
  );
  if (process.exitCode == 0) {
    buildProgess.complete('[dockerize] Built Docker Image 🎉');
  } else {
    buildProgess.fail('[dockerize] Failed to build Docker Image 😢');
    buildLogger.err(process.stdout.toString());
    buildLogger.err(process.stderr.toString());
  }
}
