import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/members/member_update_controller.dart';
import 'package:lakasir/screens/members/member_form.dart';
import 'package:lakasir/widgets/layout.dart';

class EditMemberScreen extends StatefulWidget {
  const EditMemberScreen({super.key});

  @override
  State<EditMemberScreen> createState() => _EditMemberScreenState();
}

class _EditMemberScreenState extends State<EditMemberScreen> {
  final MemberUpdateController _memberUpdateController = Get.put(
    MemberUpdateController(),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _memberUpdateController.setData();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: 'Edit Member',
      resizeToAvoidBottomInset: true,
      child: MemberForm(
        controller: _memberUpdateController,
        onPressed: _memberUpdateController.updateMember,
        isUpdate: true,
      ),
    );
  }
}
