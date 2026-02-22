import 'dart:convert';
import 'package:tingle/page/login_page/model/fetch_login_user_profile_model.dart';
import 'package:tingle/utils/api_service.dart';
import 'package:tingle/utils/database.dart';
import 'package:tingle/utils/utils.dart';

class FetchLoginUserProfileApi {
  static FetchLoginUserProfileModel? fetchLoginUserProfileModel;

  static Future<void> callApi(
      {required String token, required String uid}) async {
    Utils.showLog("Get Login User Profile Api Calling...");

    final queryParams = {
      'userId': Database.loginUserId,
    };

    final response = await ApiService.get(
        uri: 'client/user/getProfile', queryParams: queryParams);

    if (response != null && response.statusCode == 200) {
      fetchLoginUserProfileModel =
          FetchLoginUserProfileModel.fromJson(jsonDecode(response.body));

      if (fetchLoginUserProfileModel?.status == true) {
        // Save it to local Database
        Database.onSetLoginUserProfile(
            jsonEncode(fetchLoginUserProfileModel?.toJson()));
        Utils.showLog("Login User Profile Saved Successfully ✅");
      } else {
        Utils.showLog(
            "Login User Profile Fetch Failed: ${fetchLoginUserProfileModel?.message}");
      }
    } else {
      Utils.showLog("Login User Profile Network Error");
    }
  }
}
