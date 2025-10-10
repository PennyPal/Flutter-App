import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import '../config/app_config.dart';

/// Singleton service for managing Appwrite client and services
class AppwriteService {
  static AppwriteService? _instance;
  late Client _client;
  late Account _account;
  late Databases _databases;

  AppwriteService._() {
    _initializeClient();
  }

  factory AppwriteService() {
    _instance ??= AppwriteService._();
    return _instance!;
  }

  void _initializeClient() {
    _client = Client()
        .setEndpoint(AppConfig.appwriteEndpoint)
        .setProject(AppConfig.appwriteProjectId)
        .setSelfSigned(status: true); // For development only

    _account = Account(_client);
    _databases = Databases(_client);
  }

  /// Get the Appwrite Account instance
  Account get account => _account;

  /// Get the Appwrite Databases instance
  Databases get databases => _databases;

  /// Get the Appwrite Client instance
  Client get client => _client;

  /// Check if user is currently authenticated
  Future<bool> isAuthenticated() async {
    try {
      await _account.get();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get current user session
  Future<User?> getCurrentUser() async {
    try {
      return await _account.get();
    } catch (e) {
      return null;
    }
  }
}

