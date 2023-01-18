import 'package:dockerize_sidekick_plugin/src/util/check_docker_install.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockLogger extends Mock implements Logger {}

void main() {
  group('checkDockerInstall', () {
    late Logger logger;

    setUp(() {
      logger = _MockLogger();
    });

    test('If docker is installed nothing should happen', () {
      checkDockerInstall(logger);
      verifyNever(() => logger.err(any()));
    });
  });
}
