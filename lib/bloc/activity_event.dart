part of 'activity_bloc.dart';

@immutable
abstract class ActivityEvent {}

class SelectExcelFile extends ActivityEvent {}

class SearchExcelFile extends ActivityEvent {
  final List<List>? excelData;
  final num amountToBeSearched;
  SearchExcelFile({
    required this.excelData,
    required this.amountToBeSearched,
  });
}

class SearchAgain extends ActivityEvent {
  final List<List>? excelData;
  SearchAgain({
    this.excelData,
  });

}
