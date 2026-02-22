import 'dart:convert';
import 'package:tingle/common/model/fetch_user_coin_model.dart';
import 'package:tingle/utils/api_service.dart';
import 'package:tingle/utils/database.dart';
import 'package:tingle/utils/utils.dart';

class FetchUserCoinApi {
  static Future<FetchUserCoinModel?> callApi(
      {required String token, required String uid}) async {
    Utils.showLog("Fetch User Coin API Calling...");

    final queryParams = {
      'userId': Database.loginUserId,
    };

    final response = await ApiService.get(
        uri: 'client/user/getProfile', queryParams: queryParams);

    if (response != null && response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == true && jsonResponse['user'] != null) {
        return FetchUserCoinModel(
          status: true,
          message: "User coin fetched successfully",
          coinBalance: jsonResponse['user']['coin'],
        );
      } else {
        return FetchUserCoinModel(status: false, message: "User not found");
      }
    } else {
      Utils.showLog("Fetch User Coin Network Error");
      return null;
    }
  }
}
