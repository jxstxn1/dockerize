import 'package:dockerize_sidekick_plugin/src/util/command_runner.dart';
import 'package:dockerize_sidekick_plugin/src/util/locate_server_folder.dart';
import 'package:sidekick_core/sidekick_core.dart';

/// Stoping the currently running docker image
void stopImage({bool silent = false}) {
  commandRunner(
    'docker',
    ['kill', mainProject!.name],
    workingDirectory: locateServerFolder(),
    silent: silent,
  );
  if (!silent) print(green('Stopped app: ${mainProject!.name}:dev'));
}
