import 'package:sidekick_core/sidekick_core.dart';

class InitCommand extends Command {
  @override
  String get description =>
      'Initializes the Folder Structure for Dockerize in your packages folder';

  @override
  String get name => 'init';

  @override
  Future<void> run() async {}
}
