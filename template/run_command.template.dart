import 'package:sidekick_core/sidekick_core.dart';
import '../lib/dockerize_sidekick_plugin.dart'; //template import
import 'build_command.template.dart'; //template import
/* installed import
import 'package:dockerize_sidekick_plugin/dockerize_sidekick_plugin.dart';
import 'package:<<packageName>>/src/commands/dockerize/build_command.dart';
installed import */

class RunCommand extends Command {
  @override
  String get description => 'Run the dockerized app';

  @override
  String get name => 'run';

  RunCommand() {
    argParser.addFlag(
      'build',
      abbr: 'b',
      help: 'Call the docker build command before running',
    );
    argParser.addOption(
      'port',
      abbr: 'p',
      help: 'Port to run the app on',
    );
  }

  @override
  Future<void> run() async {
    checkDockerInstall();
    final withBuildCommand = argResults!['build'] as bool;
    final port = argResults?['port'] as String?;
    if (port != null) {
      final isPort = RegExp(r'^[0-9]{1,4}\$').hasMatch(port);
      if (!isPort) {
        print(red('Port must be a number with a max of 4 digits'));
        exit(1);
      }
    }
    if (withBuildCommand) {
      await BuildCommand().run();
    }
    runImage(port: port);
  }
}
