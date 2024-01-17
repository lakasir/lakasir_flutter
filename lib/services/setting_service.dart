import 'package:lakasir/api/api_service.dart';
import 'package:lakasir/api/responses/api_response.dart';
import 'package:lakasir/api/responses/setting_response.dart';
import 'package:lakasir/utils/auth.dart';

class SettingService {
  Future<SettingResponse> get(String key) async {
    final response = await ApiService(await getDomain()).fetchData('setting/$key');
    ApiResponse<SettingResponse> profileResponse = ApiResponse.fromJson(
      response,
      (json) => SettingResponse.fromJson(json),
    );
    
    return profileResponse.data!.value;
  }

  Future<Setting> getAll() async {
    final response = await ApiService(await getDomain()).fetchData('setting/all');
    ApiResponse<Setting> profileResponse = ApiResponse.fromJson(
      response,
      (json) => Setting.fromJson(json),
    );
    
    return profileResponse.data!.value;
  }

  Future<void> set(SettingRequest settingRequest) async {
    await ApiService(await getDomain()).postData(
      'setting',
      settingRequest.toJson(),
    );
  }
}

class SettingRequest {
  final String key;
  final dynamic value;

  SettingRequest({
    required this.key,
    required this.value,
  });

  Map<String, dynamic> toJson() => {
    'key': key,
    'value': value,
  };
}
