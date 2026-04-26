import 'package:isar/isar.dart';
import 'package:lakasir/api/requests/member_request.dart';
import 'package:lakasir/models/lakasir_database.dart';
import 'package:lakasir/offline/models/offline_member_model.dart';
import 'package:lakasir/offline/services/member_service_interface.dart';

class OfflineMemberService implements MemberServiceInterface {
  final _isar = LakasirDatabase.isar;

  @override
  Future<List<OfflineMember>> getMembers({MemberRequest? request}) async {
    if (request?.name != null && request!.name!.isNotEmpty) {
      return await _isar.offlineMembers
          .where()
          .filter()
          .nameContains(request.name!, caseSensitive: false)
          .findAll();
    }

    if (request?.code != null && request!.code!.isNotEmpty) {
      return await _isar.offlineMembers
          .where()
          .filter()
          .codeEqualTo(request.code!)
          .findAll();
    }

    return await _isar.offlineMembers.where().findAll();
  }

  @override
  Future<OfflineMember?> getMemberById(int id) async {
    return await _isar.offlineMembers.get(id);
  }

  @override
  Future<OfflineMember> createMember(OfflineMember member) async {
    final count = await _isar.offlineMembers.count();
    member
      ..id = -(count + 1)
      ..isLocal = true
      ..cachedAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.offlineMembers.put(member);
    });

    return member;
  }

  @override
  Future<OfflineMember> updateMember(OfflineMember member) async {
    member
      ..isLocal = true
      ..cachedAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.offlineMembers.put(member);
    });

    return member;
  }

  @override
  Future<void> deleteMember(int id) async {
    await _isar.writeTxn(() async {
      await _isar.offlineMembers.delete(id);
    });
  }
}