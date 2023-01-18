import 'package:dockerize_sidekick_plugin/src/util/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:sidekick_core/sidekick_core.dart';

/// Stoping the currently running docker image
Future<void> stopImage({
  bool silent = false,
  String? mainProjectName,
  Directory? workingDirectory,
  required Logger logger,
}) async {
  final projectName = mainProjectName ?? mainProject!.name;
  await commandRunner(
    'docker',
    ['kill', projectName],
    workingDirectory: workingDirectory ?? repository.root.directory('server'),
    silent: silent,
    logger: logger,
    successMessage: 'Stopped app: $projectName',
  );
}
