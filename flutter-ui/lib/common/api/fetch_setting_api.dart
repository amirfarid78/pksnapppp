import 'dart:convert';
import 'package:tingle/common/model/fetch_setting_model.dart';
import 'package:tingle/utils/api_service.dart';
import 'package:tingle/utils/utils.dart';

class FetchSettingApi {
  static FetchSettingModel? fetchSettingModel;

  static Future<void> callApi(
      {required String uid, required String token}) async {
    Utils.showLog("Fetch Setting API Calling...");

    final response = await ApiService.get(uri: 'client/setting');

    if (response != null && response.statusCode == 200) {
      fetchSettingModel = FetchSettingModel.fromJson(jsonDecode(response.body));

      if (fetchSettingModel?.status == true) {
        Utils.showLog("Settings fetched successfully! ✅");
      } else {
        Utils.showLog("Settings Fetch Failed: ${fetchSettingModel?.message}");
      }
    } else {
      Utils.showLog("Settings Network Error");
    }
  }
}
