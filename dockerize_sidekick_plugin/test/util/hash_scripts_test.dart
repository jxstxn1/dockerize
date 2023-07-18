import 'package:crypto/crypto.dart';
import 'package:dockerize_sidekick_plugin/dockerize_sidekick_plugin.dart';
import 'package:dockerize_sidekick_plugin/src/util/hash_scripts.dart';
import 'package:html/dom.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../helper/load_html.dart';

class _MockLogger extends Mock implements Logger {}

class _MockProgress extends Mock implements Progress {}

void main() {
  late Logger logger;

  setUp(() {
    logger = _MockLogger();
  });
  group('getScripts()', () {
    test('Should find three scripts in sample.html', () async {
      final Document htmlFile = loadSampleHTML;
      final scripts = getScripts(htmlFile);
      expect(scripts.length, 2);
    });

    test('Should find three scripts in sample.html', () async {
      final Document htmlFile = loadSampleWithNonceHTML;
      final scripts = getScripts(htmlFile);
      expect(scripts.length, 1);
    });

    test('Should find no scripts in sample_with_no_scripts.html', () async {
      final Document htmlFile = loadSampleHTMLWithEmptyScripts;
      final scripts = getScripts(htmlFile);
      expect(scripts.length, 0);
    });
  });

  group('hasher', () {
    test('Should throw if a non supported HashType is inserted', () {
      final Document htmlFile = loadSampleHTML;
      final scripts = getScripts(htmlFile);
      expect(
        () => hasher(scripts, sha224, loadSampleHTMLString, logger: logger),
        throwsA(isA<ArgumentError>()),
      );
      verifyNever(() => logger.info(any()));
    });
    group('Sha256', () {
      test('Should hash the serviceWorkerVersion', () {
        final Document htmlFile = loadSampleHTML;
        final script = getScripts(htmlFile).first;
        final hashedScript = hasher(
          [script],
          sha256,
          loadSampleHTMLString,
          logger: logger,
        ).first;
        expect(
          hashedScript,
          '''"'sha256-DYE2F9R1zqzhJwChIaBDWw4p1FtYuRhkYTCsJwEni1o='"''',
        );
        verify(
          () => logger.info('[dockerize] - Hashing index.html:35 <script>'),
        );
      });
      test('Should hash the Event Listener', () {
        final Document htmlFile = loadSampleHTML;
        final script = getScripts(htmlFile).last;
        final hashedScript = hasher(
          [script],
          sha256,
          loadSampleHTMLString,
          logger: logger,
        ).first;
        expect(
          hashedScript,
          '''"'sha256-7kkT0t17vF4Bgf54wBSjuZO3pORc3aibNdISkVdNrnk='"''',
        );
        verify(
          () => logger.info('[dockerize] - Hashing index.html:43 <script>'),
        );
      });
    });
    group('Sha384', () {
      test('Should hash the serviceWorkerVersion', () {
        final Document htmlFile = loadSampleHTML;
        final script = getScripts(htmlFile).first;
        final hashedScript = hasher(
          [script],
          sha384,
          loadSampleHTMLString,
          logger: logger,
        ).first;
        expect(
          hashedScript,
          '''"'sha384-SXUxNfAG3vW81Xqzlv28ndONmqQezL+RnITpGhbuXcJPpx5JW2grzy8hGK3h8/JS'"''',
        );
        verify(
          () => logger.info('[dockerize] - Hashing index.html:35 <script>'),
        );
      });
      test('Should hash the Event Listener', () {
        final Document htmlFile = loadSampleHTML;
        final script = getScripts(htmlFile).last;
        final hashedScript = hasher(
          [script],
          sha384,
          loadSampleHTMLString,
          logger: logger,
        ).first;
        expect(
          hashedScript,
          '''"'sha384-LIj/+KEHaedkn1bv3oYh05IeZDmbgFA68WbaYYokwK2S7zqFMy8JimN1ciBngTJx'"''',
        );
        verify(
          () => logger.info('[dockerize] - Hashing index.html:43 <script>'),
        );
      });
    });
    group('Sha512', () {
      test('Should hash the serviceWorkerVersion', () {
        final Document htmlFile = loadSampleHTML;
        final script = getScripts(htmlFile).first;
        final hashedScript = hasher(
          [script],
          sha512,
          loadSampleHTMLString,
          logger: logger,
        ).first;
        expect(
          hashedScript,
          '''"'sha512-PT8zhJrdQWDWlmFD0JnXQNhhhcSaWv2QkYJQR0e0/bpMRXQjFdmrHUCt2VD/F3ODSSkAymTk7U+Ioke6Mz2O/A=='"''',
        );
        verify(
          () => logger.info('[dockerize] - Hashing index.html:35 <script>'),
        );
      });
      test('Should hash the Event Listener', () {
        final Document htmlFile = loadSampleHTML;
        final script = getScripts(htmlFile).last;
        final hashedScript = hasher(
          [script],
          sha512,
          loadSampleHTMLString,
          logger: logger,
        ).first;
        expect(
          hashedScript,
          '''"'sha512-8G4uS0MdZrs5ptGyDN5bhZbOqsESg6ZMyM1KOcBiorhrmFiCHOWqXShljGD7dO3E40EeyPlq3os5ureB5EBZRA=='"''',
        );
        verify(
          () => logger.info('[dockerize] - Hashing index.html:43 <script>'),
        );
      });
    });
  });
  group('hashScripts', () {
    late Progress progress;

    setUp(() {
      progress = _MockProgress();
      when(() => logger.progress(any())).thenReturn(progress);
    });

    group('sha256', () {
      test('Should hash the scripts from sample.html', () {
        final result = hashScripts(
          hashType: sha256,
          logger: logger,
          htmlFile: loadSampleHTMLFile,
        );
        expect(result, [
          '"\'sha256-DYE2F9R1zqzhJwChIaBDWw4p1FtYuRhkYTCsJwEni1o=\'"',
          '"\'sha256-7kkT0t17vF4Bgf54wBSjuZO3pORc3aibNdISkVdNrnk=\'"'
        ]);
        verifyInOrder([
          () => logger.info('[dockerize] Detected 2 scripts to hash'),
          () => logger.info('[dockerize] - Hashing index.html:35 <script>'),
          () => logger.info('[dockerize] - Hashing index.html:43 <script>'),
        ]);
      });

      test('Should hash the scripts from sample_with_nonce.html', () {
        final result = hashScripts(
          hashType: sha256,
          logger: logger,
          htmlFile: loadSampleWithNonceHTMLFile,
        );
        expect(
          result,
          ['"\'sha256-7kkT0t17vF4Bgf54wBSjuZO3pORc3aibNdISkVdNrnk=\'"'],
        );
        verifyInOrder([
          () => logger.info('[dockerize] Detected 1 scripts to hash'),
          () => logger.info('[dockerize] - Hashing index.html:43 <script>'),
        ]);
      });
    });

    group('sha384', () {
      test('Should hash the scripts from sample.html', () {
        final result = hashScripts(
          hashType: sha384,
          logger: logger,
          htmlFile: loadSampleHTMLFile,
        );
        expect(result, [
          '"\'sha384-SXUxNfAG3vW81Xqzlv28ndONmqQezL+RnITpGhbuXcJPpx5JW2grzy8hGK3h8/JS\'"',
          '"\'sha384-LIj/+KEHaedkn1bv3oYh05IeZDmbgFA68WbaYYokwK2S7zqFMy8JimN1ciBngTJx\'"'
        ]);
        verifyInOrder([
          () => logger.info('[dockerize] Detected 2 scripts to hash'),
          () => logger.info('[dockerize] - Hashing index.html:35 <script>'),
          () => logger.info('[dockerize] - Hashing index.html:43 <script>'),
        ]);
      });

      test('Should hash the scripts from sample_with_nonce.html', () {
        final result = hashScripts(
          hashType: sha384,
          logger: logger,
          htmlFile: loadSampleWithNonceHTMLFile,
        );
        expect(result, [
          '"\'sha384-LIj/+KEHaedkn1bv3oYh05IeZDmbgFA68WbaYYokwK2S7zqFMy8JimN1ciBngTJx\'"'
        ]);
        verifyInOrder([
          () => logger.info('[dockerize] Detected 1 scripts to hash'),
          () => logger.info('[dockerize] - Hashing index.html:43 <script>'),
        ]);
      });
    });

    group('sha512', () {
      test('Should hash the scripts from sample.html', () {
        final result = hashScripts(
          hashType: sha512,
          logger: logger,
          htmlFile: loadSampleHTMLFile,
        );
        expect(result, [
          '"\'sha512-PT8zhJrdQWDWlmFD0JnXQNhhhcSaWv2QkYJQR0e0/bpMRXQjFdmrHUCt2VD/F3ODSSkAymTk7U+Ioke6Mz2O/A==\'"',
          '"\'sha512-8G4uS0MdZrs5ptGyDN5bhZbOqsESg6ZMyM1KOcBiorhrmFiCHOWqXShljGD7dO3E40EeyPlq3os5ureB5EBZRA==\'"'
        ]);
        verifyInOrder([
          () => logger.info('[dockerize] Detected 2 scripts to hash'),
          () => logger.info('[dockerize] - Hashing index.html:35 <script>'),
          () => logger.info('[dockerize] - Hashing index.html:43 <script>'),
        ]);
      });

      test('Should hash the scripts from sample_with_nonce.html', () {
        final result = hashScripts(
          hashType: sha512,
          logger: logger,
          htmlFile: loadSampleWithNonceHTMLFile,
        );
        expect(result, [
          '"\'sha512-8G4uS0MdZrs5ptGyDN5bhZbOqsESg6ZMyM1KOcBiorhrmFiCHOWqXShljGD7dO3E40EeyPlq3os5ureB5EBZRA==\'"'
        ]);
        verifyInOrder([
          () => logger.info('[dockerize] Detected 1 scripts to hash'),
          () => logger.info('[dockerize] - Hashing index.html:43 <script>'),
        ]);
      });
    });
    test('Should throw Argument Error if the Wrong hash type was passed', () {
      expect(
        () => hashScripts(
          hashType: sha224,
          logger: logger,
          htmlFile: loadSampleHTMLFile,
        ),
        throwsA(
          isA<ArgumentError>(),
        ),
      );
    });
    test('Should return if 0 scripts were detected', () {
      hashScripts(
        hashType: sha256,
        logger: logger,
        htmlFile: loadSampleHTMLWithEmptyScriptsFile,
      );
      verify(() => logger.info('[dockerize] No scripts found to hash'));
    });
  });
}
