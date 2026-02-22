import 'dart:convert';
import 'package:tingle/common/model/fetch_report_reason_model.dart';
import 'package:tingle/utils/api_service.dart';
import 'package:tingle/utils/utils.dart';

class FetchReportReasonApi {
  static Future<FetchReportReasonModel?> callApi({
    required String uid,
    required String token,
  }) async {
    Utils.showLog("Fetch Report Reason API Calling...");

    final response = await ApiService.get(uri: 'client/reportReason/all');

    if (response != null && response.statusCode == 200) {
      return FetchReportReasonModel.fromJson(jsonDecode(response.body));
    } else {
      Utils.showLog("Fetch Report Reason Network Error");
      return null;
    }
  }
}
