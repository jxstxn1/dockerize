import 'dart:convert';

import 'package:sidekick_core/sidekick_core.dart';

void createVersionFile({Map<String, dynamic>? entries}) {
  final content = {
    "created_at": DateTime.now().toIso8601String(),
    ...entries ?? {},
  };
  final middlewareFile = repository.root.file('server/www/version.json');
  if (!middlewareFile.existsSync()) {
    middlewareFile.createSync(recursive: true);
  }

  middlewareFile.writeAsStringSync(jsonEncode(content));
}
