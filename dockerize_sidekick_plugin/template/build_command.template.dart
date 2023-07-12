import 'package:sidekick_core/sidekick_core.dart';

import 'build_app_command.template.dart'; //template import
import 'build_image_command.template.dart'; //template import
import 'environment.template.dart'; //template import
/* installed import

import 'package:<<packageName>>/src/commands/dockerize/build_commands/build_app_command.dart';
import 'package:<<packageName>>/src/commands/dockerize/build_commands/build_image_command.dart';
import 'package:<<packageName>>/src/commands/dockerize/environment.dart';
installed import */

class BuildCommand extends Command {
  @override
  String get description => 'Builds a docker image for your Flutter Web App';

  @override
  String get name => 'build';

  final Set<DockerizeEnvironment> _environments = DockerizeEnvironments.all;

  BuildCommand() {
    addSubcommand(BuildImageCommand());
    addSubcommand(BuildAppCommand());
    argParser.addOption(
      'env',
      allowed: _environments.map((it) => it.name),
      help: 'The environment to build the docker image for',
    );
  }
}
