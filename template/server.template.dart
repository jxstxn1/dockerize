import 'dart:io';

import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';

import 'middlewares.template.dart'; //template import
/* installed import
import 'middlewares.dart';
installed import */

/// Whether the app runs locally or on Google Cloud Run
const bool runsLocally = bool.fromEnvironment('runs-locally');

// For Google Cloud Run, set _hostname to '0.0.0.0'.
const String _hostname = runsLocally ? 'localhost' : '0.0.0.0';

final appDirectory = runsLocally
    ? Directory('server/www').path
    : Platform.environment['APP_DIRECTORY'] ?? 'www';

void main(List<String> args) async {
  final app = Router();
  // For Google Cloud Run, we respect the PORT environment variable
  final portStr = Platform.environment['PORT'];
  final port = runsLocally ? 3000 : int.tryParse(portStr ?? '8080');

  if (!Directory(appDirectory).existsSync()) {
    throw "Can't serve APP_DIRECTORY $appDirectory, it doesn't exits";
  }
  final serveApp = createStaticHandler(
    appDirectory,
    defaultDocument: 'index.html',
    useHeaderBytesForContentType: true,
  );

  final handleGet = const shelf.Pipeline()
      .addMiddleware(middlewares([]))
      .addHandler(serveApp);

  app.get('/<anything|.*>', handleGet);

  await io.serve(
    app,
    _hostname,
    port!,
    poweredByHeader: null,
  );
  if (runsLocally) {
    print('Serving at http://$_hostname:$port');
  }
}
