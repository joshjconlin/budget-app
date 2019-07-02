import 'package:server/model/budget.dart';
import 'package:aqueduct/managed_auth.dart';
import 'package:server/server.dart';

enum UserRole {
  admin,
  user,
}

class User extends ManagedObject<_User> implements _User, ManagedAuthResourceOwner<_User> {
  @Serialize(input: true, output: false)
  String password;
}

class _User extends ResourceOwnerTableDefinition {

  @Column(nullable: false)
  String firstName;

  @Column(nullable: false)
  String lastName;

  @Column(nullable: false)
  DateTime createdAt;

  @Column(nullable: false)
  DateTime updatedAt;

  UserRole role;

  ManagedSet<Budget> budgets;
}

//Basic Y29tLnRvZG9zLmFwcDpub3Rzb3NlY3JldA==
//aqueduct db upgrade --connect postgres://heroes_user:password@localhost:5432/heroes
//com.todos.app
//--secret notsosecret
//var clientID = "com.app.demo";
//var clientSecret = "mySecret";
//var body = "username=bob@stablekernel.com&password=foobar&grant_type=password";
//var clientCredentials = Base64Encoder().convert("$clientID:$clientSecret".codeUnits);
//
//var response = await http.post(
//  "https://stablekernel.com/auth/token",
//  headers: {
//    "Content-Type": "application/x-www-form-urlencoded",
//    "Authorization": "Basic $clientCredentials"
//  },
//  body: body);
