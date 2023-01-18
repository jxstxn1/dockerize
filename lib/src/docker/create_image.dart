import 'dart:io' as io;
import 'package:dockerize_sidekick_plugin/src/util/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:sidekick_core/sidekick_core.dart' hide Progress;

/// Creates a docker image
Future<void> createDockerImage(String environmentName, {Logger? logger}) async {
  final Logger buildLogger = logger ?? Logger();
  buildLogger.info(
    '[dockerize] Creating image ${mainProject!.name}:$environmentName',
  );
  await commandRunner(
    'docker',
    ['buildx', 'build', '-t', '${mainProject!.name}:$environmentName', '.'],
    logger: buildLogger,
    workingDirectory: repository.root.directory('server'),
    successMessage: 'Created image ${mainProject!.name}:$environmentName 🎉',
  );
}

// Helper method which is under the hood calling the build command
Future<void> executeBuild({
  Progress? progressLogger,
  required bool buildContainer,
  required String envName,
  String? path,
}) async {
  final Logger buildLogger = Logger();
  final entryPointPath = path ?? Repository.requiredEntryPoint.path;
  progressLogger?.update('[dockerize] Building app');
  final process = await io.Process.run(
    entryPointPath,
    [
      'docker',
      'build',
      '--env=$envName',
      if (buildContainer) '--docker-only',
    ],
  );
  if (process.exitCode == 0) {
    if (progressLogger != null) {
      progressLogger.update('[dockerize] Build successful');
    } else {
      buildLogger.success('[dockerize] Build successful');
    }
  } else {
    if (progressLogger != null) {
      progressLogger.fail('[dockerize] Build failed');
    } else {
      buildLogger.err('[dockerize] Build failed');
    }
  }
}
