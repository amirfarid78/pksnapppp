import 'dart:convert';
import 'package:tingle/common/model/fatch_other_user_profile_model.dart';
import 'package:tingle/utils/api_service.dart';
import 'package:tingle/utils/database.dart';
import 'package:tingle/utils/utils.dart';

class FetchOtherUserProfileInfoApi {
  static OtherUserProfileModel? otherUserProfileModel;

  static Future<OtherUserProfileModel?> callApi({
    required String token,
    required String uid,
    required String toUserId,
  }) async {
    Utils.showLog("Fetch Other User Profile Info API Calling...");

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
        final model = OtherUserProfileModel(
          status: true,
          message: jsonResponse['message'],
          user: User(
            id: userData['_id'],
            name: userData['name'],
            userName: userData['userName'],
            gender: userData['gender'],
            image: userData['image'],
            countryFlagImage: userData['countryFlagImage'],
            country: userData['country'],
            isVerified: userData['isVerified'],
            totalFollowers: data['totalFollowers'],
            totalFollowing: data['totalFollowing'],
            isFollowed: data['isFollow'],
            // totalFriends: data['totalFriends'], // Add if backend provides it
          ),
        );
        otherUserProfileModel = model;
        return model;
      } else {
        return OtherUserProfileModel.fromJson(jsonResponse);
      }
    } else {
      Utils.showLog("Fetch Other User Profile Network Error");
      return null;
    }
  }
}
