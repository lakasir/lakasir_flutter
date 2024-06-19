import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/auths/auth_controller.dart';
import 'package:lakasir/controllers/members/member_controller.dart';
import 'package:lakasir/utils/auth.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/my_bottom_bar.dart';
import 'package:lakasir/widgets/my_card_list.dart';

class MemberScreen extends StatefulWidget {
  const MemberScreen({super.key});

  @override
  State<MemberScreen> createState() => _MemberScreen();
}

class _MemberScreen extends State<MemberScreen> {
  final MemberController _memberController = Get.put(MemberController());
  final AuthController _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Layout(
      title: 'menu_member'.tr,
      bottomNavigationBar: MyBottomBar(
        hideBlockButton: !can(_authController.permissions, 'create member'),
        icon: Icons.add,
        label: Text('global_add_item'.trParams({
          'item': 'menu_member'.tr,
        })),
        onPressed: () {
          Get.toNamed('/menu/member/add');
        },
      ),
      child: Obx(
        () {
          if (_memberController.isFetching.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (_memberController.members.isEmpty) {
            return Center(
              child: Text('global_no_item'.trParams({
                'item': 'menu_member'.tr,
              })),
            );
          }

          return Column(
            children: [
              if (_memberController.searchByNameController.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Search Result',
                      ),
                      IconButton(
                        onPressed: () {
                          _memberController.searchByNameController.clear();
                          _memberController.fetchMembers();
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: ListView.separated(
                  itemCount: _memberController.members.length + 1,
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: height * 2 / 100,
                    );
                  },
                  itemBuilder: (context, index) {
                    if (index == _memberController.members.length) {
                      return SizedBox(
                        height: height * 10 / 100,
                      );
                    }
                    return buildMyCardList(index);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  MyCardList buildMyCardList(int index) {
    return MyCardList(
      key: ValueKey(_memberController.members[index].id),
      onTap: () {
        if (can(_authController.permissions, 'update member')) {
          Get.toNamed(
            '/menu/member/edit',
            arguments: _memberController.members[index],
          );
        }
      },
      list: [
        Text(
          _memberController.members[index].name,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        if (_memberController.members[index].email != null)
          Text(
            _memberController.members[index].email ?? "-",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w200,
            ),
          ),
        if (_memberController.members[index].code != null)
          Text(
            _memberController.members[index].code ?? "-",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w200,
            ),
          ),
        if (_memberController.members[index].address != null)
          Text(
            _memberController.members[index].address ?? "-",
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
      ],
    );
  }
}
