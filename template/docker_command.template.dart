import 'package:dockerize_sidekick_plugin/dockerize_sidekick_plugin.dart';
import 'package:sidekick_core/sidekick_core.dart';

import 'build_command.template.dart'; //template import
import 'run_command.template.dart'; //template import
import 'stop_command.template.dart'; //template import
/* installed import 
import 'package:<<packageName>>/src/commands/dockerize/build_command.dart';
import 'package:<<packageName>>/src/commands/dockerize/run_command.dart';
import 'package:<<packageName>>/src/commands/dockerize/stop_command.dart';
installed import */

class DockerCommand extends Command {
  @override
  String get description => 'Manage all the docker related commands';

  @override
  String get name => 'docker';

  DockerCommand() {
    addSubcommand(BuildCommand());
    addSubcommand(RunCommand());
    addSubcommand(StopCommand());
  }

  @override
  String get usage => printUsage(cliName);
}
