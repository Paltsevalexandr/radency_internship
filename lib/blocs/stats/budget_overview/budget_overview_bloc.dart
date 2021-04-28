import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';
import 'package:radency_internship_project_2/models/budget/category_budget.dart';
import 'package:radency_internship_project_2/models/budget/monthly_category_expense.dart';
import 'package:radency_internship_project_2/providers/hive/hive_budgets.dart';
import 'package:radency_internship_project_2/utils/date_formatters.dart';
import 'package:radency_internship_project_2/utils/mocked_expenses.dart';

part 'budget_overview_event.dart';

part 'budget_overview_state.dart';

class BudgetOverviewBloc extends Bloc<BudgetOverviewEvent, BudgetOverviewState> {
  BudgetOverviewBloc() : super(BudgetOverviewInitial());

  DateTime _observedDate;
  String _sliderCurrentTimeIntervalString = '';

  List<MonthlyCategoryExpense> monthlyCategoryExpenses = [];
  List<CategoryBudget> budgets = [];

  MonthlyCategoryExpense summary;

  StreamSubscription budgetOverviewSubscription;

  @override
  Future<void> close() {
    budgetOverviewSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<BudgetOverviewState> mapEventToState(
    BudgetOverviewEvent event,
  ) async* {
    if (event is BudgetOverviewInitialize) {
      yield* _mapBudgetOverviewInitializeToState();
    } else if (event is BudgetOverviewGetPreviousMonthPressed) {
      yield* _mapBudgetOverviewGetPreviousMonthPressedToState();
    } else if (event is BudgetOverviewGetNextMonthPressed) {
      yield* _mapBudgetOverviewGetNextMonthPressedToState();
    } else if (event is BudgetOverviewFetchRequested) {
      yield* _mapBudgetOverviewFetchRequestedToState(dateForFetch: event.dateForFetch);
    } else if (event is BudgetOverviewDisplayRequested) {
      yield* _mapTransactionDailyDisplayRequestedToState();
    } else if (event is BudgetOverviewCategoryBudgetSaved) yield* _mapBudgetOverviewCategoryBudgetSavedToState(event.categoryBudget);
  }

  Stream<BudgetOverviewState> _mapBudgetOverviewFetchRequestedToState({@required DateTime dateForFetch}) async* {
    budgetOverviewSubscription?.cancel();

    _sliderCurrentTimeIntervalString = DateFormatters().monthNameAndYearFromDateTimeString(_observedDate);
    yield BudgetOverviewLoading(sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString);
    budgetOverviewSubscription = MockedExpensesItems().generateMonthlyCategoryExpenses().asStream().listen((fetchedMonthlyCategoryExpensesList) {
      monthlyCategoryExpenses.clear();
      monthlyCategoryExpenses = fetchedMonthlyCategoryExpensesList;

      add(BudgetOverviewDisplayRequested());
    });
  }

  Stream<BudgetOverviewState> _mapTransactionDailyDisplayRequestedToState() async* {
    _sortCategories();
    _calculateBudgetSummary();

    yield BudgetOverviewLoaded(
        sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString, monthlyCategoryExpenses: monthlyCategoryExpenses, summary: summary);
  }

  Stream<BudgetOverviewState> _mapBudgetOverviewInitializeToState() async* {
    _observedDate = DateTime.now();
    await _fetchSavedBudget();

    add(BudgetOverviewFetchRequested(dateForFetch: _observedDate));
  }

  Stream<BudgetOverviewState> _mapBudgetOverviewGetPreviousMonthPressedToState() async* {
    _observedDate = DateTime(_observedDate.year, _observedDate.month - 1);
    add(BudgetOverviewFetchRequested(dateForFetch: _observedDate));
  }

  Stream<BudgetOverviewState> _mapBudgetOverviewGetNextMonthPressedToState() async* {
    _observedDate = DateTime(_observedDate.year, _observedDate.month + 1);
    add(BudgetOverviewFetchRequested(dateForFetch: _observedDate));
  }

  Stream<BudgetOverviewState> _mapBudgetOverviewCategoryBudgetSavedToState(CategoryBudget categoryBudget) async* {
    await HiveBudgets().saveCategoryBudget(categoryBudget: categoryBudget);
    await _fetchSavedBudget();

    add(BudgetOverviewDisplayRequested());
  }

  Future<void> _fetchSavedBudget() async {
    budgets = await HiveBudgets().getBudgets();
  }

  void _sortCategories() {
    if (budgets.isNotEmpty) {
      budgets.forEach((budgetEntry) {
        monthlyCategoryExpenses.firstWhere((monthlyCategoryExpense) => monthlyCategoryExpense.category == budgetEntry.category).budgetTotal =
            budgetEntry.budgetValue;
      });
    }

    // Calculating usage
    monthlyCategoryExpenses.forEach((monthlyCategoryExpense) {
      monthlyCategoryExpense.budgetLeft = monthlyCategoryExpense.budgetTotal - monthlyCategoryExpense.expenseAmount;
      monthlyCategoryExpense.budgetUsage = monthlyCategoryExpense.expenseAmount / monthlyCategoryExpense.budgetTotal;
    });

    monthlyCategoryExpenses.sort((a, b) => b.expenseAmount.compareTo(a.expenseAmount));
    monthlyCategoryExpenses.sort((a, b) => b.budgetTotal.compareTo(a.budgetTotal));
  }

  void _calculateBudgetSummary() {
    double summaryBudgetSpent = 0;
    double summaryBudgetTotal = 0;

    // Calculating usage and leftover
    monthlyCategoryExpenses.forEach((monthlyCategoryExpense) {
      if (monthlyCategoryExpense.budgetTotal > 0) {
        summaryBudgetTotal += monthlyCategoryExpense.budgetTotal;
        summaryBudgetSpent += monthlyCategoryExpense.expenseAmount;
      }
    });

    double summaryBudgetLeft = summaryBudgetTotal - summaryBudgetSpent;
    double summaryBudgetUsage = summaryBudgetSpent / summaryBudgetTotal;

    summary = MonthlyCategoryExpense(
        category: S.current.statsBudgetMonthlyTotalTitle,
        expenseAmount: summaryBudgetSpent,
        budgetTotal: summaryBudgetTotal,
        budgetLeft: summaryBudgetLeft,
        budgetUsage: summaryBudgetUsage);
  }
}
