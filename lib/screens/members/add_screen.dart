import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/members/member_add_controller.dart';
import 'package:lakasir/screens/members/member_form.dart';
import 'package:lakasir/widgets/layout.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({super.key});

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final MemberAddController _memberAddController = Get.put(
    MemberAddController(),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _memberAddController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      resizeToAvoidBottomInset: true,
      title: 'global_add_item'.trParams({
        'item': 'menu_member'.tr,
      }),
      child: MemberForm(
        controller: _memberAddController,
        onPressed: _memberAddController.addMember,
      ),
    );
  }
}
