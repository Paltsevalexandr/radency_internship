import 'dart:async';
import 'package:csv/csv.dart';
import 'package:bloc/bloc.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:radency_internship_project_2/models/expense_item.dart';
import 'package:radency_internship_project_2/models/location.dart';

part 'import_csv_event.dart';
part 'import_csv_state.dart';

class ImportCsvBloc extends Bloc<ImportCsvEvent, ImportCsvState> {
  ImportCsvBloc() : super(ImportCsvInitial(expensesData: null));

  @override
  Stream<ImportCsvState> mapEventToState(
      ImportCsvEvent event,
      ) async* {
    if(event is ImportCsvFile) {
      List<ExpenseItemEntity> expensesData = await getDataFromCsv();
      yield ImportCsvLoaded(expensesData: expensesData);
    }
  }

  Future<List<ExpenseItemEntity>> getDataFromCsv() async{
    FilePickerCross file = await importCsv();
    List<List<dynamic>> expensesData = CsvToListConverter().convert(file.toString());
   
    List<List> listOfExpenses = createListOfExpenses(expensesData);
    List<ExpenseItemEntity> listOfExpenseItemEntity = [];

    listOfExpenses.forEach((expense) {
      Map expenseMap = createExpenseMap(expense);
      listOfExpenseItemEntity.add(createExpenseEntity(expenseMap));
    });
    return listOfExpenseItemEntity;
  }

  List<List> createListOfExpenses(expensesData) {
    List<List> listOfExpenses = [];

    expensesData.forEach((element) {
      List expense = element[0].split(';');
      listOfExpenses.add(expense);
    });
    listOfExpenses.removeAt(0); // first item was a header
    return listOfExpenses;
  }

  Map createExpenseMap(expense) {
    Map expenseModel = {
      'id': int.tryParse(expense[0]),
      'type': chooseExpenseType(expense[1]),
      'amount': double.tryParse(expense[2]),
      'dateTime': DateTime.tryParse(expense[3]),
      'category': expense[4],
      'description': expense[5],
      'expenseLocation': createExpenseLocation(expense)
    };
    return expenseModel;
  }

  ExpenseItemEntity createExpenseEntity(Map expenseModel) {
    ExpenseItemEntity expenseEntity = ExpenseItemEntity(
      expenseModel['id'],
      expenseModel['type'],
      expenseModel['amount'],
      expenseModel['dateTime'],
      expenseModel['category'],
      expenseModel['description'],
      expenseLocation: createExpenseLocation(expenseModel));

    return expenseEntity;
  }

  createExpenseLocation(expense) {
    if(expense[6] != null
    && expense[7] != null
    && expense[8] != null) {
    
      return ExpenseLocation(
        address: expense[6], 
        latitude: double.tryParse(expense[7]),
        longitude: double.tryParse(expense[8])
      );
    }
    return null;
  }

  Future<FilePickerCross> importCsv() async {
    FilePickerCross csvFile = await FilePickerCross.importFromStorage(
      type: FileTypeCross.custom,
      fileExtension: 'csv'
    );
    
    return csvFile;
  }

  chooseExpenseType(type) {
    switch(type){
      case("income"):
        return ExpenseType.income;
      case("outcome"):
        return ExpenseType.outcome;
      case("transfer"):
        return ExpenseType.transfer;
    }
  }
}