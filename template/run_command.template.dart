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
      help: 'Calls all build commands before running',
    );
    argParser.addFlag(
      'build-scripts',
      help: 'Runs the build scripts before running',
    );
    argParser.addFlag(
      'build-image',
      help: 'Builds the docker image before running',
    );
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
    final withBuildAll = argResults!['build-all'] as bool;
    final withBuildScripts = argResults!['build-scripts'] as bool;
    final withBuildImage = argResults!['build-image'] as bool;
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

    if (withBuildAll || withBuildScripts) {
      await createDockerImage(
        env.name,
        entryPointPath: SidekickContext.entryPoint.path,
        logger: logger,
        buildFlutter: !withBuildScripts,
        workingDirectoryPath:
            SidekickContext.projectRoot.directory('server').path,
      );
    } else if (withBuildImage) {
      await createDockerImage(
        env.name,
        entryPointPath: SidekickContext.entryPoint.path,
        logger: logger,
        buildScripts: false,
        buildFlutter: false,
        workingDirectoryPath:
            SidekickContext.projectRoot.directory('server').path,
      );
    }

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
      port: port,
      mainProject: mainProject,
      environmentName: env.name,
      withoutHotReload: withoutHotReload,
    );
  }
}
