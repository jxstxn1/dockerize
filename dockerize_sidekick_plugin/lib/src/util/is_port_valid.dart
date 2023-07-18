import 'package:mason_logger/mason_logger.dart';

bool isPortValid(String port, Logger logger) {
  final isPort = RegExp('^[0-9]{1,4}\$').hasMatch(port);
  if (!isPort) {
    logger.err('[dockerize] Port must be a number with a max of 4 digits');
    return false;
  }
  return true;
}
