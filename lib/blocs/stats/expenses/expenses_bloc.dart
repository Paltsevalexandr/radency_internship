import 'dart:async';
import 'package:radency_internship_project_2/utils/chart_random_colors.dart';
import 'package:radency_internship_project_2/models/expense_category.dart';
import 'package:bloc/bloc.dart';

part 'expenses_event.dart';
part 'expenses_state.dart';

class ExpensesBloc extends Bloc<ExpensesEvent, ExpensesState> {
  ExpensesBloc() : super(ExpensesInitial());

  @override
  Stream<ExpensesState> mapEventToState(
    ExpensesEvent event,
  ) async* {
    if(event is ExpensesLoaded) {
      yield ExpensesLoadedState(expenses: fillCategoriesInPercentsAndCurrency(event.expenses));
    }
  }
}

List<ExpenseCategory> fillCategoriesInPercentsAndCurrency(List<Map<String, double>> expensesData) {
  List<ExpenseCategory> allCategoriesInPercentsAndCurrency = [];
  List<CustomColor> colors  = randomColors(expensesData.length);
  List<Map<String, double>> sortedExpensesData = sortCategories(expensesData);

  int colorIndex = 0;
  sortedExpensesData.forEach((category) {
    category.keys.forEach((key) {
      double categoryInCurrency = category[key];
      double categoryInPercents = calcCategoryInPercents(categoryInCurrency, expensesData);

      ExpenseCategory categoryInPercentsAndCurrency = ExpenseCategory(
          expenseName: key,
          percents: categoryInPercents,
          currency: categoryInCurrency,
          color: colors[colorIndex]
      );

      allCategoriesInPercentsAndCurrency.add(categoryInPercentsAndCurrency);
      colorIndex++;
    });
  });
  return allCategoriesInPercentsAndCurrency;
}

double calcCategoryInPercents(categorySum, expensesData) {
  double expensesSum = calcSumOfExpenses(expensesData);
  double categoryInPercents = categorySum * 100 / expensesSum;
  double roundedCategoryInPercents = num.parse(categoryInPercents.toStringAsFixed(2));
  
  return roundedCategoryInPercents;
}

double calcSumOfExpenses(expensesData) {
  double expensesSum = 0;

  for(Map category in expensesData) {
    for(var key in category.keys) {
      expensesSum += category[key]; 
    }  
  }
  return expensesSum;
}

List<Map<String, double>> sortCategories(List<Map<String, double>> expensesData) {
  List<Map<String, double>> sortedData = expensesData;
  sortedData.sort((Map a, Map b) => List.from(b.values)[0].compareTo(List.from(a.values)[0]));
  return sortedData;
}
