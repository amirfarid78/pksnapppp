import 'dart:convert';
import 'package:tingle/page/connection_page/model/search_connection_model.dart';
import 'package:tingle/utils/api_service.dart';
import 'package:tingle/utils/utils.dart';

class SearchConnectionApi {
  static Future<SearchConnectionModel?> callApi({
    required String searchString,
    required String type,
  }) async {
    Utils.showLog("Search Connection API Calling...");

    final queryParams = {
      'searchString': searchString,
      'type': type,
    };

    final response = await ApiService.get(
        uri: 'client/user/search', queryParams: queryParams);

    if (response != null && response.statusCode == 200) {
      return SearchConnectionModel.fromJson(jsonDecode(response.body));
    } else {
      Utils.showLog("Search Connection Network Error");
      return SearchConnectionModel(status: false, message: "Network Error");
    }
  }
}
