import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import 'package:num_game/repositories/activity_repo.dart';

part 'activity_event.dart';
part 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final ActivityRepo activityRepo;
  ActivityBloc({required this.activityRepo}) : super(ActivityInitial()) {
    on<ActivityEvent>((event, emit) async {
      if (event is SelectExcelFile) {
        await mapSelectExcelFileeventtoState(emit);
      } else if (event is SearchExcelFile) {
        await mapSearchExcelFileeventtoState(emit, event);
      } else if (event is SearchAgain) {
        emit(SelectedExcelFile(data: event.excelData));
      }
    });
  }

  Future<void> mapSelectExcelFileeventtoState(
      Emitter<ActivityState> emit) async {
    try {
      List<List>? _data = await activityRepo.selectExcelFile();
      if (_data != null) {
        emit(SelectedExcelFile(data: _data));
      } else {
        emit(EmptyExcelFile());
      }
    } catch (e) {
      emit(FailedToSelectExcelFile());
    }
  }

  Future<List<List>?> mapSearchExcelFileeventtoState(
      Emitter<ActivityState> emit, SearchExcelFile event) async {
    List<List>? data =
        activityRepo.searchExcelFile(event.excelData, event.amountToBeSearched);
    if (data != null && data.isNotEmpty) {
      emit(RecordsFoundState(excelData: data));
    } else {
      emit(NoRecordsFoundState());
    }
  }
}
