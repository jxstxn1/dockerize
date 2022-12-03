FROM dart:stable AS build
# Copy shared submodule package
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get
# Ensure packages are still up-to-date if anything has changed
RUN dart pub get --offline
COPY server.dart ./bin/server.dart
RUN touch server
RUN dart compile exe bin/server.dart -o bin/server
# Build minimal serving image from AOT-compiled `/server` and required system
# libraries and configuration files stored in `/runtime/` from the build stage.
FROM scratch
# Copy runtime from build image
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /bin/
COPY /www ./bin/www
ENV APP_DIRECTORY=bin/www
# Start server.
EXPOSE 8080
CMD ["bin/server"]
