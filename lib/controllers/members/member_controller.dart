import 'package:get/get.dart';
import 'package:lakasir/api/responses/members/member_response.dart';
import 'package:lakasir/services/member_service.dart';

class MemberController extends GetxController {
  final MemberService _memberService = MemberService();
  RxList<MemberResponse> members = <MemberResponse>[].obs;
  final isFetching = false.obs;

  Future<void> fetchMembers() async {
    isFetching(true);
    final response = await _memberService.get();
    members.assignAll(response);
    isFetching(false);
  }

  @override
  void onInit() {
    super.onInit();
    fetchMembers();
  }
}
