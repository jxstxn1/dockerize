import 'dart:io' as io;
import 'package:mason_logger/mason_logger.dart';
import 'package:sidekick_core/sidekick_core.dart';

/// Internal Command runner which only prints the output if there is an error
Future<void> commandRunner(
  String command,
  List<String> args, {
  required Directory workingDirectory,
  required Logger logger,
  bool silent = false,
  required String successMessage,
}) async {
  final process = await io.Process.run(
    command,
    args,
    workingDirectory: workingDirectory.path,
    runInShell: true,
  );
  if (process.exitCode == 0) {
    if (!silent) {
      logger.info('[dockerize] ${process.stdout}');
      logger.success('[dockerize] $successMessage');
    }
  } else {
    if (!silent) {
      logger.info('[dockerize] ${process.stdout}');
      logger.err('[dockerize] ${process.stderr}');
    }
  }
}
