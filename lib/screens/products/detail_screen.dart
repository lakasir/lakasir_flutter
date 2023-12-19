import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lakasir/api/responses/products/product_response.dart';
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

  final Duration initialDuration = const Duration(milliseconds: 300);

  void openBottomSheet() {
    setState(() {
      isBottomSheetOpen = true;
    });
  }

  @override
  void initState() {
    super.initState();
    Timer(initialDuration, openBottomSheet);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Timer(initialDuration, openBottomSheet);
  }

  @override
  Widget build(BuildContext context) {
    final ProductResponse products =
        ModalRoute.of(context)!.settings.arguments as ProductResponse;
    final double height = MediaQuery.of(context).size.height;
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
      child: Layout(
        noAppBar: true,
        noPadding: true,
        bottomNavigationBar: MyBottomBar(
          label: const Text('Edit Product'),
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/menu/product/edit',
              arguments: products,
            );
          },
          actions: [
            MyBottomBarActions(
              label: 'Stock',
              onPressed: () {
                setState(() {
                  isBottomSheetOpen = false;
                });
                Timer(initialDuration, () {
                  Navigator.pushNamed(
                    context,
                    '/menu/product/stock',
                    arguments: products,
                  ).then((value) {
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
              label: 'Delete',
              onPressed: () {},
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
                    automaticallyImplyLeading: false, // Remove the back button
                    expandedHeight: 300.0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Hero(
                        tag: 'product-${products.id}',
                        child: ClipRRect(
                          child: Image(
                            image: NetworkImage(products.image),
                            fit: BoxFit.fitWidth,
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
                                Text(
                                  products.name,
                                  style: const TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text("Stock ${products.stock}"),
                              ],
                            ),
                            Text(
                              formatPrice(products.initialPrice),
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
                          child: const Text(
                            "Details",
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  "Initial Price",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  formatPrice(products.initialPrice),
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
                              const Expanded(
                                child: Text(
                                  "Type",
                                  style: TextStyle(fontSize: 18),
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
                              const Expanded(
                                child: Text(
                                  "Unit",
                                  style: TextStyle(fontSize: 18),
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
                              const Expanded(
                                child: Text(
                                  "Category",
                                  style: TextStyle(fontSize: 18),
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
      ),
    );
  }
}
