import 'package:hive/hive.dart';
import 'package:radency_internship_project_2/models/budget/category_budget.dart';

import 'hive_types.dart';

class HiveProvider {
  static final HiveProvider _singleton = HiveProvider._internal();

  factory HiveProvider() {
    return _singleton;
  }

  HiveProvider._internal();

  Future<void> initializeHive(String path) async {
    Hive.init(path);
    try {
      await HiveProvider().openBudgetsBox();
    } catch (error) {
      print('HiveProvider: initialization error $error');
    }
  }

  final String budgetsBoxKey = 'budgetsBox';

  Future<Box<CategoryBudget>> openBudgetsBox() async {
    Box<CategoryBudget> box;
    if (!Hive.isBoxOpen(budgetsBoxKey)) {
      if (!Hive.isAdapterRegistered(HiveTypes.CATEGORY_BUDGET)) Hive.registerAdapter(CategoryBudgetAdapter());
      box = await Hive.openBox(budgetsBoxKey);
    } else
      box = Hive.box(budgetsBoxKey);
    return box;
  }
}
