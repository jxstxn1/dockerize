import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:sidekick_core/sidekick_core.dart';

void hashScripts({required Hash hashType}) {
  final Document htmlFile = parse(
    repository.root.directory('server/www').file('index.html').readAsStringSync(),
  );
  final scripts = getScripts(htmlFile);
  print('Detected ${scripts.length} scripts to hash');
  final hashedScripts = hasher(scripts, hashType);
  print('Inserting Scripts into middlewares.dart');
  insertScripts(hashedScripts);
  print(green('finished hashing scripts'));
}

void insertScripts(List<String> hashedScript) {
  final middlewareFile = repository.root.directory('server/bin').file('middlewares.dart');
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

List<String> hasher(List<String> scripts, Hash hashType) {
  final hashScripts = <String>[];
  for (int i = 0; i > scripts.length; i++) {
    print('Hashing script: ${i + 1} of ${scripts.length}');
    final hashedScriptBytes = hashType.convert(utf8.encode(scripts[i])).bytes;
    final base64String = base64.encode(hashedScriptBytes);
    hashScripts.add(
      '''"'${hashType.typeToString}-$base64String'"''',
    );
  }
  return hashScripts;
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
