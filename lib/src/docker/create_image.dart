import 'package:dockerize_sidekick_plugin/src/util/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:sidekick_core/sidekick_core.dart' hide Progress;

/// Creates a docker image
Future<void> createDockerImage(
  String environmentName, {
  Logger? logger,
  bool buildScripts = true,
  bool buildFlutter = true,
  Directory? workingDirectoryPath,
}) async {
  final Logger buildLogger = logger ?? Logger();
  buildLogger.info(
    '[dockerize] Creating image ${mainProject!.name}:$environmentName',
  );
  final workingDir =
      (workingDirectoryPath ?? repository.root).directory('server');
  await commandRunner(
    'docker',
    [
      'buildx',
      'build',
      '-t',
      '${mainProject!.name}:$environmentName',
      '.',
    ],
    logger: buildLogger,
    workingDirectory: workingDir,
    successMessage: 'Created image ${mainProject!.name}:$environmentName 🎉',
  );
}
