import 'package:dockerize_sidekick_plugin/dockerize_sidekick_plugin.dart';
import 'package:sidekick_core/sidekick_core.dart';
import 'package:test/test.dart';

void main() {
  group('EnforceCSP', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync();
    });

    tearDown(() {
      try {
        tempDir.deleteSync(recursive: true);
      } catch (_) {}
    });

    test('should set the bool to true', () {
      final versionFile = File('${tempDir.path}/test.dart');
      versionFile.createSync();
      versionFile.writeAsStringSync('const bool shouldEnforceCsp = false;');
      enforceCSP(shouldEnforce: true, middlewareFile: versionFile);
      expect(
        versionFile.readAsStringSync(),
        'const bool shouldEnforceCsp = true;',
      );
    });
    test('should set the bool to false', () {
      final versionFile = File('${tempDir.path}/test.dart');
      versionFile.createSync();
      versionFile.writeAsStringSync('const bool shouldEnforceCsp = true;');
      enforceCSP(shouldEnforce: false, middlewareFile: versionFile);
      expect(
        versionFile.readAsStringSync(),
        'const bool shouldEnforceCsp = false;',
      );
    });
    test('should keep the bool to false', () {
      final versionFile = File('${tempDir.path}/test.dart');
      versionFile.createSync();
      versionFile.writeAsStringSync('const bool shouldEnforceCsp = false;');
      enforceCSP(shouldEnforce: false, middlewareFile: versionFile);
      expect(
        versionFile.readAsStringSync(),
        'const bool shouldEnforceCsp = false;',
      );
    });
  });
}
