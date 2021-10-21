import 'package:num_game/providers/activity_provider.dart';

abstract class BaseActivityRepo {
  Future<void> selectExcelFile();
}

class ActivityRepo extends BaseActivityRepo {
  ActivityProvider activityProvider = ActivityProvider();
  @override
  Future<List<List>?> selectExcelFile() async=>await activityProvider.selectExcelFile();
  List<List>? searchExcelFile(List<List>? excelData, num amountToBeSearched ) => activityProvider.searchExcelFile(excelData, amountToBeSearched);
}
