import 'dart:convert';
import 'dart:io' as io;

import 'package:dockerize_sidekick_plugin/dockerize_sidekick_plugin.dart';
import 'package:sidekick_core/sidekick_core.dart';

/// Starting the docker image
Future<void> runImage({
  required String environmentName,
  String? port,
  bool background = false,
}) async {
  final mainProjectName = mainProject!.name;
  final workingDir = repository.root.directory('server');
  final process = await io.Process.start(
    'docker',
    [
      'run',
      if (background) ...['-d'],
      '--rm',
      '-p',
      '$port:8080',
      '--name',
      mainProject!.name,
      '${mainProject!.name}:$environmentName',
    ],
  );

  ProcessSignal.sigint
      .watch()
      .listen((_) => _killProcess(process, mainProjectName, workingDir));

  process.stderr.listen((_) async {
    final message = utf8.decode(_).trim();
    if (message.isEmpty) return;
    print(red(message));
    await _killProcess(process, mainProjectName, workingDir);
  });

  process.stdout.listen((_) {
    final message = utf8.decode(_).trim();
    if (message.isEmpty) return;
    print(message);
  });
}

Future<void> _killProcess(
  io.Process process,
  String mainProjectName,
  Directory workingDir,
) async {
  stopImage(mainProjectName: mainProjectName, workingDirectory: workingDir);
  process.kill();
  exit(1);
}
