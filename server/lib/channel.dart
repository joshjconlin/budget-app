import 'package:aqueduct/managed_auth.dart';
import 'package:server/controllers/BudgetController.dart';
import 'package:server/model/user.dart';
import 'package:server/controllers/RegisterController.dart';
import 'package:server/controllers/MeController.dart';
import 'server.dart';

/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://aqueduct.io/docs/http/channel/.
class ServerChannel extends ApplicationChannel {
  AuthServer authServer;
  ManagedContext context;

  /// Initialize services in this method.
  ///
  /// Implement this method to initialize services, read values from [options]
  /// and any other initialization required before constructing [entryPoint].
  ///
  /// This method is invoked prior to [entryPoint] being accessed.
  @override
  Future prepare() async {
    logger.onRecord.listen((rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
    final config = ServerConfig(options.configurationFilePath);
    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final persistentStore = PostgreSQLPersistentStore.fromConnectionInfo(
        config.database.username,
        config.database.password,
        config.database.host,
        config.database.port,
        config.database.databaseName);
    context = ManagedContext(dataModel, persistentStore);
    final delegate = ManagedAuthDelegate<User>(context);
    authServer = AuthServer(delegate);
  }

  /// Construct the request channel.
  ///
  /// Return an instance of some [Controller] that will be the initial receiver
  /// of all [Request]s.
  ///
  /// This method is invoked after [prepare].
  @override
  Controller get entryPoint {
    final router = Router();

    router
        .route("/auth/token")
        .link(() => AuthController(authServer));

    router
        .route('/register')
        .link(() => RegisterController(context, authServer));

    router
        .route('/me')
        .link(() => Authorizer.bearer(authServer))
        .link(() => MeController(context));

    router
        .route('/me/[:id]')
        .link(() => Authorizer.bearer(authServer))
        .link(() => BudgetController(context));

    // Prefer to use `link` instead of `linkFunction`.
    // See: https://aqueduct.io/docs/http/request_controller/
//    router
//      .route("/example")
//      .linkFunction((request) async {
//        return Response.ok({"key": "value"});
//      });
//aqueduct auth add-client --id com.server --connect postgres://joshconlin:password@localhost:5432/simply_budgets
    return router;
  }
}

class ServerConfig extends Configuration {
  ServerConfig(String path) : super.fromFile(File(path));

  DatabaseConfiguration database;
}
