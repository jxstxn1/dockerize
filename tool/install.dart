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
  commandFile.writeAsStringSync("""
import 'package:sidekick_core/sidekick_core.dart';
import 'package:dockerize_sidekick_plugin/dockerize_sidekick_plugin.dart';

class DockerizeSidekickPluginCommand extends Command {
  @override
  final String description = 'Sample command';

  @override
  final String name = 'dockerize-sidekick-plugin';

  DockerizeSidekickPluginCommand() {
    // add parameters here with argParser.addOption
  }

  @override
  Future<void> run() async {
    // please implement me
    final hello = getGreetings().shuffled().first;
    print('\$hello from PHNTM!');
    
    final bye = getFarewells().shuffled().first;
    print('\$bye from PHNTM!');
  }
}

""");

  registerPlugin(
    sidekickCli: package,
    import:
        "import 'package:${package.name}/src/dockerize_sidekick_plugin.dart';",
    command: 'DockerizeSidekickPluginCommand()',
  );
}
