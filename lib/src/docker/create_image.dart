import 'dart:io' as io;
import 'package:dockerize_sidekick_plugin/src/util/command_runner.dart';
import 'package:sidekick_core/sidekick_core.dart';

/// Creates a docker image
void createDockerImage(String environmentName) {
  print(
    'Creating image ${mainProject!.name}:$environmentName',
  );
  commandRunner(
    'docker',
    ['buildx', 'build', '-t', '${mainProject!.name}:$environmentName', '.'],
    workingDirectory: repository.root.directory('server'),
    successMessage: '✅ Created image ${mainProject!.name}:$environmentName 🎉',
  );
}

// Helper method which is under the hood calling the build command
void executeBuild({
  required bool buildContainer,
  required String envName,
  String? path,
}) {
  final entryPointPath = path ?? Repository.requiredEntryPoint.path;
  final process = io.Process.runSync(
    entryPointPath,
    [
      'docker',
      'build',
      '--env=$envName',
      if (buildContainer) '--docker-only',
    ],
  );
  process.exitCode == 0
      ? print(green('Build successful'))
      : print(red('Build failed'));
}
