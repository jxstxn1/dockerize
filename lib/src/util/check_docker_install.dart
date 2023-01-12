import 'package:mason_logger/mason_logger.dart';
import 'package:sidekick_core/sidekick_core.dart';

/// Checks if docker is installed
/// Exit the process if docker is not installed
void checkDockerInstall() {
  final Logger logger = Logger();
  if (which('docker').notfound) {
    logger.err(
      '[dockerize] Docker is not installed. Please install docker and try again.',
    );
    exit(0);
  }
}
