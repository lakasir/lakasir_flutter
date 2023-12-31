import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/members/member_controller.dart';
import 'package:lakasir/widgets/dialog.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/my_bottom_bar.dart';
import 'package:lakasir/widgets/my_bottom_bar_actions.dart';
import 'package:lakasir/widgets/my_card_list.dart';
import 'package:lakasir/widgets/text_field.dart';

class MemberScreen extends StatefulWidget {
  const MemberScreen({super.key});
  @override
  State<MemberScreen> createState() => _MemberScreen();
}

class _MemberScreen extends State<MemberScreen> {
  final MemberController _memberController = Get.put(MemberController());

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Layout(
      title: 'Member',
      bottomNavigationBar: MyBottomBar(
        label: const Text('Add Member'),
        onPressed: () {
          Get.toNamed('/menu/member/add');
        },
        actions: [
          MyBottomBarActions(
            label: 'Search',
            onPressed: () {
              _memberController.showDialogSearch();
            },
            icon: const Icon(Icons.search_rounded, color: Colors.white),
          ),
        ],
      ),
      child: Obx(
        () {
          if (_memberController.isFetching.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (_memberController.members.isEmpty) {
            return const Center(
              child: Text('No Member'),
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
        Get.toNamed(
          '/menu/member/edit',
          arguments: _memberController.members[index],
        );
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
