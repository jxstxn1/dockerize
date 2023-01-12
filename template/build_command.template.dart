import 'package:dockerize_sidekick_plugin/dockerize_sidekick_plugin.dart';
import 'package:sidekick_core/sidekick_core.dart';

import 'environment.template.dart'; //template import
/* installed import
import 'package:<<packageName>>/src/commands/dockerize/environment.dart';
installed import */

class BuildCommand extends Command {
  @override
  String get description => 'Builds a docker image for your Flutter Web App';

  @override
  String get name => 'build';

  final Set<DockerizeEnvironment> _environments = DockerizeEnvironments.all;

  BuildCommand() {
    argParser.addOption(
      'env',
      allowed: _environments.map((it) => it.name),
      help: 'The environment to build the docker image for',
    );
    argParser.addFlag(
      'docker-only',
      abbr: 'd',
      help: 'Builds only the docker image',
    );
  }

  @override
  Future<void> run() async {
    final Stopwatch allStopwatch = Stopwatch()..start();
    final Stopwatch flutterBuildStopwatch = Stopwatch();
    final Stopwatch dockerBuildStopwatch = Stopwatch();
    final String environmentName = argResults!['env'] as String? ?? 'dev';
    final bool shouldOnlyBuildDocker =
        argResults!['docker-only'] as bool? ?? false;
    final DockerizeEnvironment env =
        _environments.firstWhere((it) => it.name == environmentName);
    checkDockerInstall();

    if (!shouldOnlyBuildDocker) {
      // You can insert your own logic here before building the Flutter app

      flutterBuildStopwatch.start();
      flutter(
        // You can change any build arguments here like --release
        // Check out `flutter build web --help` for more information
        ['build', 'web'],
        workingDirectory: mainProject!.root,
      );
      flutterBuildStopwatch.stop();

      // You can insert your own logic here after building the Flutter app

      moveToServerDirectory();
    }

    // You can disable the hashScripts() function if you don't want to use CSP
    // You can change the hashType to sha384 or sha512 if you want

    hashScripts(hashType: sha256);

    // Setting enforceCSP to true will enforce the CSP rules in the template/middlewares.template.dart file
    if (env.shouldEnforceCSP) enforceCSP(shouldEnforce: env.shouldEnforceCSP);

    // You can insert your own logic here after moving the Flutter app to the server directory (packages/server/www)
    // and before building the Docker image

    createVersionFile(
      entries: {
        'environment': env.name,
        // You can add any other information you want to the version.json file here
      },
    );
    dockerBuildStopwatch.start();
    createDockerImage(env.name);
    dockerBuildStopwatch.stop();

    // Setting enforceCSP back to false after the build is done
    if (env.shouldEnforceCSP) enforceCSP(shouldEnforce: !env.shouldEnforceCSP);

    allStopwatch.stop();
    print(
      '[dockerize] Finished Dockerize build in ${allStopwatch.elapsedMilliseconds}ms',
    );
    if (!shouldOnlyBuildDocker) {
      print(
        '[dockerize]   - Flutter build took ${flutterBuildStopwatch.elapsedMilliseconds}ms',
      );
      print(
        '[dockerize]   - Docker build took ${dockerBuildStopwatch.elapsedMilliseconds}ms',
      );
    }

    // TODO: Remove this warning after updating the CSP rules in the template/middlewares.template.dart file
    print(
      yellow(
        '[dockerize] Warning: Update the CSP Rules in the template/middlewares.template.dart file to make the app production ready',
      ),
    );
  }
}
