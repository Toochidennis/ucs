class Env {
  const Env();

  String get supabaseUrl =>
      const String.fromEnvironment('SUPABASE_URL', defaultValue: 'https://dev.supabase.co');
  String get supabaseAnonKey =>
      const String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: 'devkey');
}
