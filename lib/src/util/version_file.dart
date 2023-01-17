import 'dart:convert';

import 'package:sidekick_core/sidekick_core.dart';

void writeToVersionFile({
  Map<String, dynamic>? entries,
  required File versionFile,
}) {
  final content = {
    "created_at": DateTime.now().toIso8601String(),
    ...entries ?? {},
  };
  final versionContent = jsonDecode(versionFile.readAsStringSync()) as Map;
  versionContent.addAll(content);
  versionFile.writeAsStringSync(jsonEncode(versionContent));
}
