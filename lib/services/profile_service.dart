import 'package:lakasir/api/api_service.dart';
import 'package:lakasir/api/requests/profile_request.dart';
import 'package:lakasir/api/responses/api_response.dart';
import 'package:lakasir/api/responses/auths/profile_response.dart';
import 'package:lakasir/utils/auth.dart';

class ProfileService {
  Future<ProfileResponse> get() async {
    final response = await ApiService(await getDomain()).fetchData('auth/me');
    ApiResponse<ProfileResponse> profileResponse = ApiResponse.fromJson(
      response,
      (json) => ProfileResponse.fromJson(json),
    );

    return profileResponse.data!.value;
  }

  Future<void> update(ProfileRequest profileRequest) async {
    await ApiService(await getDomain()).putData(
      'auth/me',
      profileRequest.toJson(),
    );
  }

  Future<List<ProfileResponse>> getUsers() async {
    final response =
        await ApiService(await getDomain()).fetchData('auth/users');
    final apiResponse = ApiResponse.fromJsonList(response, (json) {
      return json.map((x) => ProfileResponse.fromJson(x)).toList();
    });

    return apiResponse.data!.value;
  }

  Future<void> deleteUser(int id) async {
    await ApiService(await getDomain()).deleteData('auth/users/$id');
  }
}
