import 'dart:io';

import 'package:mason_logger/mason_logger.dart';

/// Returns true if docker is running
bool isDockerRunning(Logger logger) {
  final result = Process.runSync('docker', ['info']);
  if (result.exitCode != 0) {
    logger.err(
      '[dockerize] Docker Engine is not running. Please start the Docker desktop application',
    );
    return false;
  }
  return true;
}
