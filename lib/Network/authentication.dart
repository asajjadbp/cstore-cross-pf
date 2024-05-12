import 'package:cstore/Model/request_model.dart/login_request_model.dart';
import 'package:cstore/Model/response_model.dart/login_response_model.dart';
import 'package:cstore/Network/store_user_cred.dart';
import 'package:cstore/network/api.dart';

import 'response_handler.dart';

class Authentication {
  final ResponseHandler _handler = ResponseHandler();

  Future<UserResponseModel> loginUser(UserRequestModel userResponseData) async {
    const url = Api.LOGIN_API;

    final response =
        await _handler.post(Uri.parse(url), userResponseData.toJson(), "");

    UserResponseModel loginResponseData = UserResponseModel.fromJson(response);
    if (loginResponseData.status) {
      StoreUserData.storeUserCred(loginResponseData);
      // print(loginResponseData.data.username);
      // print(loginResponseData.data.tokenId);
    }
    return loginResponseData;
  }
}
