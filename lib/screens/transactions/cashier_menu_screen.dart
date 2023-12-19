import 'package:flutter/material.dart';
import 'package:lakasir/api/responses/categories/category_response.dart';
import 'package:lakasir/api/responses/products/product_response.dart';
import 'package:lakasir/api/responses/products/stocks/stock_response.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/my_bottom_bar.dart';
import 'package:lakasir/widgets/my_bottom_bar_actions.dart';
import 'package:lakasir/widgets/my_card_list.dart';
import 'package:lakasir/widgets/text_field.dart';

class CashierMenuScreen extends StatefulWidget {
  const CashierMenuScreen({super.key});

  @override
  State<CashierMenuScreen> createState() => _CashierMenuScreenState();
}

class _CashierMenuScreenState extends State<CashierMenuScreen> {
  List<ProductResponse> products = [
    ProductResponse(
      id: 1,
      name: 'Cashier',
      description: 'Cashier',
      type: "Product",
      unit: "pcs",
      image:
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
      initialPrice: 5200,
      sellingPrice: 5500,
      stock: 100,
      categoryId: 1,
      createdAt: '2021-10-10',
      updatedAt: '2021-10-10',
      category: CategoryResponse(
        id: 1,
        name: 'Food',
        description: 'Food',
        createdAt: '2021-10-10',
        updatedAt: '2021-10-10',
      ),
      stocks: [
        StockResponse(
          id: 1,
          productId: 1,
          stock: 100,
          type: 'add',
          createdAt: '2021-10-10',
          updatedAt: '2021-10-10',
        ),
        StockResponse(
          id: 2,
          productId: 1,
          stock: 100,
          type: 'reduce',
          createdAt: '2021-10-10',
          updatedAt: '2021-10-10',
        ),
      ],
    ),
    ProductResponse(
      id: 2,
      name: 'Cashier',
      description: 'Cashier',
      type: "Product",
      unit: "pcs",
      image:
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
      initialPrice: 5200,
      sellingPrice: 5500,
      stock: 100,
      categoryId: 1,
      createdAt: '2021-10-10',
      updatedAt: '2021-10-10',
      category: CategoryResponse(
        id: 1,
        name: 'Food',
        description: 'Food',
        createdAt: '2021-10-10',
        updatedAt: '2021-10-10',
      ),
      stocks: [
        StockResponse(
          id: 1,
          productId: 2,
          stock: 100,
          type: 'add',
          createdAt: '2021-10-10',
          updatedAt: '2021-10-10',
        ),
        StockResponse(
          id: 2,
          productId: 2,
          stock: 100,
          type: 'reduce',
          createdAt: '2021-10-10',
          updatedAt: '2021-10-10',
        ),
      ],
    ),
    ProductResponse(
      id: 3,
      name: 'Cashier',
      description: 'Cashier',
      type: "Service",
      unit: "KG",
      image:
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
      initialPrice: 5200,
      sellingPrice: 5500,
      stock: 100,
      categoryId: 1,
      createdAt: '2021-10-10',
      updatedAt: '2021-10-10',
      category: CategoryResponse(
        id: 1,
        name: 'Food',
        description: 'Food',
        createdAt: '2021-10-10',
        updatedAt: '2021-10-10',
      ),
      stocks: [
        StockResponse(
          id: 1,
          productId: 3,
          stock: 100,
          type: 'add',
          createdAt: '2021-10-10',
          updatedAt: '2021-10-10',
        ),
        StockResponse(
          id: 2,
          productId: 3,
          stock: 100,
          type: 'reduce',
          createdAt: '2021-10-10',
          updatedAt: '2021-10-10',
        ),
      ],
    ),
  ];
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: 'Cashier',
      bottomNavigationBar: MyBottomBar(
        label: const Row(
          children: [
            Icon(Icons.shopping_cart_rounded, color: Colors.white),
            Text(
              ' 0',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/menu/transaction/cashier/cart');
        },
        actions: [
          MyBottomBarActions(
            label: 'Add Cart Session',
            onPressed: () {},
            icon: const Icon(Icons.add_rounded, color: Colors.white),
          ),
        ],
      ),
      child: ListView(
        children: [
          MyTextField(
            key: const ValueKey('search'),
            controller: textEditingController,
            onSubmitted: (value) {},
            rightIcon: InkWell(
              onTap: () {},
              child: const Icon(
                Icons.search_rounded,
                color: primary,
              ),
            ),
          ),
          for (var product in products) buildMyCardList(product),
        ],
      ),
    );
  }

  Widget buildMyCardList(ProductResponse product) {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 2.7 / 100),
        MyCardList(
          key: ValueKey(product.id),
          list: [
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(
              width: 220,
              child: Text(
                product.description,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ),
            SizedBox(
              width: 220,
              child: Text(
                product.initialPrice.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
          imagebox: SizedBox(
            height: 90,
            width: 90,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image(
                width: 200,
                height: 150,
                image: NetworkImage(product.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
        )
      ],
    );
  }
}
