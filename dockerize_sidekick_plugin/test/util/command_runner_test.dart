import 'package:dockerize_sidekick_plugin/dockerize_sidekick_plugin.dart';
import 'package:dockerize_sidekick_plugin/src/util/command_runner.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sidekick_core/sidekick_core.dart';
import 'package:test/test.dart';

class _MockLogger extends Mock implements Logger {}

void main() {
  group('CommandRunner', () {
    late Logger logger;
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync();
      logger = _MockLogger();
    });

    tearDown(() {
      try {
        tempDir.deleteSync(recursive: true);
      } catch (_) {}
    });

    test('Should execute echo "Hello World"', () async {
      await commandRunner(
        'echo',
        ['"Hello World"'],
        workingDirectory: tempDir,
        logger: logger,
        successMessage: 'Success',
      );
      verify(() => logger.info('[dockerize] "Hello World"\n'));
      verify(() => logger.success('[dockerize] Success'));
    });
    test('Should execute echo "anything" | grep z', () async {
      await commandRunner(
        'grep',
        [
          '-eV',
          'z',
        ],
        workingDirectory: tempDir,
        logger: logger,
        successMessage: 'Success',
      );
      verify(
        () => logger.err('[dockerize] grep: z: No such file or directory\n'),
      );
    });
  });
}
