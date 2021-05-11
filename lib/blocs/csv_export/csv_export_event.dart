part of 'csv_export_bloc.dart';

class CsvExportEvent {
  CsvExportEvent();
}

class ExportDataToCsv extends CsvExportEvent {
  ExportDataToCsv({this.data});

  final data;
}