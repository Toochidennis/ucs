class Env {
  const Env();

  String get appwritePublicEndpoint => const String.fromEnvironment(
    'APPWRITE_PUBLIC_ENDPOINT',
    defaultValue: 'https://fra.cloud.appwrite.io/v1',
  );
  String get appwriteProjectId => const String.fromEnvironment(
    'APPWRITE_PROJECT_ID',
    defaultValue: '68e4635f000b48608922',
  );
  String get appwriteProjectName => const String.fromEnvironment(
    'APPWRITE_PROJECT_NAME',
    defaultValue: 'UCS',
  );
}
