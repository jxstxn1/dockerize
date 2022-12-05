import 'package:dcli/dcli.dart' as dcli;
import 'package:sidekick_core/sidekick_core.dart';

/// Internal Command runner which only prints the output if there is an error
void commandRunner(
  String command,
  List<String> args, {
  required Directory workingDirectory,
  dcli.Progress? progress,
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
  } catch (e) {
    if (!processProgress.lines.contains('Cannot kill container') &&
        !processProgress.lines.contains('No such container')) {
      print(processProgress.lines.join('\n'));
    }
  }
}
