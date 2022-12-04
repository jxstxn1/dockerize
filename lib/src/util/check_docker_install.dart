import 'package:sidekick_core/sidekick_core.dart';

/// Checks if docker is installed
/// Exit the process if docker is not installed
void checkDockerInstall() {
  if (which('docker').notfound) {
    printerr(
      red('Docker is not installed. Please install docker and try again.'),
    );
    exit(0);
  }
}
