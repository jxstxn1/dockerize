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
      'without-hot-reload',
      help: 'Run the app without hot reload',
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
    final Logger logger = Logger();
    final String environmentName = argResults!['env'] as String? ?? 'dev';
    final DockerizeEnvironment env =
        _environments.firstWhere((it) => it.name == environmentName);
    final port = argResults?['port'] as String? ?? '8000';
    final withoutHotReload = argResults!['without-hot-reload'] as bool;

    checkDockerInstall(logger);

    if (!isPortValid(port, logger)) {
      exitCode = 1;
      return;
    }

    if (!isDockerRunning(logger)) {
      exitCode = 1;
      return;
    }

    /// Stopping all other running containers from the project
    await stopImage(
      silent: true,
      logger: logger,
      mainProjectName: mainProject!.name,
      workingDirectory: SidekickContext.projectRoot.directory('server'),
    );
    await createDockerImage(
      entryPointPath: SidekickContext.entryPoint.path,
      logger: logger,
      workingDirectoryPath:
          SidekickContext.projectRoot.directory('server').path,
      environment: env,
    );

    logger.info(
      '[dockerize] Running ${mainProject!.name} on http://localhost:$port',
    );
    logger.info(
      withoutHotReload
          ? '[dockerize] Hot-Reload is not enabled'
          : '[dockerize] Hot-Reload is enabled',
    );
    logger.warn('[dockerize] Press ctrl-c to stop the app');

    runImage(
      environment: env,
      port: port,
      mainProject: mainProject,
      withoutHotReload: withoutHotReload,
    );
  }
}
