import 'dart:convert';
import 'package:tingle/page/feed_page/model/fetch_post_model.dart';
import 'package:tingle/utils/api_service.dart';
import 'package:tingle/utils/database.dart';
import 'package:tingle/utils/utils.dart';

class FetchPostApi {
  static Future<FetchPostModel?> callApi({int? start, int? limit}) async {
    Utils.showLog("Fetch All Post Api Calling...");

    final queryParams = {
      'userId': Database.loginUserId,
      'start': (start ?? 1).toString(),
      'limit': (limit ?? 20).toString(),
    };

    final response = await ApiService.get(
        uri: 'client/post/getAllPosts', queryParams: queryParams);

    if (response != null && response.statusCode == 200) {
      return FetchPostModel.fromJson(jsonDecode(response.body));
    } else {
      Utils.showLog("Fetch Post Network Error");
      return null;
    }
  }
}
