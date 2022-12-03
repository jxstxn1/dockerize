import 'package:dcli/dcli.dart' as dcli;
import 'package:sidekick_core/sidekick_core.dart';

class Dockerize extends Command {
  @override
  String get description => 'Dockerize your Flutter project';

  @override
  String get name => 'dockerize';

  @override
  Future<void> run() async {
    mainProject!.root.directory('server').createSync();
    mainProject!.root.directory('server/www').createSync();
    flutter(
      ['build', 'web'],
      workingDirectory: mainProject!.root,
    );

    copyTree(
      mainProject!.root.directory('build/web').path,
      mainProject!.root.directory('server/www').path,
    );
    dart(['pub', 'get'], workingDirectory: mainProject!.root.directory('server'));
    // copy all necessary files
    copyTree('lib/src/files', mainProject!.root.directory('server').path);

    // build the docker
    await createDockerImage();
  }

  Future<void> createDockerImage() async {
    dcli.run(
      'docker build -t ${mainProject!.name}:dev .',
      workingDirectory: mainProject!.root.directory('server').path,
    );
  }
}
