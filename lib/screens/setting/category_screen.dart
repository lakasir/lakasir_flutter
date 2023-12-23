import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/category_controller.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/my_bottom_bar.dart';
import 'package:lakasir/widgets/my_card_list.dart';
import 'package:lakasir/widgets/text_field.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});
  @override
  State<CategoryScreen> createState() => _CategoryScreen();
}

class _CategoryScreen extends State<CategoryScreen> {
  final CategoryController categoryController = Get.put(CategoryController());
  final ScrollController scrollController = ScrollController();

  void addCategory() {
    categoryController.addCategory();
    scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Layout(
      title: 'Category',
      bottomNavigationBar: MyBottomBar(
        label: Obx(() => Text(categoryController.labelButton())),
        onPressed: () {
          categoryController.actionButton();
          scrollController.animateTo(
            0.0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        },
      ),
      child: Obx(
        () => ListView.separated(
          controller: scrollController,
          itemCount: categoryController.categories.length + 1,
          separatorBuilder: (context, index) {
            return SizedBox(
              height: height * 2 / 100,
            );
          },
          itemBuilder: (context, index) {
            if (index == 0) {
              return Obx(
                () => Visibility(
                  visible: categoryController.showAddCategory(),
                  child: MyTextField(
                    label: 'Category Name',
                    autofocus: true,
                    mandatory: true,
                    controller: categoryController.categoryNameController,
                    errorText: categoryController.errors().name,
                    onSubmitted: (value) => addCategory(),
                    onTapOutside: (value) => addCategory(),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        categoryController.labelButton("Save");
                      } else {
                        categoryController.labelButton("Cancel");
                      }
                    },
                  ),
                ),
              );
            }
            return MyCardList(
              key: ValueKey(categoryController.categories[index - 1].id),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                          "Delete ${categoryController.categories[index - 1].name}"),
                      content: const Text(
                          "Are you sure want to delete this category?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            categoryController.deleteCategory(
                              categoryController.categories[index - 1].id,
                            );
                            Get.back();
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    );
                  },
                );
              },
              list: [
                Text(
                  categoryController.categories[index - 1].name,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
