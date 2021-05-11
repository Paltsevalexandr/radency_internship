part of 'csv_export_bloc.dart';

class CsvExportState {
  CsvExportState();
}

class CsvExportStateInitial extends CsvExportState{
  CsvExportStateInitial();
}

class CsvExportLoadedState extends CsvExportState {
  CsvExportLoadedState({this.file});

  File file;
}