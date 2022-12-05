import 'package:sidekick_core/sidekick_core.dart'
    hide cliName, repository, mainProject;
import 'package:sidekick_plugin_installer/sidekick_plugin_installer.dart';

import 'template.dart';

Future<void> main() async {
  final SidekickPackage package = PluginContext.sidekickPackage;

  if (PluginContext.localPlugin == null) {
    pubAddDependency(package, 'dockerize_sidekick_plugin');
  } else {
    // For local development
    pubAddLocalDependency(package, PluginContext.localPlugin!.root.path);
  }
  await createServerFolder(package);
  pubGet(package);
  final commandFolder = package.root.directory('lib/src/commands/dockerize');
  if (!commandFolder.existsSync()) {
    commandFolder.createSync();
  }

  final dockerCommandFile = commandFolder.file('docker_command.dart');
  dockerCommandFile.writeAsStringSync(dockerCommandContent(package.name));

  final buildCommandFile = commandFolder.file('build_command.dart');
  buildCommandFile.writeAsStringSync(buildCommandContent);

  final runCommandFile = commandFolder.file('run_command.dart');
  runCommandFile.writeAsStringSync(runCommandContent(package.name));

  final stopCommandFile = commandFolder.file('stop_command.dart');
  stopCommandFile.writeAsStringSync(stopCommandContent);

  await registerPlugin(
    sidekickCli: package,
    import:
        "import 'package:${package.name}/src/commands/dockerize/docker_command.dart';",
    command: 'DockerCommand()',
  );
  print(
    'Run: ${package.cliName} docker --help to see all commands and options',
  );
}

Future<void> createServerFolder(SidekickPackage package) async {
  final serverFolder = package.root.directory('../server');
  if (!serverFolder.existsSync()) {
    serverFolder.createSync();
    serverFolder.directory('bin').createSync();
  }

  serverFolder
      .directory('bin')
      .file('server.dart')
      .writeAsStringSync(serverFile);

  serverFolder
      .directory('bin')
      .file('middlewares.dart')
      .writeAsStringSync(middlewareFileContent);

  serverFolder.file('Dockerfile').writeAsStringSync(dockerFile);
  serverFolder.file('pubspec.yaml').writeAsStringSync(pubspecFile);
  pubGet(DartPackage(serverFolder, 'server'));
}
