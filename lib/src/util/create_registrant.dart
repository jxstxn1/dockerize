import 'package:mason_logger/mason_logger.dart';
import 'package:sidekick_core/sidekick_core.dart';

Future<void> createDockerizeRegistrant({
  required Directory registrantDir,
  required List<String> cspHashes,
  required bool shouldEnforceCsp,
  required Logger logger,
}) async {
  logger.info('[dockerize] Creating dockerize registrant');
  registrantDir.file('main.dart').writeAsStringSync(
        _dockerizeRegistrantTemplate(cspHashes, shouldEnforceCsp),
      );
}

String _dockerizeRegistrantTemplate(
  List<String> cspHashes,
  bool shouldEnforceCsp,
) {
  return '''
import 'package:dockerize_server/src/main.dart' as entrypoint;
import 'package:dockerize_sidekick_plugin/dockerize_sidekick_plugin.dart';

void main() {
  final dockerize = DockerizeData.instance;
  dockerize.cspHashes = $cspHashes;
  dockerize.shouldEnforceCsp = $shouldEnforceCsp;
  entrypoint.main([]);
}

''';
}
