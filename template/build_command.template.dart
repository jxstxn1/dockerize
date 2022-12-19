import 'package:dockerize_sidekick_plugin/dockerize_sidekick_plugin.dart';
import 'package:sidekick_core/sidekick_core.dart';

class BuildCommand extends Command {
  @override
  String get description => 'Builds a docker image for your Flutter Web App';

  @override
  String get name => 'build';

  @override
  Future<void> run() async {
    checkDockerInstall();

    // You can insert your own logic here before building the Flutter app

    flutter(
      // You can change any build arguments here like --release
      // Check out `flutter build web --help` for more information
      ['build', 'web'],
      workingDirectory: mainProject!.root,
    );

    // You can insert your own logic here after building the Flutter app

    moveToServerDirectory();

    // You can disable the hashScripts() function if you don't want to use CSP

    hashScripts(hashType: sha256);

    // You can insert your own logic here after moving the Flutter app to the server directory (packages/server/www)
    // and before building the Docker image

    createDockerImage();

    // TODO: Remove this warning in production
    print(
      yellow(
        'Warning: Update the CSP Rules in the template/middlewares.template.dart file to make the app production ready',
      ),
    );
  }
}
