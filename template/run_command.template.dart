import 'package:dockerize_sidekick_plugin/dockerize_sidekick_plugin.dart';
import 'package:sidekick_core/sidekick_core.dart';

import 'environment.template.dart'; //template import
/* installed import
import 'package:<<packageName>>/src/commands/dockerize/environment.dart';
installed import */

class RunCommand extends Command {
  @override
  String get description => 'Run the dockerized app';

  @override
  String get name => 'run';

  final Set<DockerizeEnvironment> _environments = DockerizeEnvironments.all;

  RunCommand() {
    argParser.addFlag(
      'build-all',
      abbr: 'b',
      help: 'Call the docker build command before running',
    );
    argParser.addFlag(
      'build-container',
      help: 'Builds the docker container before running',
    );
    argParser.addFlag(
      'background',
      help: 'Run the app in the background',
    );
    argParser.addOption(
      'env',
      allowed: _environments.map((it) => it.name),
      help: 'The environment to build the docker image for',
    );
    argParser.addOption(
      'port',
      abbr: 'p',
      help: 'Port to run the app on',
    );
  }

  @override
  Future<void> run() async {
    final String environmentName = argResults!['env'] as String? ?? 'dev';
    final DockerizeEnvironment env =
        _environments.firstWhere((it) => it.name == environmentName);
    final withBuildAll = argResults!['build-all'] as bool;
    final withBuildContainer = argResults!['build-container'] as bool;
    final background = argResults!['background'] as bool;
    final port = argResults?['port'] as String? ?? '8000';

    checkDockerInstall();

    /// Stoping all other running containers from the project
    stopImage(silent: true);

    if (!isPortValid(port)) {
      exit(1);
    }

    if (withBuildAll || withBuildContainer) {
      await executeBuild(
        buildContainer: withBuildContainer,
        envName: env.name,
      );
    }

    print(
      '[dockerize] Running ${mainProject!.name} on http://localhost:$port\n[dockerize] ${yellow('Press ctrl-c to stop the app')}',
    );

    runImage(
      port: port,
      background: background,
      mainProject: mainProject,
      environmentName: env.name,
    );
  }
}
