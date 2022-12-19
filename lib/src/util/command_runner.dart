import 'package:dcli/dcli.dart' as dcli;
import 'package:sidekick_core/sidekick_core.dart';

/// Internal Command runner which only prints the output if there is an error
void commandRunner(
  String command,
  List<String> args, {
  required Directory workingDirectory,
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
    if (!silent) print(green(successMessage));
  } catch (e) {
    if (!silent) {
      print(processProgress.lines.join('\n'));
      exit(1);
    }
  }
}
