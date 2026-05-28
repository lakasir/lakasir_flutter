import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/auths/auth_controller.dart';
import 'package:lakasir/controllers/profiles/user_management_controller.dart';
import 'package:lakasir/utils/auth.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/widgets/layout.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final UserManagementController _controller =
      Get.put(UserManagementController());
  final AuthController _authController = Get.put(AuthController());

  void _showDeleteConfirmation(
      BuildContext context, int userId, String userName, bool isOwner) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(
              isOwner ? Icons.warning_amber_rounded : Icons.delete_outline,
              color: isOwner ? Colors.red : Colors.black87,
            ),
            const SizedBox(width: 10),
            Text(isOwner ? 'global_delete_owner_title'.tr : 'global_sure?'.tr),
          ],
        ),
        content: Text(
          isOwner
              ? 'global_delete_owner_content'.tr
              : 'global_sure_content'.trParams({'item': userName}),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('global_cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _controller.deleteUser(userId);
            },
            style: isOwner
                ? TextButton.styleFrom(foregroundColor: Colors.white)
                : null,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: isOwner
                  ? BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    )
                  : null,
              child: Text(
                isOwner
                    ? 'global_delete_server'.tr
                    : 'global_delete'.tr,
                style: TextStyle(
                  color: isOwner ? Colors.white : Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: 'User Management',
      child: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_controller.users.isEmpty) {
          return Center(
            child: Text('global_no_item'.trParams({'item': 'users'})),
          );
        }

        return ListView.builder(
          itemCount: _controller.users.length,
          itemBuilder: (context, index) {
            final user = _controller.users[index];
            final isOwner = user.isOwner ?? false;

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: isOwner ? Colors.red.shade100 : primary,
                  child: Icon(
                    isOwner ? Icons.admin_panel_settings : Icons.person,
                    color: isOwner ? Colors.red : Colors.white,
                  ),
                ),
                title: Row(
                  children: [
                    Flexible(
                      child: Text(
                        user.name ?? '-',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (isOwner)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Text(
                          'Owner',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                subtitle: Text(user.email ?? '-'),
                trailing: can(
                  _authController.permissions,
                  ability: 'delete user',
                )
                    ? IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: Colors.red),
                        onPressed: _controller.isDeleting.value
                            ? null
                            : () => _showDeleteConfirmation(
                                  context,
                                  user.id!,
                                  user.name ?? 'User',
                                  isOwner,
                                ),
                      )
                    : null,
              ),
            );
          },
        );
      }),
    );
  }
}
