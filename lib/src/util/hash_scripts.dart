import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:sidekick_core/sidekick_core.dart';

void hashScripts({bool shouldHash = true, Hash hash = sha256}) {
  if (!shouldHash) return;
  final Document htmlFile = parse(
    repository.root
        .directory('packages/server/www')
        .file('index.html')
        .readAsStringSync(),
  );
  final scripts = getScripts(htmlFile);
  final hashedScripts = hasher(scripts, hash);
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

List<String> hasher(List<String> scripts, Hash hash) {
  final hashScripts = <String>[];
  for (final script in scripts) {
    print(script);
    hashScripts.add(
      "'${hashType(hash)}-${base64.encode(hash.convert(utf8.encode(script)).bytes)}'",
    );
  }
  return hashScripts;
}

String hashType(Hash hash) {
  switch (hash) {
    case sha256:
      return 'sha256';
    case sha384:
      return 'sha384';
    case sha512:
      return 'sha512';
    default:
      return 'sha256';
  }
}
