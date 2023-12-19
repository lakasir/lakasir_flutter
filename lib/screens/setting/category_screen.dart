import 'package:flutter/material.dart';
import 'package:lakasir/api/responses/categories/category_response.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/my_bottom_bar.dart';
import 'package:lakasir/widgets/my_bottom_bar_actions.dart';
import 'package:lakasir/widgets/my_card_list.dart';
import 'package:lakasir/widgets/text_field.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});
  @override
  State<CategoryScreen> createState() => _CategoryScreen();
}

class _CategoryScreen extends State<CategoryScreen> {
  bool showAddCategory = false;
  final _categoryNameController = TextEditingController();
  List<CategoryResponse> categories = [
    CategoryResponse(
      id: 1,
      name: 'Category 1',
      description: 'Category 1',
      createdAt: '2021-10-10',
      updatedAt: '2021-10-10',
    ),
    CategoryResponse(
      id: 2,
      name: 'Category 2',
      description: 'Category 2',
      createdAt: '2021-10-10',
      updatedAt: '2021-10-10',
    ),
    CategoryResponse(
      id: 3,
      name: 'Category 3',
      description: 'Category 3',
      createdAt: '2021-10-10',
      updatedAt: '2021-10-10',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Layout(
      title: 'Category',
      bottomNavigationBar: MyBottomBar(
        label: const Text('Add Category'),
        onPressed: () {
          setState(() {
            showAddCategory = !showAddCategory;
          });
        },
        actions: [
          MyBottomBarActions(
            label: 'Delete',
            onPressed: () {},
            icon: const Icon(Icons.delete_rounded, color: Colors.white),
          ),
        ],
      ),
      child: ListView.separated(
        itemCount: categories.length + 1,
        separatorBuilder: (context, index) {
          return SizedBox(
            height: height * 2.7 / 100,
          );
        },
        itemBuilder: (context, index) {
          if (index == categories.length) {
            return Visibility(
              visible: showAddCategory,
              child: MyTextField(
                label: 'Category Name',
                mandatory: true,
                controller: _categoryNameController,
              ),
            );
          }
          return MyCardList(
            key: ValueKey(categories[index].id),
            list: [
              Text(
                categories[index].name,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
