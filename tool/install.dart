import 'package:sidekick_core/sidekick_core.dart'
    hide cliName, repository, mainProject;
import 'package:sidekick_plugin_installer/sidekick_plugin_installer.dart';

import 'create_server_folder.dart';
import 'replace_template_dependencies.dart';

Future<void> main() async {
  final SidekickPackage package = PluginContext.sidekickPackage;
  addSelfAsDependency();
  await createServerFolder(package);

  pubGet(package);
  final commandFolder = package.root.directory('lib/src/commands/dockerize');
  if (!commandFolder.existsSync()) {
    commandFolder.createSync();
  }

  final dockerCommandFile = commandFolder.file('docker_command.dart');
  dockerCommandFile.writeAsStringSync(
    replaceTemplateDependencies(
      PluginContext.installerPlugin.root
          .file('template/docker_command.template.dart')
          .readAsLinesSync(),
      package.cliName,
    ).join('\n'),
  );

  final buildCommandFile = commandFolder.file('build_command.dart');
  PluginContext.installerPlugin.root
      .file('template/build_command.template.dart')
      .copySync(buildCommandFile.path);

  final runCommandFile = commandFolder.file('run_command.dart');
  runCommandFile.writeAsStringSync(
    replaceTemplateDependencies(
      PluginContext.installerPlugin.root
          .file('template/run_command.template.dart')
          .readAsLinesSync(),
      package.cliName,
    ).join('\n'),
  );

  final stopCommandFile = commandFolder.file('stop_command.dart');
  PluginContext.installerPlugin.root
      .file('template/stop_command.template.dart')
      .copySync(stopCommandFile.path);

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
