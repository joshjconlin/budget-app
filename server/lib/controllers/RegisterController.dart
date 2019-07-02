import 'package:server/model/user.dart';
import 'package:aqueduct/aqueduct.dart';
import 'package:server/server.dart';

class RegisterController extends ResourceController {
  RegisterController(this.context, this.authServer);

  final ManagedContext context;
  final AuthServer authServer;

  @Operation.post()
  Future<Response> createUser(@Bind.body(ignore: ['role']) User user) async {
    if (user.username == null || user.password == null) {
      return Response.badRequest(
          body: {"error": 'A username and password is required.'});
    }

    if (user.firstName == null || user.lastName == null) {
      return Response.badRequest(
          body: {"error": "First and Last name are required."});
    }

    user
      ..createdAt = DateTime.now()
      ..salt = AuthUtility.generateRandomSalt()
      ..role = UserRole.user
      ..updatedAt = DateTime.now()
      ..hashedPassword =
          AuthUtility.generatePasswordHash(user.password, user.salt);

    return Response.ok(await Query(context, values: user).insert());
  }
}
