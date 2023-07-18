import 'dart:convert';
import 'dart:io';

import 'package:dockerize_sidekick_plugin/dockerize_sidekick_plugin.dart';
import 'package:test/test.dart';

void main() {
  group('VersionFile', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync();
    });

    tearDown(() {
      try {
        tempDir.deleteSync(recursive: true);
      } catch (_) {}
    });

    test('Should write TimeStamp VersionFile', () {
      final versionFile = File('${tempDir.path}/version.json');
      versionFile.createSync();
      versionFile.writeAsStringSync('{}');
      writeToVersionFile(versionFile: versionFile);
      expect(versionFile.readAsStringSync(), isNotEmpty);
      expect(
        (jsonDecode(versionFile.readAsStringSync()) as Map)['created_at'],
        isNotNull,
      );
    });
    test('Should not overwrite existing values', () {
      final versionFile = File('${tempDir.path}/version.json');
      versionFile.createSync();
      versionFile.writeAsStringSync('{"test": "Hello World!"}');
      writeToVersionFile(versionFile: versionFile);
      expect(versionFile.readAsStringSync(), isNotEmpty);
      expect(
        (jsonDecode(versionFile.readAsStringSync()) as Map)['created_at'],
        isNotNull,
      );
      expect(
        (jsonDecode(versionFile.readAsStringSync()) as Map)['test'],
        'Hello World!',
      );
    });
    test('Should write additional Entries to VersionFile', () {
      final versionFile = File('${tempDir.path}/version.json');
      versionFile.createSync();
      versionFile.writeAsStringSync('{}');
      writeToVersionFile(
        versionFile: versionFile,
        entries: {'test': 'Hello World!'},
      );
      expect(versionFile.readAsStringSync(), isNotEmpty);
      expect(
        (jsonDecode(versionFile.readAsStringSync()) as Map)['created_at'],
        isNotNull,
      );
      expect(
        (jsonDecode(versionFile.readAsStringSync()) as Map)['test'],
        'Hello World!',
      );
    });
  });
}
