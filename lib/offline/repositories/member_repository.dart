import 'package:get/get.dart';
import 'package:lakasir/api/requests/member_request.dart';
import 'package:lakasir/offline/models/offline_member_model.dart';
import 'package:lakasir/offline/services/app_mode_service.dart';
import 'package:lakasir/offline/services/member_service_interface.dart';
import 'package:lakasir/offline/services/offline_member_service.dart';
import 'package:lakasir/offline/services/online_member_service.dart';

class MemberRepository implements MemberServiceInterface {
  late final OfflineMemberService _offlineService = OfflineMemberService();
  late final OnlineMemberService _onlineService = OnlineMemberService();

  MemberServiceInterface get _service =>
      Get.find<AppModeService>().isOnline ? _onlineService : _offlineService;

  @override
  Future<List<OfflineMember>> getMembers({MemberRequest? request}) {
    return _service.getMembers(request: request);
  }

  @override
  Future<OfflineMember?> getMemberById(int id) {
    return _service.getMemberById(id);
  }

  @override
  Future<OfflineMember> createMember(OfflineMember member) {
    return _service.createMember(member);
  }

  @override
  Future<OfflineMember> updateMember(OfflineMember member) {
    return _service.updateMember(member);
  }

  @override
  Future<void> deleteMember(int id) {
    return _service.deleteMember(id);
  }
}