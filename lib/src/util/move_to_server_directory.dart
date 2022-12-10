import 'package:dockerize_sidekick_plugin/src/util/locate_server_folder.dart';
import 'package:sidekick_core/sidekick_core.dart';

// This moves the build web project to the server/www directory
void moveToServerDirectory() {
  locateServerFolder().directory('www').createSync(recursive: true);
  copyTree(
    mainProject!.root.directory('build/web').path,
    locateServerFolder().path,
    overwrite: true,
  );
}
