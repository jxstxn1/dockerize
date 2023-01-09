import 'package:sidekick_core/sidekick_core.dart';

void isPortValid(String port) {
  final isPort = RegExp('^[0-9]{1,4}\$').hasMatch(port);
  if (!isPort) {
    print(red('Port must be a number with a max of 4 digits'));
    exit(1);
  }
}
