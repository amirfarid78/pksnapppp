import 'dart:convert';
import 'package:tingle/page/profile_page/model/fetch_user_profile_model.dart';
import 'package:tingle/utils/api_service.dart';
import 'package:tingle/utils/database.dart';
import 'package:tingle/utils/utils.dart';

class FetchUserProfileApi {
  static Future<FetchUserProfileModel?> callApi(
      {required String toUserId}) async {
    Utils.showLog("Fetch User Profile Api Calling...");

    final queryParams = {
      'userId': Database.loginUserId,
      'toUserId': toUserId,
    };

    final response = await ApiService.get(
        uri: 'client/user/getUserProfile', queryParams: queryParams);

    if (response != null && response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == true &&
          jsonResponse['userProfileData'] != null) {
        final data = jsonResponse['userProfileData'];
        final userData = data['user'];

        // Map backend userProfileData structure to Flutter model
        return FetchUserProfileModel(
          status: true,
          message: jsonResponse['message'],
          user: User(
            name: userData['name'],
            userName: userData['userName'],
            gender: userData['gender'],
            image: userData['image'],
            countryFlagImage: userData['countryFlagImage'],
            country: userData['country'],
            isVerified: userData['isVerified'],
            totalFollowers: data['totalFollowers'],
            totalFollowing: data['totalFollowing'],
            // totalLikesOfVideoPost: data['totalLikesOfVideoPost'], // Flutter model doesn't have this field yet
          ),
        );
      } else {
        return FetchUserProfileModel.fromJson(jsonResponse);
      }
    } else {
      Utils.showLog("Fetch User Profile Network Error");
      return null;
    }
  }
}
