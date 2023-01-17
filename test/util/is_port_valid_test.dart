import 'package:dockerize_sidekick_plugin/dockerize_sidekick_plugin.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockLogger extends Mock implements Logger {}

void main() {
  group('isPortValid', () {
    late Logger logger;

    setUp(() {
      logger = _MockLogger();
    });
    test('Should Log an error if the input is not a port', () {
      final response = isPortValid('12345', logger);
      verify(
        () => logger
            .err('[dockerize] Port must be a number with a max of 4 digits'),
      );
      expect(response, false);
    });

    test('Should Log an error if the input is not a port', () {
      final response = isPortValid('1', logger);
      verifyNever(
        () => logger
            .err('[dockerize] Port must be a number with a max of 4 digits'),
      );
      expect(response, true);
    });
  });
}
