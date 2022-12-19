import 'package:dcli/dcli.dart' as dcli;
import 'package:dockerize_sidekick_plugin/dockerize_sidekick_plugin.dart';
import 'package:sidekick_core/sidekick_core.dart';

/// Starting the docker image
void runImage({String? port, bool background = false}) {
  final String publicPort = port ?? '8000';
  stopImage(silent: true);
  print('Running ${mainProject!.name} on https://localhost:$publicPort');
  dcli.startFromArgs(
    'docker',
    [
      'run',
      if (background) ...[
        '-d'
      ] else ...[
        '--sig-proxy=false',
        '--detach-keys=ctrl-c',
        '-it',
      ],
      '--rm',
      '-p',
      '$publicPort:8080',
      '--name',
      mainProject!.name,
      '${mainProject!.name}:dev',
    ],
    terminal: true,
    workingDirectory: repository.root.directory('server').path,
  );
}
