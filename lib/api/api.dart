import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:melton_app/models/PostModel.dart';
import 'package:melton_app/models/UserModel.dart';
import 'package:melton_app/models/ProfileModel.dart';
import 'package:melton_app/models/StoreModel.dart';

import 'dart:async';
import 'dart:convert';

// todo make singleton
class ApiService {

  static const apiUrl = "https://meltonapp.com/api/";
  static const users =  "users/";
  static const profile = "profile/";
  static const store_shop = "store/";
  static const store_buy = "buy/";
  static const post_preview = "posts/";
  static const search = "?search=";

  //todo handle token
  static String token = "Token " + "01648b86381661953af858808aebf827ad14922d";
  static Map<String, String> authHeader = {"Authorization": token};
  static Map<String, String> authAndJsonContentHeader = {
    "Authorization": token,
    "Content-Type": "application/json",
  };

  Future<List<UserModel>> getUsers() async {
    http.Response response = await http.get(apiUrl + users, headers: authHeader);
    bool result = handleError(response);
    if (result) {
      List<dynamic> jsonResponse = json.decode(response.body);
      List<UserModel> users = new List<UserModel>();
      for (int i = 0; i < jsonResponse.length; i++) {
        UserModel user =  UserModel.fromJson(jsonResponse[i]);
        users.add(user);
      }
      return users;
    } else {
      //todo show error msg
      print("request failed");
    }
  }

  Future<UserModel> getUserModelById(int id) async{
    http.Response response = await http.get(apiUrl + users+ id.toString(), headers: authHeader);
    bool result = handleError(response);
    if (result) {
      return UserModel.fromJson(json.decode(response.body));
    }
    else {
      //todo show error msg
      print("request failed");
    }
    return UserModel();
  }

  Future<List<UserModel>> getUserModelByName(String name) async{
    http.Response response = await http.get(apiUrl + users + search + name, headers: authHeader);
    bool result = handleError(response);
    if (result) {
      List<dynamic> jsonResponse = json.decode(response.body);
      List<UserModel> users = new List<UserModel>();
      for (int i = 0; i < jsonResponse.length; i++) {
        UserModel user =  UserModel.fromJson(jsonResponse[i]);
        users.add(user);
      }
      return users;
    } else {
      //todo show error msg
      print("request failed");
    }
  }

  Future<ProfileModel> getProfile() async {
    http.Response response = await http.get(apiUrl + profile, headers: authHeader);
    bool result = handleError(response);
    if (result) {
      return ProfileModel.fromJson(json.decode(response.body));
    }
    else {
      //todo show error msg
      print("request failed");
    }
  }

  Future<List<StoreModel>> getStoreItems() async {
    http.Response response = await http.get(apiUrl + store_shop, headers: authHeader);
    bool result = handleError(response);
    if (result) {
      List<dynamic> jsonResponse = json.decode(response.body);
      List<StoreModel> items = new List<StoreModel>();
      for (int i = 0; i < jsonResponse.length; i++) {
        StoreModel item =  StoreModel.fromJson(jsonResponse[i]);
        items.add(item);
      }
      return items;
    } else {
      //todo show error msg snackbar?
      print("request failed");
    }
  }

  Future<StoreItemBuy> buyStoreItem(int itemId) async {
    http.Response response = await http.post(apiUrl + store_buy,
        headers: authAndJsonContentHeader, body: """{"itemId":$itemId}""");
    bool result = handleError(response);
    if (result) {
      return StoreItemBuy.fromJson(json.decode(response.body));
    } else {
      // todo show error msg snackbar
      print("request failed, server is being cranky :(");
    }
  }

  //todo convert to sendBottomThree - or not
  // depending on how api sends "last updated" after ordering
  // we need to get 3 latest posts
  Future<List<PostModel>> getPostPreviewList(bool sendTopThree) async {
    http.Response response = await http.get(apiUrl + post_preview, headers: authHeader);
    bool result = handleError(response);
    if (result) {
      List<dynamic> jsonResponse = json.decode(response.body);
      List<PostModel> postPreviewList = new List<PostModel>();
      for (int i = 0; i < jsonResponse.length; i++) {
        PostModel postPreview = PostModel.fromJson(jsonResponse[i]);
        postPreviewList.add(postPreview);
      }
      if (sendTopThree) {
        // return first 3 posts
        return postPreviewList.sublist(0, min(postPreviewList.length, 3));
      } else {
        return postPreviewList;
      }
    } else {
      // todo show error msg snackbar
      print("request failed, server is being cranky :(");
    }
  }

  Future<PostModel> getPostById(int postId) async {
    http.Response response = await http.get(apiUrl + post_preview + postId.toString(), headers: authHeader);
    bool result = handleError(response);
    if (result) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      PostModel post = PostModel.fromJson(jsonResponse);
      return post;
    } else {
      // todo show error msg snackbar
      print("request failed, server is being cranky :(");
    }
  }

  Future<bool> postProfile(ProfileModel model) async {
    Map<String, dynamic> modelMap = ProfileModel.toJson(model);
    String modelJson = jsonEncode(modelMap);
    print(modelJson);
    http.Response response = await http.post(apiUrl + profile,
        headers: authAndJsonContentHeader, body: modelJson);
    bool result = handleError(response);
    if (result) {
      return true;
    } else {
      // todo show error msg snackbar
      print("request failed, server is being cranky :(");
    }
  }

  bool handleError(http.Response response) {
    //todo will 201 be returned in profile post?
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      //todo trigger oauth and regenerate token
      return false;
    }  else if (response.statusCode == 403) {
      // not approved by admin yet - show msg
      return false;
    } else if (response.statusCode == 410) {
      // disapproved by admin - show msg
      return false;
    } else {
      // some other error
      return false;
    }

  }

}