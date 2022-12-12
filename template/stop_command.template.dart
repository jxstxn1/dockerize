import 'package:sidekick_core/sidekick_core.dart';

import '../lib/dockerize_sidekick_plugin.dart'; //template import
/* installed import
import 'package:dockerize_sidekick_plugin/dockerize_sidekick_plugin.dart';
installed import */

class StopCommand extends Command {
  @override
  String get description => 'Stop the docker app';

  @override
  String get name => 'stop';

  @override
  Future<void> run() async {
    checkDockerInstall();
    stopImage();
  }
}
