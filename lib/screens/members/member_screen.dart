import 'package:flutter/material.dart';
import 'package:lakasir/api/responses/members/member_response.dart';
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
  List<MemberResponse> memebers = [
    MemberResponse(
      id: 1,
      name: 'Member 1',
      address: 'Lorem ipsum dolor sit amet',
      code: '1234567890',
      createdAt: '2021-10-10',
      updatedAt: '2021-10-10',
    ),
    MemberResponse(
      id: 2,
      name: 'Member 2',
      address: 'Lorem ipsum dolor sit amet',
      code: '1234567890',
      createdAt: '2021-10-10',
      updatedAt: '2021-10-10',
    ),
    MemberResponse(
      id: 3,
      name: 'Member 3',
      address: 'Lorem ipsum dolor sit amet',
      code: '1234567890',
      createdAt: '2021-10-10',
      updatedAt: '2021-10-10',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Layout(
      title: 'Member',
      bottomNavigationBar: MyBottomBar(
        label: const Text('Add Member'),
        onPressed: () {
          Navigator.pushNamed(context, '/menu/member/add');
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
      child: ListView.separated(
        itemCount: memebers.length,
        separatorBuilder: (context, index) {
          return SizedBox(
            height: height * 2.7 / 100,
          );
        },
        itemBuilder: (context, index) {
          return MyCardList(
            key: ValueKey(memebers[index].id),
            onTap: () {
              Navigator.pushNamed(context, '/menu/member/edit',
                  arguments: memebers[index]);
            },
            list: [
              Text(
                memebers[index].name,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              Text(
                memebers[index].code,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w200,
                ),
              ),
              Text(
                memebers[index].address,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
