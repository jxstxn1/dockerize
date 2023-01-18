import 'package:dockerize_sidekick_plugin/dockerize_sidekick_plugin.dart';
import 'package:sidekick_core/sidekick_core.dart';

class StopCommand extends Command {
  @override
  String get description => 'Stop the docker app';

  @override
  String get name => 'stop';

  @override
  Future<void> run() async {
    final logger = Logger();
    checkDockerInstall(logger);
    await stopImage(
      logger: logger,
      mainProjectName: mainProject!.name,
      workingDirectory: repository.root.directory('server'),
    );
  }
}
