import 'dart:convert';
import 'package:tingle/page/connection_page/model/fetch_visitor_model.dart';
import 'package:tingle/utils/api_service.dart';
import 'package:tingle/utils/utils.dart';

class FetchVisitorApi {
  static Future<VisitorModel?> callApi({
    required String userId,
    required String token,
  }) async {
    Utils.showLog("Fetch Visitor API Calling...");

    final queryParams = {
      'userId': userId,
    };

    // Note: Assuming 'client/user/getVisitorList' based on standard naming convention in this project
    final response = await ApiService.get(
        uri: 'client/user/getVisitorList', queryParams: queryParams);

    if (response != null && response.statusCode == 200) {
      return VisitorModel.fromJson(jsonDecode(response.body));
    } else {
      Utils.showLog("Fetch Visitor Network Error");
      return VisitorModel(status: false, message: "Network Error");
    }
  }
}
