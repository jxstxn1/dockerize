import 'package:dockerize_sidekick_plugin/dockerize_sidekick_plugin.dart';
import 'package:sidekick_core/sidekick_core.dart';

class BuildAppCommand extends Command {
  @override
  String get description =>
      'Build the Flutter Web App and runs the build scripts';

  @override
  String get name => 'app';

  @override
  Future<void> run() async {
    // You can insert your own logic here before building the Flutter app

    flutter(
      // You can change any build arguments here like --release
      // Check out `flutter build web --help` for more information
      ['build', 'web'],
      workingDirectory: mainProject!.root,
    );

    // You can insert your own logic here after building the Flutter app
    moveToServerDirectory();
  }
}
