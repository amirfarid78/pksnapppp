import 'dart:convert';
import 'package:tingle/common/model/fetch_gift_gallery_model.dart';
import 'package:tingle/utils/api_service.dart';
import 'package:tingle/utils/database.dart';
import 'package:tingle/utils/utils.dart';

class FetchGiftGalleryApi {
  static int startPagination = 1;
  static int limitPagination = 20;

  static Future<FetchGiftGalleryModel?> callApi({
    required String uid,
    required String token,
    required String userId,
  }) async {
    Utils.showLog("Fetch Gift Gallery API Calling...");

    final queryParams = {
      'userId': Database.loginUserId,
      'start': startPagination.toString(),
      'limit': limitPagination.toString(),
    };

    final response =
        await ApiService.get(uri: 'client/gift/all', queryParams: queryParams);

    if (response != null && response.statusCode == 200) {
      startPagination++;
      return FetchGiftGalleryModel.fromJson(jsonDecode(response.body));
    } else {
      Utils.showLog("Fetch Gift Gallery Network Error");
      return null;
    }
  }
}
