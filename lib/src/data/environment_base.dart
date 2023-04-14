abstract class EnvironmentBase {
  /// The name of the environment.
  final String name = '';

  /// Whether or not to report-only Content Security Policy violations.
  final bool shouldEnforceCSP = false;

  final Map<String, dynamic> versionFileEntries = const {};
}
