import 'package:dcli/dcli.dart' as dcli;
import 'package:sidekick_core/sidekick_core.dart';

/// Internal Command runner which only prints the output if there is an error
void commandRunner(
  String command,
  List<String> args, {
  required Directory workingDirectory,
  required dcli.Progress progress,
}) {
  try {
    dcli.startFromArgs(
      command,
      args,
      workingDirectory: workingDirectory.path,
      progress: progress,
    );
  } catch (e) {
    print(progress.lines.join('\n'));
  }
}
