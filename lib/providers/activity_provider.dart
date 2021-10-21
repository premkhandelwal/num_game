import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:num_game/shared_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

abstract class BaseProvider {
  Future<List<List>?> selectExcelFile();
  List<List>? searchExcelFile(List<List>? excelData, num amountToBeSearched);
}

class ActivityProvider extends BaseProvider {
  @override
  Future<List<List>?> selectExcelFile() async {
    try {
      var picked = await FilePicker.platform
          .pickFiles(allowedExtensions: ['xlx', 'xlsx'], type: FileType.custom);

      if (picked != null) {
        String? path = picked.files.first.path;
        if (path != null) {
          var bytes = File(path).readAsBytesSync();
          var decoder = SpreadsheetDecoder.decodeBytes(bytes);
          var table = decoder.tables['Sheet1'];
          // var values = table!.rows[1];
          table!.rows.removeAt(0);

          List<List> resultList = table.rows;
          resultList.insert(0, [picked.files.first.name]);
          String encodedData = SharedObject.toJson(resultList);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("data", encodedData);
          return resultList;
        }
      }
      return null;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  List<List>? searchExcelFile(List<List>? excelData, num amountToBeSearched) {
    if (excelData != null) {
      excelData.removeWhere((record) => record.length == 1);
      excelData.removeWhere((ele) => ele[1] != amountToBeSearched);
      return excelData;
    }
    return null;
  }
}
