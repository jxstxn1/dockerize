// language=Dart
const String serverFile = r'''
import 'dart:io';

import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';

// For Google Cloud Run, set _hostname to '0.0.0.0'.
const String _hostname = '0.0.0.0';

final appDirectory = Platform.environment['APP_DIRECTORY'] ?? 'www';

void main(List<String> args) async {
  final app = Router();
  // For Google Cloud Run, we respect the PORT environment variable
  var portStr = Platform.environment['PORT'] ?? '8080';
  var port = int.tryParse(portStr);

  if (!Directory(appDirectory).existsSync()) {
    throw "Can't serve APP_DIRECTORY $appDirectory, it doesn't exits";
  }
  var serveApp = createStaticHandler(appDirectory,
      defaultDocument: 'index.html', useHeaderBytesForContentType: true);

  final handleGet = shelf.Pipeline().addHandler(serveApp);

  app.get('/<anything|.*>', handleGet);

  var server = await io.serve(
    app,
    _hostname,
    port!,
    poweredByHeader: null,
  );
}
''';

// language=Dockerfile
const String dockerFile = '''
FROM dart:stable AS build
# Copy shared submodule package
WORKDIR /app
COPY pubspec.* ./
COPY /bin/ ./bin/

RUN dart pub get
# Ensure packages are still up-to-date if anything has changed
RUN dart pub get --offline
RUN dart compile exe bin/server.dart -o bin/server
# Build minimal serving image from AOT-compiled `/server` and required system
# libraries and configuration files stored in `/runtime/` from the build stage.
FROM scratch
# Copy runtime from build image
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /bin/
COPY /www ./www
ENV APP_DIRECTORY=www
# Start server.
EXPOSE 8080
CMD ["bin/server"]
''';

// language=Yaml
const pubspecFile = '''
name: dockerize_server
description: A new Dockerized Flutter App


publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: ">=2.15.0 <3.0.0"

dependencies:
  shelf_static: ^1.1.0
  shelf_router: ^1.1.3

''';

// language=Dart
String dockerCommandContent(String packageName) => '''
import 'package:sidekick_core/sidekick_core.dart';
import 'package:$packageName/src/commands/dockerize/build_command.dart';
import 'package:$packageName/src/commands/dockerize/run_command.dart';
import 'package:$packageName/src/commands/dockerize/stop_command.dart';

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
}
''';

// language=Dart
const buildCommandContent = '''
import 'package:dockerize_sidekick_plugin/dockerize_sidekick_plugin.dart';
import 'package:sidekick_core/sidekick_core.dart';

class BuildCommand extends Command {
  @override
  String get description => 'Builds a docker image for your Flutter Web App';

  @override
  String get name => 'build';

  @override
  Future<void> run() async {
    checkDockerInstall();

    // You can insert your own logic here before building the Flutter app

    flutter(
      // You can change any build arguments here like --release
      // Check out `flutter build web --help` for more information
      ['build', 'web'],
      workingDirectory: mainProject!.root,
    );

    // You can insert your own logic here after building the Flutter app

    moveToServerDirectory();

    // You can insert your own logic here after moving the Flutter app to the server directory (packages/server/www)
    // and before building the Docker image

    createDockerImage();
  }  
}
''';

// language=Dart
String runCommandContent(String packageName) => '''
import 'package:dcli/dcli.dart' as dcli;
import 'package:dockerize_sidekick_plugin/dockerize_sidekick_plugin.dart';
import 'package:sidekick_core/sidekick_core.dart';
import 'package:$packageName/src/commands/dockerize/build_command.dart';

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
  }

  @override
  Future<void> run() async {
    checkDockerInstall();
    final withBuildCommand = argResults!['build'] as bool;
    if (withBuildCommand) {
      await BuildCommand().run();
    }
    dcli.run(
      'docker run -d --rm -p 8000:8080 --name \${mainProject!.name} \${mainProject!.name}:dev',
    );
    print(green('App is running on http://localhost:8000'));
  }
}
''';

// language=Dart
const stopCommandContent = '''
import 'package:dockerize_sidekick_plugin/dockerize_sidekick_plugin.dart';
import 'package:sidekick_core/sidekick_core.dart';

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
''';
