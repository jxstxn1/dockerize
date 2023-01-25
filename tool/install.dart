import 'package:sidekick_core/sidekick_core.dart'
    hide cliName, repository, mainProject;
import 'package:sidekick_plugin_installer/sidekick_plugin_installer.dart';

import 'create_if_not_exists.dart';
import 'create_server_folder.dart';
import 'replace_template_dependencies.dart';

Future<void> main() async {
  final SidekickPackage package = PluginContext.sidekickPackage;

  addSelfAsDependency();
  await createServerFolder(package);

  pubGet(package);
  final commandFolder =
      package.root.directory('lib/src/commands/dockerize').createIfNotExists();

  final dockerCommandFile = commandFolder.file('docker_command.dart');
  dockerCommandFile.writeAsStringSync(
    replaceTemplateDependencies(
      PluginContext.installerPlugin.root
          .file('template/docker_command.template.dart')
          .readAsLinesSync(),
      package.cliName,
    ).join('\n'),
  );

  final environmentFile = commandFolder.file('environment.dart');
  PluginContext.installerPlugin.root
      .file('template/environment.template.dart')
      .copySync(environmentFile.path);

  commandFolder.directory('build').createIfNotExists();

  final buildCommandFile = commandFolder.file('build/build_command.dart');
  buildCommandFile.writeAsStringSync(
    replaceTemplateDependencies(
      PluginContext.installerPlugin.root
          .file('template/build_command.template.dart')
          .readAsLinesSync(),
      package.cliName,
    ).join('\n'),
  );

  final buildAppCommandFile =
      commandFolder.file('build/build_app_command.dart');
  buildAppCommandFile.writeAsStringSync(
    replaceTemplateDependencies(
      PluginContext.installerPlugin.root
          .file('template/build_app_command.template.dart')
          .readAsLinesSync(),
      package.cliName,
    ).join('\n'),
  );

  final buildImageCommandFile =
      commandFolder.file('build/build_image_command.dart');
  buildImageCommandFile.writeAsStringSync(
    replaceTemplateDependencies(
      PluginContext.installerPlugin.root
          .file('template/build_image_command.template.dart')
          .readAsLinesSync(),
      package.cliName,
    ).join('\n'),
  );

  final buildScriptsCommandFile =
      commandFolder.file('build/build_scripts_command.dart');
  buildScriptsCommandFile.writeAsStringSync(
    replaceTemplateDependencies(
      PluginContext.installerPlugin.root
          .file('template/build_scripts_command.template.dart')
          .readAsLinesSync(),
      package.cliName,
    ).join('\n'),
  );

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
