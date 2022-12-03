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

  final handleGet = shelf.Pipeline().addHandler(serveApp);

  app.get('/<anything|.*>', handleGet);

  var server = await io.serve(
    app,
    _hostname,
    port!,
    poweredByHeader: null,
  );
  print('Serving at http://\${server.address.host}:\${server.port}');
}
