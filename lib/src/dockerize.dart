import 'package:dcli/dcli.dart' as dcli;
import 'package:sidekick_core/sidekick_core.dart';

class Dockerize extends Command {
  @override
  String get description => 'Dockerize your Flutter project';

  @override
  String get name => 'dockerize';

  @override
  Future<void> run() async {
    mainProject!.root.directory('temp').createSync();
    mainProject!.root.directory('temp/www').createSync();
    flutter(
      ['build', 'web'],
      workingDirectory: mainProject!.root,
    );

    copyTree(
      mainProject!.root.directory('build/web').path,
      mainProject!.root.directory('temp/www').path,
    );
    await createPubspec();
    await createDockerFile();
    await createServer();
    dart(['pub', 'get'], workingDirectory: mainProject!.root.directory('temp'));
    await createDockerImage();
  }

  Future<void> createDockerImage() async {
    dcli.run(
      'docker build -t ${mainProject!.name}:dev .',
      workingDirectory: mainProject!.root.directory('temp').path,
    );
  }

  Future<void> createServer() async {
    final server = mainProject!.root.directory('temp').file('server.dart');
    server.writeAsStringSync('''
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
    throw "Can't serve APP_DIRECTORY \$appDirectory, it doesn't exits";
  }
  var serveApp = createStaticHandler(appDirectory, defaultDocument: 'index.html', useHeaderBytesForContentType: true);

  final handleGet = shelf.Pipeline()
      .addHandler(serveApp);
  
  app.get('/<anything|.*>', handleGet);

  var server = await io.serve(
    app,
    _hostname,
    port!,
    poweredByHeader: null,
  );
  print('Serving at http://\${server.address.host}:\${server.port}');
}
''');
  }

  Future<void> createPubspec() async {
    final pubspec = mainProject!.root.directory('temp').file('pubspec.yaml');
    pubspec.writeAsStringSync('''
name: locker
description: A new Flutter project.


publish_to: 'none' # Remove this line if you wish to publish to pub.dev

version: 1.0.0+1

environment:
  sdk: ">=2.15.0 <3.0.0"

dependencies:
  shelf_static: ^1.1.0
  shelf_router: ^1.1.3
  encrypt: ^5.0.1
''');
  }

  Future<void> createDockerFile() async {
    final File dockerfile =
        await mainProject!.root.directory('temp').file('Dockerfile').create();
    dockerfile.writeAsStringSync('''
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
''');
  }
}
