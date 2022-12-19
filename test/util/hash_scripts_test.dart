import 'package:crypto/crypto.dart';
import 'package:dockerize_sidekick_plugin/src/util/hash_scripts.dart';
import 'package:html/dom.dart';
import 'package:test/test.dart';

import '../helper/load_html.dart';

void main() {
  group('getScripts()', () {
    test('Should find three scripts in sample.html', () async {
      final Document htmlFile = loadSampleHTML;
      final scripts = getScripts(htmlFile);
      expect(scripts.length, 3);
    });

    test('Should find three scripts in sample.html', () async {
      final Document htmlFile = loadSampleWithNonceHTML;
      final scripts = getScripts(htmlFile);
      expect(scripts.length, 2);
    });
  });

  group('hasher', () {
    test('Should hash x to y', () {
      final Document htmlFile = loadSampleHTML;
      final script = getScripts(htmlFile).first;
      final hashedScript = hasher([script], sha256).first;
      expect(
        hashedScript,
        "'sha256-DYE2F9R1zqzhJwChIaBDWw4p1FtYuRhkYTCsJwEni1o='",
      );
    });
  });
}
