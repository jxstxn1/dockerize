import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:sidekick_core/sidekick_core.dart';

void hashScripts({required Hash hashType}) {
  final Document htmlFile = parse(
    repository.root
        .directory('server/www')
        .file('index.html')
        .readAsStringSync(),
  );
  final scripts = getScripts(htmlFile);
  final hashedScripts = hasher(scripts, hashType);
  insertScripts(hashedScripts);
}

void insertScripts(List<String> hashedScript) {
  final middlewareFile =
      repository.root.directory('server/bin').file('middlewares.dart');
  print(middlewareFile.path);
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
  for (final script in scripts) {
    final hashedScriptBytes = hashType.convert(utf8.encode(script)).bytes;
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
