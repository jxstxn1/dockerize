import 'package:dcli/dcli.dart' as dcli;
import 'package:mason_logger/mason_logger.dart';
import 'package:sidekick_core/sidekick_core.dart';

/// Internal Command runner which only prints the output if there is an error
void commandRunner(
  String command,
  List<String> args, {
  required Directory workingDirectory,
  required Logger logger,
  dcli.Progress? progress,
  bool silent = false,
  required String successMessage,
}) {
  final processProgress = progress ??
      dcli.Progress(
        dcli.devNull,
        captureStdin: true,
        captureStderr: true,
      );
  try {
    dcli.startFromArgs(
      command,
      args,
      workingDirectory: workingDirectory.path,
      progress: processProgress,
    );
    if (!silent) logger.success('[dockerize] $successMessage');
  } catch (e) {
    if (!silent) {
      logger.err('[dockerize] ${processProgress.lines.join('\n')}');
      exit(1);
    }
  }
}
