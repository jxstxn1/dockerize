import 'package:sidekick_core/sidekick_core.dart';

// This moves the build web project to the server/www directory
void moveToServerDirectory() {
  SidekickContext.projectRoot
      .directory('server/www')
      .createSync(recursive: true);
  copyTree(
    mainProject!.root.directory('build/web').path,
    SidekickContext.projectRoot.directory('server').directory('www').path,
    overwrite: true,
  );
}
