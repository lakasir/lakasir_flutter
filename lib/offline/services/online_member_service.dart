import 'package:isar/isar.dart';
import 'package:lakasir/api/requests/member_request.dart';
import 'package:lakasir/api/responses/members/member_response.dart';
import 'package:lakasir/models/lakasir_database.dart';
import 'package:lakasir/offline/models/offline_member_model.dart';
import 'package:lakasir/offline/services/member_service_interface.dart';
import 'package:lakasir/services/member_service.dart' as api;

class OnlineMemberService implements MemberServiceInterface {
  final _isar = LakasirDatabase.isar;
  final _apiService = api.MemberService();

  @override
  Future<List<OfflineMember>> getMembers({MemberRequest? request}) async {
    try {
      final response = await _apiService.get(request);
      await _cacheMembers(response);
    } catch (_) {
      // Silently fall back to cache on API failure
    }

    return await _getCachedMembers(request: request);
  }

  @override
  Future<OfflineMember?> getMemberById(int id) async {
    return await _isar.offlineMembers.get(id);
  }

  @override
  Future<OfflineMember> createMember(OfflineMember member) async {
    final request = MemberRequest(
      name: member.name,
      code: member.code,
      address: member.address,
      email: member.email,
    );

    try {
      await _apiService.add(request);
      member.isLocal = false;
    } catch (_) {
      member
        ..isLocal = true
        ..cachedAt = DateTime.now();
    }

    await _isar.writeTxn(() async {
      await _isar.offlineMembers.put(member);
    });

    return member;
  }

  @override
  Future<OfflineMember> updateMember(OfflineMember member) async {
    final request = MemberRequest(
      name: member.name,
      code: member.code,
      address: member.address,
      email: member.email,
    );

    try {
      await _apiService.update(member.id, request);
      member.isLocal = false;
    } catch (_) {
      member
        ..isLocal = true
        ..cachedAt = DateTime.now();
    }

    await _isar.writeTxn(() async {
      await _isar.offlineMembers.put(member);
    });

    return member;
  }

  @override
  Future<void> deleteMember(int id) async {
    try {
      await _apiService.delete(id);
    } catch (_) {
      // Ignore API failure, delete locally regardless
    }

    await _isar.writeTxn(() async {
      await _isar.offlineMembers.delete(id);
    });
  }

  Future<void> _cacheMembers(List<MemberResponse> members) async {
    final cached = members.map((m) {
      return OfflineMember()
        ..remoteId = m.id
        ..name = m.name
        ..code = m.code
        ..address = m.address
        ..email = m.email
        ..cachedAt = DateTime.now()
        ..isLocal = false;
    }).toList();

    await _isar.writeTxn(() async {
      await _isar.offlineMembers.putAll(cached);
    });
  }

  Future<List<OfflineMember>> _getCachedMembers({
    MemberRequest? request,
  }) async {
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
}