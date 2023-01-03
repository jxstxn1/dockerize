import 'package:sidekick_core/sidekick_core.dart';

extension CreateIfNotExisting on Directory {
  Directory createIfNotExists() {
    if (!existsSync()) {
      createSync(recursive: true);
    }
    return this;
  }
}
