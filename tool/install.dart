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

  final commandFile = commandFolder.file('dockerize_sidekick_plugin.dart');
  commandFile.writeAsStringSync(dockerizeFile);

  registerPlugin(
    sidekickCli: package,
    import:
        "import 'package:${package.name}/src/commands/dockerize/dockerize_sidekick_plugin.dart';",
    command: 'Dockerize()',
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
  serverFolder.file('Dockerfile').writeAsStringSync(dockerFile);
  serverFolder.file('pubspec.yaml').writeAsStringSync(pubspecFile);
  pubGet(DartPackage(serverFolder, 'server'));
}
