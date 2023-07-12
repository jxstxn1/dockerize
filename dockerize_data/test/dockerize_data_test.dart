import 'package:dockerize_data/dockerize_data.dart';
import 'package:test/test.dart';

void main() {
  group('DockerizeData', () {
    test('shouldEnforceCsp defaults to false', () {
      expect(DockerizeData.instance.shouldEnforceCsp, isFalse);
    });

    test('cspHashes defaults to empty list', () {
      expect(DockerizeData.instance.cspHashes, isEmpty);
    });

    test('instance is a singleton', () {
      final instance1 = DockerizeData.instance;
      final instance2 = DockerizeData.instance;
      expect(instance1, same(instance2));
    });

    test('shouldEnforceCsp can be set to true', () {
      DockerizeData.instance.shouldEnforceCsp = true;
      expect(DockerizeData.instance.shouldEnforceCsp, isTrue);
    });

    test('cspHashes can be set to a list of strings', () {
      DockerizeData.instance.cspHashes = ['foo', 'bar'];
      expect(DockerizeData.instance.cspHashes, equals(['foo', 'bar']));
    });
  });
}
