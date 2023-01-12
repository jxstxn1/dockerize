import 'package:mason_logger/mason_logger.dart';
import 'package:sidekick_core/sidekick_core.dart';

void isPortValid(String port) {
  final Logger logger = Logger();
  final isPort = RegExp('^[0-9]{1,4}\$').hasMatch(port);
  if (!isPort) {
    logger.err('[dockerize] Port must be a number with a max of 4 digits');
    exit(1);
  }
}
