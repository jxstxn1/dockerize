import 'package:sidekick_core/sidekick_core.dart' hide cliName, repository, mainProject;
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
  pubGet(package);

  final commandFile = package.root.file('lib/src/commands/dockerize_command.dart');
  commandFile.writeAsStringSync(dockerizeFile);

  final folder = package.root.directory('../server');
  if (!folder.existsSync()) {
    folder.createSync();
    folder.directory('bin').createSync();
  }
  folder.directory('bin').file('server.dart').writeAsStringSync(serverFile);
  folder.file('Dockerfile').writeAsStringSync(dockerFile);
  folder.file('pubspec.yaml').writeAsStringSync(pubspecFile);
  pubGet(DartPackage(folder, 'server'));

  registerPlugin(
    sidekickCli: package,
    import: "import 'package:${package.name}/src/commands/dockerize_command.dart';",
    command: 'Dockerize()',
  );
}
