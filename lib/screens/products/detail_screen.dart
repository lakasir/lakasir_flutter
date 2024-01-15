import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/api/responses/products/product_response.dart';
import 'package:lakasir/controllers/products/product_detail_controller.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/my_bottom_bar.dart';
import 'package:lakasir/widgets/my_bottom_bar_actions.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreen();
}

class _DetailScreen extends State<DetailScreen> {
  bool isBottomSheetOpen = false;
  final _productDetailController = Get.put(ProductDetailController());

  final Duration initialDuration = const Duration(milliseconds: 300);

  void openBottomSheet() {
    setState(() {
      isBottomSheetOpen = true;
    });
  }

  @override
  void initState() {
    final product = Get.arguments as ProductResponse;
    _productDetailController.get(product.id);
    Timer(initialDuration, openBottomSheet);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Timer(initialDuration, openBottomSheet);
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    double percentage = 0.7;
    double containerHeight = height * percentage;

    return WillPopScope(
      onWillPop: () {
        setState(() {
          isBottomSheetOpen = false;
        });
        Timer(initialDuration, () {
          Navigator.pop(context);
        });
        return Future.value(false);
      },
      child: Obx(
        () {
          final products = _productDetailController.product.value;
          return Layout(
            baseHeight: double.infinity,
            noAppBar: true,
            noPadding: true,
            bottomNavigationBar: MyBottomBar(
              label: Text('product_edit'.tr),
              onPressed: () {
                Get.toNamed('/menu/product/edit', arguments: products);
              },
              actions: [
                MyBottomBarActions(
                  label: 'field_stock'.tr,
                  onPressed: () {
                    setState(() {
                      isBottomSheetOpen = false;
                    });
                    Timer(initialDuration, () {
                      Get.toNamed(
                        '/menu/product/stock',
                        arguments: products,
                      )!
                          .then((value) {
                        Timer(initialDuration, () {
                          setState(() {
                            isBottomSheetOpen = true;
                          });
                        });
                      });
                    });
                  },
                  icon: const Icon(Icons.inventory, color: Colors.white),
                ),
                MyBottomBarActions(
                  label: 'global_delete'.tr,
                  onPressed: () {
                    _productDetailController.showDeleteDialog(
                      products.id,
                    );
                  },
                  icon: const Icon(Icons.delete_rounded, color: Colors.white),
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        automaticallyImplyLeading:
                            false, // Remove the back button
                        expandedHeight: 300.0,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Hero(
                            tag: 'product-${products.id}',
                            child: ClipRRect(
                              child: products.image != null
                                  ? Image.network(
                                      products.image!,
                                      fit: BoxFit.cover,
                                    )
                                  : const Image(
                                      image:
                                          AssetImage('assets/no-image-100.png'),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  height: isBottomSheetOpen ? containerHeight : 0,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.zero,
                      bottomRight: Radius.zero,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 2),
                        blurRadius: 19,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onVerticalDragUpdate: (details) {},
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 14, right: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                width: 100,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: whiteGrey,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin: const EdgeInsets.all(12),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: width * 0.65,
                                      child: Text(
                                        products.name,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 4,
                                        style: const TextStyle(
                                          fontSize: 23,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                        "${"field_stock".tr}: ${products.stock}"),
                                  ],
                                ),
                                Text(
                                  formatPrice(products.sellingPrice ?? 0),
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 33,
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Text(
                                "global_detail".tr,
                                style: const TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "field_initial_price".tr,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      formatPrice(products.initialPrice ?? 0),
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "field_type".tr,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      products.type,
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "field_unit".tr,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      products.unit,
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "field_category".tr,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      products.category!.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
