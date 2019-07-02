import 'package:server/model/user.dart';
import 'package:server/model/expense.dart';
import 'package:aqueduct/aqueduct.dart';
import 'package:server/server.dart';

class Budget extends ManagedObject<_Budget> implements _Budget {}

class _Budget {
  @Column(primaryKey: true)
  int id;

  @Column(nullable: false)
  DateTime createdAt;

  @Column(nullable: false)
  DateTime updatedAt;

  @Relate(#budgets, onDelete: DeleteRule.cascade)
  User user;

  @Column(nullable: false)
  String name;

  ManagedSet<Expense> expenses;
}
