import 'package:get/get.dart';
import 'package:lakasir/api/api_service.dart';
import 'package:lakasir/api/requests/member_request.dart';
import 'package:lakasir/api/responses/api_response.dart';
import 'package:lakasir/api/responses/members/member_response.dart';
import 'package:lakasir/utils/auth.dart';

class MemberService {
  MemberService();

  Future<RxList<MemberResponse>> get() async {
    final response =
        await ApiService(await getDomain()).fetchData('master/member');
    final apiResponse = ApiResponse.fromJsonList(response, (json) {
      return RxList<MemberResponse>.from(
          json.map((x) => MemberResponse.fromJson(x)));
    });

    return apiResponse.data!.value;
  }

  Future<void> add(MemberRequest request) async {
    await ApiService(await getDomain()).postData('master/member', request.toJson());
  }

  Future<void> delete(int id) async {
    await ApiService(await getDomain()).deleteData('master/member/$id');
  }

  Future<void> update(int id, MemberRequest request) async {
    await ApiService(await getDomain()).putData('master/member/$id', request.toJson());
  }
}
