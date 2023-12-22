import 'package:flutter/material.dart';
import 'package:lakasir/api/responses/carts/cart_response.dart';
import 'package:lakasir/api/responses/categories/category_response.dart';
import 'package:lakasir/api/responses/products/product_response.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/my_bottom_bar.dart';
import 'package:lakasir/widgets/my_bottom_bar_actions.dart';
import 'package:lakasir/widgets/my_card_list.dart';
import 'package:lakasir/widgets/select_input_feld.dart';

class CashierCartMenuScreen extends StatefulWidget {
  const CashierCartMenuScreen({super.key});

  @override
  State<CashierCartMenuScreen> createState() => _CashierCartMenuScreenState();
}

class _CashierCartMenuScreenState extends State<CashierCartMenuScreen> {
  List<CartResponse> cartlist = [
    CartResponse(
      id: 1,
      productId: 1,
      quantity: 5,
      product: ProductResponse(
        id: 1,
        name: 'Kopi',
        description: 'Kopi Mantap',
        initialPrice: 10000,
        sellingPrice: 10000,
        categoryId: 1,
        image:
            'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
        stock: 10,
        unit: 'pcs',
        type: 'Product',
        category: CategoryResponse(
          id: 1,
          name: 'Minuman',
          updatedAt: DateTime.now().toString(),
          createdAt: DateTime.now().toString(),
        ),
        updatedAt: DateTime.now().toString(),
        createdAt: DateTime.now().toString(),
      ),
      updatedAt: DateTime.now().toString(),
      createdAt: DateTime.now().toString(),
    ),
    CartResponse(
      id: 2,
      productId: 1,
      quantity: 5,
      product: ProductResponse(
        id: 1,
        name: 'Kopi',
        description: 'Kopi Mantap',
        initialPrice: 10000,
        sellingPrice: 10000,
        categoryId: 1,
        image:
            'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
        stock: 10,
        unit: 'pcs',
        type: 'Product',
        category: CategoryResponse(
          id: 1,
          name: 'Minuman',
          updatedAt: DateTime.now().toString(),
          createdAt: DateTime.now().toString(),
        ),
        updatedAt: DateTime.now().toString(),
        createdAt: DateTime.now().toString(),
      ),
      updatedAt: DateTime.now().toString(),
      createdAt: DateTime.now().toString(),
    ),
  ];

  SelectInputWidgetController selectInputWidgetController =
      SelectInputWidgetController();

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: 'Cart List',
      bottomNavigationBar: MyBottomBar(
        label: const Text("Pay"),
        onPressed: () {
          Navigator.pushNamed(context, '/menu/transaction/cashier/payment');
        },
        actions: [
          MyBottomBarActions(
            onPressed: () {},
            label: 'Clear Cart',
            icon: const Icon(Icons.delete_rounded, color: Colors.white),
          ),
        ],
      ),
      child: ListView(
        children: [
          for (var item in cartlist) buildMyCardList(item),
          Container(
            width: double.infinity,
            height: 2,
            decoration: const BoxDecoration(
              color: grey,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            margin: const EdgeInsets.only(top: 15, bottom: 15),
          ),
          const Text(
            "Rp. 100.000",
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            "Member: Member 1",
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMyCardList(CartResponse item) {
    String sellingFormattedPrice = formatPrice(item.product.sellingPrice);
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 2.7 / 100),
        MyCardList(
          key: ValueKey(item.id),
          list: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 88 / 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.product.name,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        child: Text(
                          sellingFormattedPrice,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: whiteGrey,
                        ),
                        height: 30,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            MaterialButton(
                              minWidth: 50,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                              padding: const EdgeInsets.all(0),
                              onPressed: () {},
                              child: const Icon(Icons.remove_rounded, size: 15),
                            ),
                            SizedBox(
                              width: 20,
                              child: Center(
                                child: Text(
                                  item.quantity.toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            MaterialButton(
                              minWidth: 50,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              padding: const EdgeInsets.all(0),
                              onPressed: () {},
                              child: const Icon(Icons.add_rounded, size: 15),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
