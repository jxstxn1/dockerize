import 'package:sidekick_core/sidekick_core.dart';

import 'build_app_command.template.dart'; //template import
import 'build_image_command.template.dart'; //template import
import 'build_scripts_command.template.dart'; //template import
/* installed import
import 'package:<<packageName>>/src/commands/dockerize/build_app_command.dart';
import 'package:<<packageName>>/src/commands/dockerize/build_image_command.dart';
import 'package:<<packageName>>/src/commands/dockerize/build_scripts_command.dart';
installed import */

class BuildCommand extends Command {
  @override
  String get description => 'Builds a docker image for your Flutter Web App';

  @override
  String get name => 'build';

  BuildCommand() {
    addSubcommand(BuildImageCommand());
    addSubcommand(BuildAppCommand());
    addSubcommand(BuildScriptsCommand());
  }
}
