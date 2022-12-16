import 'package:sidekick_core/sidekick_core.dart';

// This moves the build web project to the server/www directory
void moveToServerDirectory() {
  repository.root
      .directory('server')
      .directory('www')
      .createSync(recursive: true);
  copyTree(
    mainProject!.root.directory('build/web').path,
    repository.root.directory('server').directory('www').path,
    overwrite: true,
  );
}
