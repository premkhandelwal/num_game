part of 'activity_bloc.dart';

@immutable
abstract class ActivityState {}

class ActivityInitial extends ActivityState {}

class SelectedExcelFile extends ActivityState {
  final List<List>? data;
  final String? fileName;
  SelectedExcelFile({
    this.data,
    this.fileName,
  });
}

class EmptyExcelFile extends ActivityState {}

class FailedToSelectExcelFile extends ActivityState {}

class RecordsFoundState extends ActivityState {
  final List<List> excelData;
  RecordsFoundState({
    required this.excelData,
  });
}

class NoRecordsFoundState extends ActivityState {}
