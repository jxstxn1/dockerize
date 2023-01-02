import 'package:dockerize_sidekick_plugin/src/util/command_runner.dart';
import 'package:sidekick_core/sidekick_core.dart';

/// Creates a docker image
void createDockerImage(String environmentName) {
  print(
    green('Creating image ${mainProject!.name}:$environmentName'),
  );
  commandRunner(
    'docker',
    ['build', '-t', '${mainProject!.name}:$environmentName', '.'],
    workingDirectory: repository.root.directory('server'),
    successMessage: 'Created image ${mainProject!.name}:$environmentName',
  );
}
