import 'dart:async';
import 'package:csv/csv.dart';
import 'package:bloc/bloc.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:radency_internship_project_2/repositories/transactions_repository.dart';
import 'package:radency_internship_project_2/models/transactions/transaction.dart';
import 'package:radency_internship_project_2/models/transactions/transactions_helper.dart';

part 'import_csv_event.dart';
part 'import_csv_state.dart';

class ImportCsvBloc extends Bloc<ImportCsvEvent, ImportCsvState> {
  ImportCsvBloc({this.transactionsRepository}) : super(ImportCsvInitial(expensesData: null));

  final TransactionsRepository transactionsRepository;

  @override
  Stream<ImportCsvState> mapEventToState(
      ImportCsvEvent event,
      ) async* {
    if(event is ImportCsvFile) {
      List<Transaction> expensesData = await getDataFromCsv();
      yield ImportCsvLoaded(expensesData: expensesData);
    }
  }

  Future<List<Transaction>> getDataFromCsv() async{
    FilePickerCross file = await importCsv();
    List<List<dynamic>> expensesData = CsvToListConverter().convert(file.toString());
   
    List<Transaction> listOfTransactions = createListOfTransactions(expensesData);

    listOfTransactions.forEach((transaction) async {
      await transactionsRepository.add(transaction);
    });

    return listOfTransactions;
  }

  List<Transaction> createListOfTransactions(expensesData) {
    List<Transaction> listOfExpenses = [];
    expensesData.removeAt(0); // first item is a header

    expensesData.forEach((element) {
      Transaction transaction = TransactionsHelper().fromStringInList(element);
      listOfExpenses.add(transaction);
    });
    
    return listOfExpenses;
  }

  Future<FilePickerCross> importCsv() async {
    FilePickerCross csvFile = await FilePickerCross.importFromStorage(
      type: FileTypeCross.custom,
      fileExtension: 'csv'
    );
    
    return csvFile;
  }
}