import 'package:shelf/shelf.dart';
import 'package:shelf_helmet/shelf_helmet.dart';

/// Returns a opinionated set of middlewares for a shelf server.
/// This is used by default from the server.dart file.
Middleware middlewares() {
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
          // TODO: Disable reportOnly in production
          reportOnly: true,
          directives: {
            'script-src': [
              "'unsafe-eval'",
              "'unsafe-inline'",
              "'self'",
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
