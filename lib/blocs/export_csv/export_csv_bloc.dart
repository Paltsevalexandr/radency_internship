import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'dart:core';
import 'package:radency_internship_project_2/models/expense_item.dart';

part 'export_csv_event.dart';
part 'export_csv_state.dart';

class CsvExportBloc extends Bloc<CsvExportEvent, CsvExportState> {
  CsvExportBloc() : super(CsvExportStateInitial());

  @override
  Stream<CsvExportState> mapEventToState(
      CsvExportEvent event,
      ) async* {
      if(event is ExportDataToCsv) {
        File csvFile = await saveCSV(event.data);
        yield CsvExportLoadedState(file: csvFile);
      }
  }

  saveCSV(expensesData) async {
    String filePath = await getCsvFilePath();
    String csv = createCsvString(expensesData);

    File file = File(filePath);
    file.writeAsString(csv);

    shareData(filePath);
    return file;
  }

  createCsvString(Map<int, List<ExpenseItemEntity>> expensesData) {
    List tableHeader = ['id', 'type', 'amount', 'dateTime', 'category', 'description', 'address', 'latitude', 'longitude'];
    List<List> convertedData = [
      [tableHeader.join(';')]
    ];

    expensesData.keys.forEach((key) {
      convertedData += convertDataToListOfStrings(expensesData[key]);
    });
    
    String csv = ListToCsvConverter().convert(convertedData);
    return csv;
  }

  List<List<String>> convertDataToListOfStrings(expensesData) {
    List<List<String>> dataToListOfStrings = [];

    expensesData.forEach((ExpenseItemEntity expense){
      List<String> expenseToStringInList = createSingleExpense(expense);
      dataToListOfStrings.add(expenseToStringInList);
    });
    return dataToListOfStrings;
  }

  List<String> createSingleExpense(ExpenseItemEntity expense) {
    List expenseToList = [
      expense.id,
      expense.type.toString().split('.')[1],
      expense.amount,
      expense.dateTime.toString(),
      expense.category,
      expense.description,
      expense.expenseLocation.address, 
      expense.expenseLocation.latitude,
      expense.expenseLocation.longitude
    ];
    String expenseToString = expenseToList.join(";");
    return [expenseToString];
  }

  Future<String> getCsvFilePath() async{
    Directory dir = await getExternalStorageDirectory();
    String path = dir.path;
    var timestamp = DateTime.now();
    var milliseconds = timestamp.millisecondsSinceEpoch;
    return '$path/expensesData$milliseconds.csv';
  }

  shareData(path) {
    Share.shareFiles([path]);
  }
}
