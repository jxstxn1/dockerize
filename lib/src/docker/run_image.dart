import 'package:dcli/dcli.dart' as dcli;
import 'package:sidekick_core/sidekick_core.dart';

/// Starting the docker image
void runImage({
  required String environmentName,
  String? port,
  bool background = false,
}) {
  final String publicPort = port ?? '8000';
  print(
    'Running ${mainProject!.name} on https://localhost:$publicPort\n${yellow('Press ctrl-c twice to stop the app')}',
  );
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
      '${mainProject!.name}:$environmentName',
    ],
    terminal: true,
    workingDirectory: repository.root.directory('server').path,
  );
}
