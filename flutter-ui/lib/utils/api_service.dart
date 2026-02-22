import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tingle/utils/constant.dart';
import 'package:tingle/utils/utils.dart';

class ApiService {
  static Map<String, String> get headers => {
        'key': AppConstant.secretKey,
        'Content-Type': 'application/json',
      };

  static Future<http.Response?> post({required String uri, required Map<String, dynamic> body}) async {
    try {
      final url = Uri.parse(AppConstant.baseUrl + uri);
      Utils.showLog("POST URL: $url");
      Utils.showLog("POST BODY: ${jsonEncode(body)}");
      
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      
      Utils.showLog("POST RESPONSE [${response.statusCode}]: ${response.body}");
      return response;
    } catch (e) {
      Utils.showLog("POST ERROR: $e");
      return null;
    }
  }

  static Future<http.Response?> get({required String uri, Map<String, String>? queryParams}) async {
    try {
      var urlString = AppConstant.baseUrl + uri;
      if (queryParams != null && queryParams.isNotEmpty) {
        final queryString = Uri(queryParameters: queryParams).query;
        urlString += "?$queryString";
      }
      
      final url = Uri.parse(urlString);
      Utils.showLog("GET URL: $url");
      
      final response = await http.get(url, headers: headers);
      
      Utils.showLog("GET RESPONSE [${response.statusCode}]: ${response.body}");
      return response;
    } catch (e) {
      Utils.showLog("GET ERROR: $e");
      return null;
    }
  }

  static Future<http.Response?> patch({required String uri, required Map<String, dynamic> body}) async {
    try {
      final url = Uri.parse(AppConstant.baseUrl + uri);
      Utils.showLog("PATCH URL: $url");
      
      final response = await http.patch(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      
      Utils.showLog("PATCH RESPONSE [${response.statusCode}]: ${response.body}");
      return response;
    } catch (e) {
      Utils.showLog("PATCH ERROR: $e");
      return null;
    }
  }

  static Future<http.Response?> delete({required String uri}) async {
    try {
      final url = Uri.parse(AppConstant.baseUrl + uri);
      Utils.showLog("DELETE URL: $url");
      
      final response = await http.delete(url, headers: headers);
      
      Utils.showLog("DELETE RESPONSE [${response.statusCode}]: ${response.body}");
      return response;
    } catch (e) {
      Utils.showLog("DELETE ERROR: $e");
      return null;
    }
  }
}
