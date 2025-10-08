import 'package:appwrite/appwrite.dart';
import 'package:ucs/core/config/env.dart';

class AppWriteService {
  static final Client client = Client();
  static late final Account account;
  static late final Databases database;
  static late final Storage storage;
  static late final Messaging messaging;

  static void initialize() {
    final env = Env();

    client
        .setEndpoint(env.appwritePublicEndpoint)
        .setProject(env.appwriteProjectId)
        .setSelfSigned(status: true);

    account = Account(client);
    database = Databases(client);
    storage = Storage(client);
    messaging = Messaging(client);
  }
}
