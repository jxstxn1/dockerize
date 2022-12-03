// language=Dart
const String serverFile = r'''
import 'dart:io';

import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';

// For Google Cloud Run, set _hostname to '0.0.0.0'.
const String _hostname = 'localhost';

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
  print('Serving at http://${server.address.host}:${server.port}');
}
''';

// language=Dockerfile
const String dockerFile = '''
FROM dart:stable AS build
# Copy shared submodule package
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get
# Ensure packages are still up-to-date if anything has changed
RUN dart pub get --offline
COPY server.dart ./bin/server.dart
RUN touch server
RUN dart compile exe bin/server.dart -o bin/server
# Build minimal serving image from AOT-compiled `/server` and required system
# libraries and configuration files stored in `/runtime/` from the build stage.
FROM scratch
# Copy runtime from build image
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /bin/
COPY /www ./bin/www
ENV APP_DIRECTORY=bin/www
# Start server.
EXPOSE 8080
CMD ["bin/server"]
''';

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

const dockerizeFile = r'''
import 'package:dcli/dcli.dart' as dcli;
import 'package:sidekick_core/sidekick_core.dart';

class Dockerize extends Command {
  @override
  String get description => 'Dockerize your Flutter project';

  @override
  String get name => 'dockerize';

  @override
  Future<void> run() async {
    repository.root.directory('packages/server').createSync();
    repository.root.directory('packages/server/www').createSync();
    flutter(
      ['build', 'web'],
      workingDirectory: mainProject!.root,
    );

    copyTree(
      mainProject!.root.directory('build/web').path,
      repository.root.directory('packages/server/www').path,
    );
    await createDockerImage();
  }

  Future<void> createDockerImage() async {
    dcli.run(
      'docker build -t ${mainProject!.name}:dev .',
      workingDirectory: repository.root.directory('packages/server').path,
    );
  }
}

''';
