part of 'category_bloc.dart';

class CategoryState {
  CategoryState({this.incomeCategories, this.nextIncomeCategoryId, this.expensesCategories, this.nextExpenseCategoryId});

  final List<CategoryItemData> incomeCategories;
  final List<CategoryItemData> expensesCategories;
  final int nextIncomeCategoryId;
  final int nextExpenseCategoryId;
}
