import 'package:sidekick_core/sidekick_core.dart'
    hide cliName, repository, mainProject;
import 'package:sidekick_plugin_installer/sidekick_plugin_installer.dart';
import 'create_if_not_exists.dart';
import 'replace_template_dependencies.dart';

/// Creates the server folder and files
Future<void> createServerFolder(SidekickPackage package) async {
  final serverFolder =
      findRepository().root.directory('server').createIfNotExists();
  serverFolder.directory('bin').createIfNotExists();

  serverFolder.file('bin/server.dart').writeAsStringSync(
        replaceTemplateDependencies(
          PluginContext.installerPlugin.root
              .file('template/server.template.dart')
              .readAsLinesSync(),
          package.cliName,
        ).join('\n'),
      );

  serverFolder.file('bin/middlewares.dart').writeAsStringSync(
        PluginContext.installerPlugin.root
            .file('template/middlewares.template.dart')
            .readAsStringSync(),
      );

  serverFolder.file('Dockerfile').writeAsStringSync(
        PluginContext.installerPlugin.root
            .file('template/Dockerfile.template')
            .readAsStringSync(),
      );
  serverFolder.file('pubspec.yaml').writeAsStringSync(
        PluginContext.installerPlugin.root
            .file('template/pubspec.template.yaml')
            .readAsStringSync(),
      );
  serverFolder.file('analysis_options.yaml').writeAsStringSync(
        PluginContext.installerPlugin.root
            .file('template/analysis_options.template.yaml')
            .readAsStringSync(),
      );
  serverFolder.file('README.md').writeAsStringSync(
        PluginContext.installerPlugin.root
            .file('template/README.template.md')
            .readAsStringSync(),
      );
  pubGet(DartPackage(serverFolder, 'server'));
}
