/// Application configuration class for managing API keys and endpoints
/// 
/// IMPORTANT: Do NOT commit your actual API keys to version control
/// Create a .env file in the root directory with your actual keys:
/// 
/// APPWRITE_ENDPOINT=https://cloud.appwrite.io/v1
/// APPWRITE_PROJECT_ID=your_project_id
/// PERPLEXITY_API_KEY=your_api_key
class AppConfig {
  // Appwrite Configuration
  static const String appwriteEndpoint = String.fromEnvironment(
    'APPWRITE_ENDPOINT',
    defaultValue: 'https://sfo.cloud.appwrite.io/v1',
  );
  
  static const String appwriteProjectId = String.fromEnvironment(
    'APPWRITE_PROJECT_ID',
    defaultValue: '68e749bf003cf9cf5cca',
  );
  
  static const String appwriteDatabaseId = String.fromEnvironment(
    'APPWRITE_DATABASE_ID',
    defaultValue: 'pennypal_db',
  );
  
  static const String appwriteUserCollectionId = String.fromEnvironment(
    'APPWRITE_USER_COLLECTION_ID',
    defaultValue: 'users',
  );

  // Perplexity API Configuration
  static const String perplexityApiKey = String.fromEnvironment(
    'PERPLEXITY_API_KEY',
    defaultValue: 'YOUR_PERPLEXITY_API_KEY_HERE',
  );
  
  static const String perplexityApiUrl = String.fromEnvironment(
    'PERPLEXITY_API_URL',
    defaultValue: 'https://api.perplexity.ai',
  );

  // Validation
  static bool get isAppwriteConfigured => 
      appwriteProjectId != 'YOUR_PROJECT_ID_HERE' && 
      appwriteProjectId.isNotEmpty;

  static bool get isPerplexityConfigured => 
      perplexityApiKey != 'YOUR_PERPLEXITY_API_KEY_HERE' && 
      perplexityApiKey.isNotEmpty;
}

