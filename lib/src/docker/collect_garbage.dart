import 'dart:io' as io;

import 'package:mason_logger/mason_logger.dart';

/// Internal function to remove all dangling images
Future<void> garbageCollector({
  required Logger logger,
  bool silent = true,
}) async {
  /// Getting all danling images
  final danglingImagesProcess = await io.Process.run(
    'docker',
    ['images', '-f', 'dangling=true', '-q'],
  );

  final List<String> danglingImages =
      danglingImagesProcess.stdout.toString().split('\n')
        ..removeWhere(
          (element) => element.isEmpty || element == ' ',
        );

  if (danglingImages.isEmpty) {
    if (!silent) logger.success('[dockerize] No dangling images found 🎉');
    return;
  }

  /// Removing all dangling images
  final process = await io.Process.run(
    'docker',
    [
      'rmi',
      ...danglingImages,
    ],
  );
  if (process.exitCode == 0) {
    if (!silent) logger.success('[dockerize] Removed all dangling images 🎉');
  } else if (!silent) {
    logger.err('[dockerize] Failed to remove all dangling images 😢');
    logger.err(process.stdout.toString());
    logger.err(process.stderr.toString());
  }
}
