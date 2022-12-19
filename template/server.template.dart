import 'dart:io';

import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';

import 'middlewares.template.dart'; //template import
/* installed import
import 'middlewares.dart';
installed import */

// For Google Cloud Run, set _hostname to '0.0.0.0'.
const String _hostname = '0.0.0.0';

final appDirectory = Platform.environment['APP_DIRECTORY'] ?? 'www';

void main(List<String> args) async {
  final app = Router();
  // For Google Cloud Run, we respect the PORT environment variable
  final portStr = Platform.environment['PORT'];
  final port = int.tryParse(portStr ?? '8000');

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
  if (portStr == null) {
    print('Serving at http://localhost:$port');
    print(
      'Note: If you used the -p --port option, the actuall port is different',
    );
  }
}
