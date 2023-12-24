import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/members/member_controller.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/my_bottom_bar.dart';
import 'package:lakasir/widgets/my_bottom_bar_actions.dart';
import 'package:lakasir/widgets/my_card_list.dart';

class MemberScreen extends StatefulWidget {
  const MemberScreen({super.key});
  @override
  State<MemberScreen> createState() => _MemberScreen();
}

class _MemberScreen extends State<MemberScreen> {
  MemberController memberController = Get.put(MemberController());

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
            onPressed: () {},
            icon: const Icon(Icons.search_rounded, color: Colors.white),
          ),
          MyBottomBarActions(
            label: 'Delete',
            onPressed: () {},
            icon: const Icon(Icons.delete_rounded, color: Colors.white),
          ),
        ],
      ),
      child: Obx(
        () {
          if (memberController.isFetching.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (memberController.members.isEmpty) {
            return const Center(
              child: Text('No Member'),
            );
          }

          return ListView.separated(
            itemCount: memberController.members.length,
            separatorBuilder: (context, index) {
              return SizedBox(
                height: height * 2 / 100,
              );
            },
            itemBuilder: (context, index) {
              return MyCardList(
                key: ValueKey(memberController.members[index].id),
                onTap: () {
                  Get.toNamed(
                    '/menu/member/edit',
                    arguments: memberController.members[index],
                  );
                },
                list: [
                  Text(
                    memberController.members[index].name,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  if (memberController.members[index].email != null)
                    Text(
                      memberController.members[index].email ?? "-",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  if (memberController.members[index].code != null)
                    Text(
                      memberController.members[index].code ?? "-",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  if (memberController.members[index].address != null)
                    Text(
                      memberController.members[index].address ?? "-",
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
