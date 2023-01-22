import 'package:dockerize_sidekick_plugin/dockerize_sidekick_plugin.dart';
import 'package:sidekick_core/sidekick_core.dart';
import 'environment.template.dart'; //template import
/* installed import
import 'package:<<packageName>>/src/commands/dockerize/environment.dart';
installed import */

class BuildScriptsCommand extends Command {
  @override
  String get description =>
      'Runs all custom build scripts after the flutter build and before the docker build';

  @override
  String get name => 'scripts';
  final Set<DockerizeEnvironment> _environments = DockerizeEnvironments.all;

  BuildScriptsCommand() {
    argParser.addOption(
      'env',
      allowed: _environments.map((it) => it.name),
      help: 'The environment to build the docker image for',
    );
  }

  @override
  Future<void> run() async {
    final logger = Logger();
    final String environmentName = argResults!['env'] as String? ?? 'dev';
    final DockerizeEnvironment env =
        _environments.firstWhere((it) => it.name == environmentName);

    // The hashScripts() function can be disabled if CSP is not desired.
    // The hashType can also be changed to sha384 or sha512 for added security.

    hashScripts(
      hashType: sha256,
      logger: logger,
      htmlFile: repository.root.directory('server/www').file('index.html'),
      middlewareFile: repository.root.file('server/bin/middlewares.dart'),
    );

    // Enabling the enforceCSP flag will enforce the Content Security Policy
    // rules defined in the template/middlewares.template.dart file
    enforceCSP(
      shouldEnforce: env.shouldEnforceCSP,
      middlewareFile: repository.root.file('server/bin/middlewares.dart'),
    );

    // Custom logic can be added here after the Flutter application has been
    // moved to the server directory (packages/server/www)
    // but before building the Docker image.

    writeToVersionFile(
      versionFile: repository.root.file('server/www/version.json'),
      entries: {
        'environment': env.name,
        // You can add any other information you want to the version.json file here
      },
    );
  }
}
