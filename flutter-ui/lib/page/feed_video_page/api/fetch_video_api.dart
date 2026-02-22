import 'dart:convert';
import 'package:tingle/page/feed_video_page/model/fetch_video_model.dart';
import 'package:tingle/utils/api_service.dart';
import 'package:tingle/utils/database.dart';
import 'package:tingle/utils/utils.dart';

class FetchVideoApi {
  static Future<FetchVideoModel?> callApi({int? start, int? limit}) async {
    Utils.showLog("Fetch All Video Api Calling...");

    final queryParams = {
      'userId': Database.loginUserId,
      'start': (start ?? 1).toString(),
      'limit': (limit ?? 20).toString(),
    };

    final response = await ApiService.get(
        uri: 'client/video/getVideos', queryParams: queryParams);

    if (response != null && response.statusCode == 200) {
      return FetchVideoModel.fromJson(jsonDecode(response.body));
    } else {
      Utils.showLog("Fetch Video Network Error");
      return null;
    }
  }
}
