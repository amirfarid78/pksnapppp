import 'dart:convert';
import 'package:tingle/page/login_page/model/login_model.dart';
import 'package:tingle/utils/api_service.dart';

class LoginApi {
  static Future<LoginModel> callApi({
    String? name,
    String? userName,
    String? image,
    String? mobileNumber,
    required String email,
    required String identity,
    required String fcmToken,
    required String token,
    required String uid,
    required int loginType,
  }) async {
    final Map<String, dynamic> body = {
      'loginType': loginType,
      'identity': identity,
      'fcmToken': fcmToken,
      'email': email,
    };

    if (name != null) body['name'] = name;
    if (userName != null) body['userName'] = userName;
    if (image != null) body['image'] = image;
    if (mobileNumber != null) body['mobileNumber'] = mobileNumber;

    final response =
        await ApiService.post(uri: 'client/user/loginOrSignUp', body: body);

    if (response != null && response.statusCode == 200) {
      return LoginModel.fromJson(jsonDecode(response.body));
    } else {
      return LoginModel(status: false, message: "Network Error");
    }
  }
}
