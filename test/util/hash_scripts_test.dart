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
    group('Sha256', () {
      test('Should hash the serviceWorkerVersion', () {
        final Document htmlFile = loadSampleHTML;
        final script = getScripts(htmlFile).first;
        final hashedScript =
            hasher([script], sha256, loadSampleHTMLString).first;
        expect(
          hashedScript,
          '''"'sha256-DYE2F9R1zqzhJwChIaBDWw4p1FtYuRhkYTCsJwEni1o='"''',
        );
      });
      test('Should hash the Event Listener', () {
        final Document htmlFile = loadSampleHTML;
        final script = getScripts(htmlFile).last;
        final hashedScript =
            hasher([script], sha256, loadSampleHTMLString).first;
        expect(
          hashedScript,
          '''"'sha256-7kkT0t17vF4Bgf54wBSjuZO3pORc3aibNdISkVdNrnk='"''',
        );
      });
    });
    group('Sha384', () {
      test('Should hash the serviceWorkerVersion', () {
        final Document htmlFile = loadSampleHTML;
        final script = getScripts(htmlFile).first;
        final hashedScript =
            hasher([script], sha384, loadSampleHTMLString).first;
        expect(
          hashedScript,
          '''"'sha384-SXUxNfAG3vW81Xqzlv28ndONmqQezL+RnITpGhbuXcJPpx5JW2grzy8hGK3h8/JS'"''',
        );
      });
      test('Should hash the Event Listener', () {
        final Document htmlFile = loadSampleHTML;
        final script = getScripts(htmlFile).last;
        final hashedScript =
            hasher([script], sha384, loadSampleHTMLString).first;
        expect(
          hashedScript,
          '''"'sha384-LIj/+KEHaedkn1bv3oYh05IeZDmbgFA68WbaYYokwK2S7zqFMy8JimN1ciBngTJx'"''',
        );
      });
    });
    group('Sha512', () {
      test('Should hash the serviceWorkerVersion', () {
        final Document htmlFile = loadSampleHTML;
        final script = getScripts(htmlFile).first;
        final hashedScript =
            hasher([script], sha512, loadSampleHTMLString).first;
        expect(
          hashedScript,
          '''"'sha512-PT8zhJrdQWDWlmFD0JnXQNhhhcSaWv2QkYJQR0e0/bpMRXQjFdmrHUCt2VD/F3ODSSkAymTk7U+Ioke6Mz2O/A=='"''',
        );
      });
      test('Should hash the Event Listener', () {
        final Document htmlFile = loadSampleHTML;
        final script = getScripts(htmlFile).last;
        final hashedScript =
            hasher([script], sha512, loadSampleHTMLString).first;
        expect(
          hashedScript,
          '''"'sha512-8G4uS0MdZrs5ptGyDN5bhZbOqsESg6ZMyM1KOcBiorhrmFiCHOWqXShljGD7dO3E40EeyPlq3os5ureB5EBZRA=='"''',
        );
      });
    });
  });
}
