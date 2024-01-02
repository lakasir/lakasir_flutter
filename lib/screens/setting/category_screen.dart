import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/category_controller.dart';
import 'package:lakasir/widgets/dialog.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/my_bottom_bar.dart';
import 'package:lakasir/widgets/text_field.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});
  @override
  State<CategoryScreen> createState() => _CategoryScreen();
}

class _CategoryScreen extends State<CategoryScreen> {
  final CategoryController categoryController = Get.put(CategoryController());
  final ScrollController scrollController = ScrollController();

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
    return Layout(
      title: 'Category',
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: MyBottomBar(
        label: const Text("Add Category"),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              categoryController.categoryNameController.clear();
              return MyDialog(
                content: Obx(
                  () => Form(
                    key: categoryController.formKey,
                    child: MyTextField(
                        textInputAction: TextInputAction.done,
                        label: "Category Name",
                        autofocus: true,
                        mandatory: true,
                        controller: categoryController.categoryNameController,
                        errorText: categoryController.errors().name,
                        onSubmitted: (value) =>
                            categoryController.addCategory(),
                        rightIcon: IconButton(
                          onPressed: () {
                            categoryController.addCategory();
                          },
                          icon: const Icon(Icons.save),
                        )),
                  ),
                ),
              );
            },
          );
        },
      ),
      child: Obx(
        () => ListView(
          children: [
            for (final category in categoryController.categories)
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      categoryController.categoryNameController.text =
                          category.name;
                      return MyDialog(
                        content: Obx(
                          () => Form(
                            key: categoryController.formKey,
                            child: MyTextField(
                              textInputAction: TextInputAction.done,
                              label: "Category Name",
                              autofocus: true,
                              mandatory: true,
                              controller:
                                  categoryController.categoryNameController,
                              errorText: categoryController.errors().name,
                              onSubmitted: (value) => categoryController
                                  .updateCategory(category.id),
                              rightIcon: IconButton(
                                onPressed: () {
                                  categoryController
                                      .updateCategory(category.id);
                                },
                                icon: const Icon(Icons.save),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      category.name,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Delete Category"),
                              content: const Text(
                                  "Are you sure want to delete this category?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    categoryController
                                        .deleteCategory(category.id);
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Delete"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
