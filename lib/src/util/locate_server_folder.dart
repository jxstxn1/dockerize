import 'package:sidekick_core/sidekick_core.dart';

Directory locateServerFolder() {
  return Directory(
    repository.root
        .listSync(recursive: true)
        .where((element) => element is Directory && element.name == 'server')
        .first
        .path,
  );
}
