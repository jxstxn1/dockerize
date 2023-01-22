import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:mason_logger/mason_logger.dart';
import 'package:sidekick_core/sidekick_core.dart' hide Progress;

void hashScripts({
  required Hash hashType,
  required Logger logger,
  required File htmlFile,
  required File middlewareFile,
}) {
  // reading html file as string
  final htmlString = htmlFile.readAsStringSync();

  // parsing the html file into a document
  final Document htmlDocumentFile = parse(htmlString);

  // getting all the scripts from the html file
  final scripts = getScripts(htmlDocumentFile);
  if (scripts.isEmpty) {
    logger.info('[dockerize] No scripts found to hash');
    return;
  }
  final progress =
      logger.progress('[dockerize] Detected ${scripts.length} scripts to hash');

  // hashing the scripts
  final hashedScripts = hasher(scripts, hashType, htmlString, logger: logger);
  progress.update('[dockerize]  Inserting Scripts into middlewares.dart');

  // inserting the hashed scripts into the middlewares.dart file
  insertScripts(hashedScripts, middlewareFile);
  progress.complete('[dockerize]  Finished hashing scripts');
}

/// Inserting the hashed scripts into the middlewares.dart file
void insertScripts(List<String> hashedScript, File middlewareFile) {
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

/// Get all the scripts from the html file
List<String> getScripts(Document htmlFile) {
  final hashScripts = <String>[];
  final List<Element> scripts = htmlFile.getElementsByTagName('script');
  for (final script in scripts) {
    if (!script.attributes.containsKey('nonce')) {
      final scriptString = script.innerHtml;
      // Only adding the script if it is not empty
      // Example: <script></script>
      if (scriptString.isNotEmpty) {
        hashScripts.add(script.innerHtml);
      }
    }
  }
  return hashScripts;
}

List<String> hasher(
  List<String> scripts,
  Hash hashType,
  String file, {
  required Logger logger,
}) {
  final hashScripts = <String>[];
  final hashTypeString = hashType.typeToString;
  for (int i = 0; i < scripts.length; i++) {
    if (scripts[i].isNotEmpty) {
      // Hasing the UTF-8 encoded script
      final hashedScriptBytes = hashType.convert(utf8.encode(scripts[i])).bytes;
      // Encoding the hashed script to base64
      final base64String = base64.encode(hashedScriptBytes);
      // Adding the hashed script to the list
      // The format is '<HashType>-<base64String>'
      // Example: 'sha256-<base64String>'
      hashScripts.add(
        '''"'$hashTypeString-$base64String'"''',
      );
      logger.info(
        '[dockerize] - Hashing index.html:${getLineNumber(file, scripts[i])} <script>',
      );
    }
  }
  return hashScripts;
}

/// Returns the line number of the script in the html file
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
        throw ArgumentError('Hash type not supported');
    }
  }
}
