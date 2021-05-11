import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:radency_internship_project_2/ui/category_page/category_page_common.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'category_event.dart';
part 'category_state.dart';

const String incomeList = "incomeList";
const String expensesList = "expensesList";

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  SharedPreferences prefs;

  CategoryBloc() : super(CategoryState(incomeCategories: List.empty(), expensesCategories: List.empty())) {
    add(LoadCategoriesFromSharedPreferences());
  }

  CategoryState changeCategory(String categoryType, List<CategoryItemData> items) {
    if (categoryType == incomeList) {
      return CategoryState(
        incomeCategories: items,
        expensesCategories: state.expensesCategories,
        nextIncomeCategoryId: state.nextIncomeCategoryId,
        nextExpenseCategoryId: state.nextExpenseCategoryId,
      );
    } else {
      return CategoryState(
        incomeCategories: state.incomeCategories,
        expensesCategories: items,
        nextIncomeCategoryId: state.nextIncomeCategoryId,
        nextExpenseCategoryId: state.nextExpenseCategoryId,
      );
    }
  }

  CategoryState changeCategoryCounter(String categoryType, int newValue) {
    if (categoryType == incomeList) {
      return CategoryState(
        incomeCategories: state.incomeCategories,
        expensesCategories: state.expensesCategories,
        nextIncomeCategoryId: newValue,
        nextExpenseCategoryId: state.nextExpenseCategoryId,
      );
    } else {
      return CategoryState(
        incomeCategories: state.incomeCategories,
        expensesCategories: state.expensesCategories,
        nextIncomeCategoryId: state.nextIncomeCategoryId,
        nextExpenseCategoryId: newValue,
      );
    }
  }

  CategoryState loadFromPreferences() {
    //TODO Impl SharedPrefs!
    var incomeListRaw = prefs.getString(incomeList);
    var expensesListRaw = prefs.getString(expensesList);
    var incomeId = prefs.getInt(expensesList);
    var expensesId = prefs.getInt(expensesList);

    var incomeItems = [];
    for (int i = 0; i < 30; ++i) {
      String label = "Category $i";
      incomeItems.add(CategoryItemData(label, ValueKey(i)));
    }

    var outcomeItems = [];
    for (int i = 0; i < 30; ++i) {
      String label = "OutCategory $i";
      outcomeItems.add(CategoryItemData(label, ValueKey(i)));
    }

    return CategoryState(
        incomeCategories: incomeItems.cast<CategoryItemData>(),
        expensesCategories: outcomeItems.cast<CategoryItemData>(),
        nextIncomeCategoryId: 30,
        nextExpenseCategoryId: 30);
  }

  @override
  Stream<CategoryState> mapEventToState(CategoryEvent event) async* {
    if (event is ChangeCategory) {
      yield changeCategory(event.settingName, event.listSettingValue.cast<CategoryItemData>());
    }

    if (event is ChangeCategoryCounter) {
      yield changeCategoryCounter(event.settingName, event.settingValue);
    }

    if (event is LoadCategoriesFromSharedPreferences) {
      prefs = await SharedPreferences.getInstance();

      yield loadFromPreferences();
    }
  }
}
