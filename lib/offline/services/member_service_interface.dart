import 'package:lakasir/api/requests/member_request.dart';
import 'package:lakasir/offline/models/offline_member_model.dart';

abstract class MemberServiceInterface {
  Future<List<OfflineMember>> getMembers({MemberRequest? request});
  Future<OfflineMember?> getMemberById(int id);
  Future<OfflineMember> createMember(OfflineMember member);
  Future<OfflineMember> updateMember(OfflineMember member);
  Future<void> deleteMember(int id);
}