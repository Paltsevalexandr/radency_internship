import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:csv/csv.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'dart:core';

part 'csv_export_event.dart';
part 'csv_export_state.dart';

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

  createCsvString(expensesData) {
    var data = {
      'outcomeCreditCards': expensesData.outcomeCreditCards,
      'outcomeCash': expensesData.outcomeCash,
      'income': expensesData.income
    };
    String dataToJson = jsonEncode(data);
    String csv = ListToCsvConverter().convert([[dataToJson]]);
    return csv;
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
