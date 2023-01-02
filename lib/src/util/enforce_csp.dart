import 'package:sidekick_core/sidekick_core.dart';

void enforceCSP({required bool shouldEnforce}) {
  if (!shouldEnforce) return;
  final middlewareFile =
      repository.root.directory('server/bin').file('middlewares.dart');
  final middlewareFileContent = middlewareFile.readAsStringSync();
  final RegExp regex = RegExp(
    'const bool shouldEnforceCsp = (.*?);',
    multiLine: true,
    dotAll: true,
  );
  final String newContent = middlewareFileContent.replaceAll(
    regex,
    'const bool shouldEnforceCsp = $shouldEnforce;',
  );
  middlewareFile.writeAsStringSync(newContent);
}
