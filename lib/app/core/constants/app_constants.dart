class AppConstants{
  static String appName = "FeedApp";


  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://qqgtbszmtsfjbwfouvzf.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFxZ3Ric3ptdHNmamJ3Zm91dnpmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY0NDEyMzEsImV4cCI6MjA3MjAxNzIzMX0.3t3UviNRM_t2fPHFi9i9WDT_aNapWmekKCxj-yRgJBE',
  );

}