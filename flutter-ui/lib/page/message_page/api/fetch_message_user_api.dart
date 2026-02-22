import 'dart:convert';
import 'package:tingle/page/message_page/model/fetch_message_user_model.dart';
import 'package:tingle/utils/api_service.dart';
import 'package:tingle/utils/database.dart';
import 'package:tingle/utils/utils.dart';

class FetchMessageUserApi {
  static int startPagination = 1;
  static int limitPagination = 20;

  static Future<FetchMessageUserModel> callApi({
    required String uid,
    required String token,
    required String type, // all, online, unread
  }) async {
    Utils.showLog("Fetch Message User Api Calling...");

    final queryParams = {
      'userId': Database.loginUserId,
      'start': startPagination.toString(),
      'limit': limitPagination.toString(),
      'type': type,
    };

    final response = await ApiService.get(
        uri: 'client/chatTopic/chatList', queryParams: queryParams);

    if (response != null && response.statusCode == 200) {
      startPagination++;
      return FetchMessageUserModel.fromJson(jsonDecode(response.body));
    } else {
      Utils.showLog("Fetch Message User Network Error");
      return FetchMessageUserModel(status: false, message: "Network Error");
    }
  }
}
