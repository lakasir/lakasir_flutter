import 'package:lakasir/api/api_service.dart';
import 'package:lakasir/api/requests/login_request.dart';
import 'package:lakasir/api/responses/api_response.dart';
import 'package:lakasir/api/responses/auths/login_response.dart';
import 'package:lakasir/utils/auth.dart';
import 'package:lakasir/utils/utils.dart';

class LoginService {
  Future<void> login(LoginRequest loginRequest) async {
    final response = await ApiService(await getDomain()).postData(
      'auth/login',
      loginRequest.toJson(),
    );

    ApiResponse<LoginResponse> apiResponse = ApiResponse.fromJson(
      response,
      (json) => LoginResponse.fromJson(json),
    );
    debug(apiResponse);

    storeToken(apiResponse.data!.value.token);
  }

  void setFcmToken(String fcmToken) async {
    ApiService(await getDomain()).postData('register-fcm-token', {
      'fcm_token': fcmToken,
    });
  }
}
