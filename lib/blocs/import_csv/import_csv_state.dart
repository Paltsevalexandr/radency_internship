part of 'import_csv_bloc.dart';

abstract class ImportCsvState {
  ImportCsvState({this.expensesData});
  final expensesData;
}

class ImportCsvInitial implements ImportCsvState {
  ImportCsvInitial({this.expensesData});
  final expensesData;
}

class ImportCsvLoaded implements ImportCsvState {
  ImportCsvLoaded({this.expensesData});

 List<ExpenseItemEntity> expensesData;
}