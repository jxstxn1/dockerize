import 'package:dockerize_sidekick_plugin/src/util/command_runner.dart';
import 'package:sidekick_core/sidekick_core.dart';

/// Stoping the currently running docker image
void stopImage() {
  commandRunner(
    'docker',
    ['kill', mainProject!.name],
    workingDirectory: repository.root,
  );
  print(green('Stopped app: ${mainProject!.name}:dev'));
}
