import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:sidekick_core/sidekick_core.dart';

void hashScripts({required Hash hashType}) {
  final htmlString = repository.root
      .directory('server/www')
      .file('index.html')
      .readAsStringSync();
  final Document htmlFile = parse(htmlString);
  final scripts = getScripts(htmlFile);
  print('- Detected ${scripts.length} scripts to hash');
  final hashedScripts = hasher(scripts, hashType, htmlString);
  print('- Inserting Scripts into middlewares.dart');
  insertScripts(hashedScripts);
  print(green('✅ Finished hashing scripts'));
}

void insertScripts(List<String> hashedScript) {
  final middlewareFile =
      repository.root.directory('server/bin').file('middlewares.dart');
  final middlewareFileContent = middlewareFile.readAsStringSync();
  final RegExp regex = RegExp(
    r'const List<String> hashes = \[(.*?)\]',
    multiLine: true,
    dotAll: true,
  );
  final String newContent = middlewareFileContent.replaceAll(
    regex,
    'const List<String> hashes = $hashedScript',
  );
  middlewareFile.writeAsStringSync(newContent);
}

List<String> getScripts(Document htmlFile) {
  final hashScripts = <String>[];
  final List<Element> scripts = htmlFile.getElementsByTagName('script');
  for (final script in scripts) {
    if (!script.attributes.containsKey('nonce')) {
      hashScripts.add(script.innerHtml);
    }
  }
  return hashScripts;
}

List<String> hasher(List<String> scripts, Hash hashType, String file) {
  final hashScripts = <String>[];
  for (int i = 0; i < scripts.length; i++) {
    if (scripts[i].isNotEmpty) {
      print('- Hashing index.html:${getLineNumber(file, scripts[i])} <script>');
      final hashedScriptBytes = hashType.convert(utf8.encode(scripts[i])).bytes;
      final base64String = base64.encode(hashedScriptBytes);
      hashScripts.add(
        '''"'${hashType.typeToString}-$base64String'"''',
      );
    }
  }
  return hashScripts;
}

int getLineNumber(String htmlFile, String script) {
  const slashN = 0x0A;
  const slashR = 0x0D;

  int lineStarts = 0;
  final length = htmlFile.indexOf(script);
  for (var i = 0; i < length; i++) {
    final unit = htmlFile.codeUnitAt(i);
    // Special-case \r\n.
    if (unit == slashR) {
      // Peek ahead to detect a following \n.
      if (i + 1 < length && htmlFile.codeUnitAt(i + 1) == slashN) {
        // Line start will get registered at next index at the \n.
      } else {
        lineStarts++;
      }
    }
    // \n
    if (unit == slashN) {
      lineStarts++;
    }
  }

  return lineStarts + 1;
}

extension HashType on Hash {
  String get typeToString {
    switch (this) {
      case sha256:
        return 'sha256';
      case sha384:
        return 'sha384';
      case sha512:
        return 'sha512';
      default:
        throw Exception('Hash type not supported');
    }
  }
}
