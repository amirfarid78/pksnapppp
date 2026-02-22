import 'dart:convert';
import 'package:tingle/page/connection_page/model/fetch_following_follower_model.dart';
import 'package:tingle/utils/api_service.dart';
import 'package:tingle/utils/database.dart';
import 'package:tingle/utils/utils.dart';

class FetchGetSocialListsApi {
  static Future<FollowerFollowingModel?> callApi() async {
    Utils.showLog("Fetch Social Lists Api Calling...");

    final queryParams = {
      'userId': Database.loginUserId,
    };

    try {
      final friendsResponse = await ApiService.get(
          uri: 'client/follower/friends', queryParams: queryParams);
      final followingResponse = await ApiService.get(
          uri: 'client/follower/followingList', queryParams: queryParams);
      final followersResponse = await ApiService.get(
          uri: 'client/follower/followerList', queryParams: queryParams);

      List<Follower> friends = [];
      List<Follower> following = [];
      List<Follower> followers = [];

      if (friendsResponse != null && friendsResponse.statusCode == 200) {
        final data = jsonDecode(friendsResponse.body);
        if (data['friends'] != null) {
          friends = (data['friends'] as List)
              .map((v) => Follower.fromJson(v))
              .toList();
        }
      }

      if (followingResponse != null && followingResponse.statusCode == 200) {
        final data = jsonDecode(followingResponse.body);
        if (data['following'] != null) {
          following = (data['following'] as List)
              .map((v) => Follower.fromJson(v))
              .toList();
        }
      }

      if (followersResponse != null && followersResponse.statusCode == 200) {
        final data = jsonDecode(followersResponse.body);
        if (data['follower'] != null) {
          followers = (data['follower'] as List)
              .map((v) => Follower.fromJson(v))
              .toList();
        }
      }

      return FollowerFollowingModel(
        status: true,
        message: 'Social lists fetched successfully',
        friends: friends,
        following: following,
        followers: followers,
      );
    } catch (e) {
      Utils.showLog("Fetch Social Lists Error: $e");
      return null;
    }
  }
}
