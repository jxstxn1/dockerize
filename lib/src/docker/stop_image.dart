import 'package:dockerize_sidekick_plugin/src/util/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:sidekick_core/sidekick_core.dart';

/// Stoping the currently running docker image
Future<void> stopImage({
  bool silent = false,
  required String mainProjectName,
  required Directory workingDirectory,
  required Logger logger,
}) async {
  final projectName = mainProjectName;
  await commandRunner(
    'docker',
    ['kill', projectName],
    workingDirectory: workingDirectory,
    silent: silent,
    logger: logger,
    successMessage: 'Stopped app: $projectName',
  );
}
