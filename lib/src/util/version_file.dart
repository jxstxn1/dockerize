import 'dart:convert';

import 'package:sidekick_core/sidekick_core.dart';

void createVersionFile({Map<String, dynamic>? entries}) {
  final content = {
    "created_at": DateTime.now().toIso8601String(),
    ...entries ?? {},
  };
  final versionFile = repository.root.file('server/www/version.json');
  final versionContent = jsonDecode(versionFile.readAsStringSync()) as Map;
  versionContent.addAll(content);
  versionFile.writeAsStringSync(jsonEncode(versionContent));
}
