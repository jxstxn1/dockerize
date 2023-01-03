import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:sidekick_core/sidekick_core.dart';

Document get loadSampleHTML => parse(loadSampleHTMLString);

String get loadSampleHTMLString =>
    Directory('test/test_resources').file('sample.html').readAsStringSync();

Document get loadSampleWithNonceHTML => parse(loadSampleWithNonceHTMLString);

String get loadSampleWithNonceHTMLString => Directory('test/test_resources')
    .file('sample_with_nonce.html')
    .readAsStringSync();
