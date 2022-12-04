import 'package:dcli/dcli.dart' as dcli;
import 'package:sidekick_core/sidekick_core.dart';

void createDockerImage() {
  dcli.run(
    'docker build -t ${mainProject!.name}:dev .',
    workingDirectory: repository.root.directory('packages/server').path,
  );
}
