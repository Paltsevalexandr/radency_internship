import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:radency_internship_project_2/models/budget/category_budget.dart';
import 'package:radency_internship_project_2/providers/hive/hive_provider.dart';

class HiveBudgets {
  Future<void> saveCategoryBudget({@required CategoryBudget categoryBudget}) async {
    Box<CategoryBudget> box = await HiveProvider().openBudgetsBox();
    await box.add(categoryBudget);
  }

  Future<List<CategoryBudget>> getBudgets() async {
    List<CategoryBudget> budgets = [];

    Box<CategoryBudget> box = await HiveProvider().openBudgetsBox();

    budgets.addAll(box.values);

    return budgets;
  }
}
