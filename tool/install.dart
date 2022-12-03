import 'package:sidekick_core/sidekick_core.dart'
    hide cliName, repository, mainProject;
import 'package:sidekick_plugin_installer/sidekick_plugin_installer.dart';

Future<void> main() async {
  final SidekickPackage package = PluginContext.sidekickPackage;

  if (PluginContext.localPlugin == null) {
    pubAddDependency(package, 'dockerize_sidekick_plugin');
  } else {
    // For local development
    pubAddLocalDependency(package, PluginContext.localPlugin!.root.path);
  }
  pubGet(package);

  final commandFile =
      package.root.file('lib/src/dockerize_sidekick_plugin.dart');
  final dockerize =
      PluginContext.localPlugin!.libDir.file('src/dockerize.dart');
  commandFile.writeAsStringSync(dockerize.readAsStringSync());

  registerPlugin(
    sidekickCli: package,
    import:
        "import 'package:${package.name}/src/dockerize_sidekick_plugin.dart';",
    command: 'Dockerize()',
  );
}
