import 'package:dockerize_sidekick_plugin/dockerize_sidekick_plugin.dart';
import 'package:sidekick_core/sidekick_core.dart';

import 'environment.template.dart'; //template import
/* installed import
import 'package:<<packageName>>/src/commands/dockerize/environment.dart';
installed import */

class BuildImageCommand extends Command {
  @override
  String get description => 'Build the docker image and runs build app';

  @override
  String get name => 'image';

  final Set<DockerizeEnvironment> _environments = DockerizeEnvironments.all;

  BuildImageCommand() {
    argParser.addOption(
      'env',
      allowed: _environments.map((it) => it.name),
      help: 'The environment to build the docker image for',
    );
    argParser.addFlag(
      'build-app',
      help: 'Runs build app before',
      defaultsTo: true,
    );
  }

  @override
  Future<void> run() async {
    final logger = Logger();
    final bool buildApp = argResults!['build-app'] as bool;
    final String environmentName = argResults!['env'] as String? ?? 'dev';
    final DockerizeEnvironment env =
        _environments.firstWhere((it) => it.name == environmentName);
    checkDockerInstall(logger);

    await createDockerImage(
      logger: logger,
      entryPointPath: SidekickContext.entryPoint.path,
      buildFlutter: buildApp,
      environment: env,
      workingDirectoryPath:
          SidekickContext.projectRoot.directory('server').path,
    );
  }
}
