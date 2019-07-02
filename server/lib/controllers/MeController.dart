import 'package:server/server.dart';
import 'package:aqueduct/aqueduct.dart';
import 'package:server/model/user.dart';

class MeController extends ResourceController {
  MeController(this.context);

  final ManagedContext context;

  @Operation.get()
  Future<Response> getMe() async {
    final userId = request.authorization.ownerID;
    final meQuery = Query<User>(context)
      ..where((u) => u.id).equalTo(userId);

    return Response.ok(await meQuery.fetchOne());
  }

//  todo @Bind.body(ignore: ['role']), add user controller for admins only
  @Operation.post()
  Future<Response> updateMe(@Bind.body() User user) async {
    user.updatedAt = DateTime.now();

    final userInsert = Query<User>(context)
        ..where((u) => u.id).equalTo(request.authorization.ownerID)
        ..values = user;

    final insertedUser = await userInsert.insert();
    return Response.ok(insertedUser);
  }

}
