import 'package:shelf/shelf.dart';
import 'package:shelf_helmet/shelf_helmet.dart';

/// Dont touch this line because it will be replaced by the build function
const List<String> hashes = [];

/// This is the default value, it will be replaced by the build function if
/// the `shouldEnforceCSP` bool in the environments is set to true
const bool shouldEnforceCsp = false;

/// Returns a opinionated set of middlewares for a shelf server.
/// This is used by default from the server.dart file.
Middleware middlewares(List<String> nonces) {
  Pipeline pipeline = const Pipeline();

  // Logging middleware
  pipeline = pipeline.addMiddleware(logRequests());

  // Helmet middleware
  // You can customize or remove the default helmet middleware
  // For more information checkout https://pub.dev/packages/shelf_helmet
  pipeline = pipeline.addMiddleware(
    helmet(
      options: const HelmetOptions(
        // TODO: Add your own CSP options
        cspOptions: ContentSecurityPolicyOptions.useDefaults(
          // ignore: avoid_redundant_argument_values
          reportOnly: !shouldEnforceCsp,
          directives: {
            'script-src': [
              "'self'",
              "'wasm-unsafe-eval'",
              ...hashes,
              "blob:",
              "https://unpkg.com/",
            ],
            'connect-src': [
              "'self'",
              "https://unpkg.com/",
              "https://fonts.gstatic.com/s/roboto/v20/KFOmCnqEu92Fr1Me5WZLCzYlKw.ttf ",
            ],
          },
        ),

        coepOptions: CrossOriginEmbedderPolicyOptions.credentialLess,
      ),
    ),
  );

  return (innerHandler) => pipeline.addHandler(innerHandler);
}
