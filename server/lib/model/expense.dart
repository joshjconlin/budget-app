import 'package:server/server.dart';
import 'package:aqueduct/aqueduct.dart';
import 'package:server/model/budget.dart';
import 'package:server/server.dart' as prefix0;

enum ExpenseType {
  personal,
  recreation,
  entertainment,
  utility,
  bill,
  subscription,
  fee,
  legalExpense,
  fine,
  carPayment,
  mortgage,
  loanPayment,
  creditCardPayment,
  misc,
}

class Expense extends ManagedObject<_Expense> implements _Expense {}

class _Expense {
  @Column(primaryKey: true)
  int id;

  @Column(nullable: false)
  DateTime createdAt;

  @Column(nullable: false)
  DateTime updatedAt;

  @Relate(#expenses, onDelete: DeleteRule.cascade)
  Budget budget;

  @Column(nullable: false)
  bool recurringExpense;

  @Column(nullable: false)
  String name;

  @Column(nullable: false)
  double amount;

  @Column()
  DateTime recurringDate;

  @Column()
  String note;

  ExpenseType expenseType;

}
