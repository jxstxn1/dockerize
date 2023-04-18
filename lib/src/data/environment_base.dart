abstract class EnvironmentBase {
  const EnvironmentBase({
    required this.name,
    required this.shouldEnforceCSP,
    required this.versionFileEntries,
  });

  /// The name of the environment.
  final String name;

  /// Whether or not to report-only Content Security Policy violations.
  final bool shouldEnforceCSP;

  final Map<String, dynamic> versionFileEntries;
}
