class Env {
  const Env();

  // You can override these with flutter run --dart-define or .env
  String get supabaseUrl => const String.fromEnvironment(
        'SUPABASE_URL',
        defaultValue: 'https://tfztcjfeaclazdrmwnfr.supabase.co',
      );

  String get supabaseAnonKey => const String.fromEnvironment(
        'SUPABASE_SECRET_KEY',
        defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRmenRjamZlYWNsYXpkcm13bmZyIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MDE3MDk5MiwiZXhwIjoyMDc1NzQ2OTkyfQ.BVv0_NEw2KaSeh1n5rSMyvewAwpBWHcie912rEbWk74',
      );

  String get supabaseProjectName => const String.fromEnvironment(
        'SUPABASE_PROJECT_NAME',
        defaultValue: 'UCS',
      );
}
