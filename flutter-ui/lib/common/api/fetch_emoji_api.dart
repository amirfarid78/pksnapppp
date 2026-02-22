import 'dart:convert';
import 'package:tingle/common/model/fetch_emoji_model.dart';
import 'package:tingle/utils/api_service.dart';
import 'package:tingle/utils/utils.dart';

class FetchEmojiApi {
  static Future<FetchEmojiModel?> callApi(
      {required String token, required String uid}) async {
    Utils.showLog("Fetch Emoji API Calling...");

    final response = await ApiService.get(uri: 'client/emoji/all');

    if (response != null && response.statusCode == 200) {
      return FetchEmojiModel.fromJson(jsonDecode(response.body));
    } else {
      Utils.showLog("Fetch Emoji Network Error");
      return null;
    }
  }
}
