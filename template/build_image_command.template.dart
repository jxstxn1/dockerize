import 'package:dockerize_sidekick_plugin/dockerize_sidekick_plugin.dart';
import 'package:sidekick_core/sidekick_core.dart';

import 'environment.template.dart'; //template import
/* installed import
import 'package:<<packageName>>/src/commands/dockerize/environment.dart';
installed import */

class BuildImageCommand extends Command {
  @override
  String get description =>
      'Build the docker image and runs build app and build scripts before';

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
    argParser.addFlag(
      'build-scripts',
      help: 'Runs build scripts before',
      defaultsTo: true,
    );
  }

  @override
  Future<void> run() async {
    final logger = Logger();
    final String environmentName = argResults!['env'] as String? ?? 'dev';
    final DockerizeEnvironment env =
        _environments.firstWhere((it) => it.name == environmentName);
    checkDockerInstall(logger);
    await createDockerImage(
      env.name,
      logger: logger,
    );
  }
}