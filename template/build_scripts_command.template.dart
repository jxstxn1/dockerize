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
    final String environmentName = argResults!['env'] as String? ?? 'dev';
    final DockerizeEnvironment env =
        _environments.firstWhere((it) => it.name == environmentName);

    // You can disable the hashScripts() function if you don't want to use CSP
    // You can change the hashType to sha384 or sha512 if you want

    hashScripts(hashType: sha256);

    // Setting enforceCSP to true will enforce the CSP rules in the template/middlewares.template.dart file
    if (env.shouldEnforceCSP) {
      enforceCSP(
        shouldEnforce: env.shouldEnforceCSP,
        middlewareFile: repository.root.file('server/bin/middlewares.dart'),
      );
    }

    // You can insert your own logic here after moving the Flutter app to the server directory (packages/server/www)
    // and before building the Docker image

    writeToVersionFile(
      versionFile: repository.root.file('server/www/version.json'),
      entries: {
        'environment': env.name,
        // You can add any other information you want to the version.json file here
      },
    );
  }
}
