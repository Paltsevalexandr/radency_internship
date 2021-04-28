enum ExpenseType { income, outcome, transfer }

class ExpenseItemEntity {
  const ExpenseItemEntity(this.id, this.type, this.amount, this.dateTime,
      this.category, this.description)
      : assert(id != null);

  final int id;
  final String category;
  final String description;
  final ExpenseType type;
  final double amount;
  final DateTime dateTime;
}

class ExpenseWeeklyItemEntity {
  const ExpenseWeeklyItemEntity(this.id, this.income, this.outcome, this.weekNumber)
      : assert(id != null);

  final int id;
  final double income;
  final double outcome;
  final int weekNumber;
}


class ExpenseMonthlyItemEntity {
  const ExpenseMonthlyItemEntity(this.id, this.income, this.outcome, this.monthNumber)
      : assert(id != null);

  final int id;
  final double income;
  final double outcome;
  final int monthNumber;
}

class ExpenseSummaryItemEntity {
  const ExpenseSummaryItemEntity(this.id, this.income, this.outcomeCash, this.outcomeCreditCards)
    : assert(id != null);

  final int id;
  final double income;
  final double outcomeCash;
  final double outcomeCreditCards;
}
