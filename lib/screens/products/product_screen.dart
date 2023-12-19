import 'package:flutter/material.dart';
import 'package:lakasir/api/responses/categories/category_response.dart';
import 'package:lakasir/api/responses/products/product_response.dart';
import 'package:lakasir/api/responses/products/stocks/stock_response.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/my_bottom_bar.dart';
import 'package:lakasir/widgets/my_bottom_bar_actions.dart';
import 'package:lakasir/widgets/my_card_list.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});
  @override
  State<ProductScreen> createState() => _ProductScreen();
}

class _ProductScreen extends State<ProductScreen> {
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

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Layout(
      title: 'Product',
      bottomNavigationBar: MyBottomBar(
        label: const Text('Add Product'),
        onPressed: () {
          Navigator.pushNamed(context, '/menu/product/add');
        },
        actions: [
          MyBottomBarActions(
            label: 'Search',
            onPressed: () {},
            icon: const Icon(Icons.search, color: Colors.white),
          ),
          MyBottomBarActions(
            label: 'Catgory',
            onPressed: () {},
            icon: const Icon(Icons.category, color: Colors.white),
          ),
          MyBottomBarActions(
            label: 'Stock',
            onPressed: () {},
            icon: const Icon(Icons.inventory, color: Colors.white),
          ),
          MyBottomBarActions(
            label: 'Delete',
            onPressed: () {},
            icon: const Icon(Icons.delete_rounded, color: Colors.white),
          ),
        ],
      ),
      child: ListView.separated(
        itemCount: products.length,
        separatorBuilder: (context, index) {
          return SizedBox(
            height: height * 2.7 / 100,
          );
        },
        itemBuilder: (context, index) {
          return MyCardList(
            key: ValueKey(products[index].id),
            list: [
              Text(
                products[index].name,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(
                width: 220,
                child: Text(
                  products[index].description,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
              SizedBox(
                width: 220,
                child: Text(
                  products[index].initialPrice.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
            imagebox: Hero(
              tag: 'product-${products[index].id}',
              child: SizedBox(
                height: 90,
                width: 90,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image(
                    width: 200,
                    height: 150,
                    image: NetworkImage(products[index].image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/menu/product/detail',
                arguments: products[index],
              );
            },
          );
        },
      ),
    );
  }
}
