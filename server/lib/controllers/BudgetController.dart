import 'package:server/model/budget.dart';
import 'package:server/model/expense.dart';
import 'package:server/model/user.dart';
import 'package:aqueduct/aqueduct.dart';
import 'package:server/server.dart';

class BudgetController extends ResourceController {
  BudgetController(this.context);

  ManagedContext context;

  @Operation.get()
  Future<Response> getBudgets() async {
    final budgetsQuery = Query<Budget>(context)
        ..where((b) => b.user.id).identifiedBy(request.authorization.ownerID)
        ..join(set: (b) => b.expenses);

    return Response.ok(await budgetsQuery.fetch());
  }

  @Operation.get('id')
  Future<Response> getBudget() async {
    final id = request.path.variables['id'];
    final budgetQuery = Query<Budget>(context)
        ..where((b) => b.user.id).identifiedBy(request.authorization.ownerID)
        ..where((b) => b.id).identifiedBy(id);

    return Response.ok(await budgetQuery.fetchOne());
  }

  @Operation.put('id')
  Future<Response> updateBudget(@Bind.body() Budget budget) async {
    final id = request.path.variables['id'];
    final budgetInsert = Query<Budget>(context)
      ..where((b) => b.user.id).identifiedBy(request.authorization.ownerID)
      ..where((b) => b.id).identifiedBy(id)
      ..values = budget;

    return Response.ok(await budgetInsert.insert());
  }

  @Operation.post()
  Future<Response> createBudget(@Bind.body() Budget budget) async {
    final userQuery = Query<User>(context)
      ..where((u) => u.id).identifiedBy(request.authorization.ownerID);

    budget.user = await userQuery.fetchOne();

    final budgetInsert = Query<Budget>(context)
      ..values = budget;

    return Response.ok(await budgetInsert.insert());
  }

  @Operation.delete('id')
  Future<Response> deleteBudget() async {
    final id = request.path.variables['id'];
    final deleteBudget = Query<Budget>(context)
        ..where((b) => b.user.id).identifiedBy(request.authorization.ownerID)
        ..where((b) => b.id).identifiedBy(id);

    return Response.ok(await deleteBudget.delete());
  }

}
