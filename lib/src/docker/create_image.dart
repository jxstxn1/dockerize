import 'package:dcli/dcli.dart' as dcli;
import 'package:dockerize_sidekick_plugin/src/util/command_runner.dart';
import 'package:sidekick_core/sidekick_core.dart';

/// Creates a docker image
void createDockerImage() {
  final progress = dcli.Progress(
    dcli.devNull,
    captureStdin: true,
    captureStderr: true,
  );
  commandRunner(
    'docker',
    ['build', '-t', '${mainProject!.name}:dev', '.'],
    workingDirectory: repository.root.directory('packages/server'),
    progress: progress,
  );
  print(
    green('Created image ${mainProject!.name}:dev'),
  );
}
