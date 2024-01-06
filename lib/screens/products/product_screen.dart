import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/category_controller.dart';
import 'package:lakasir/controllers/products/product_controller.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:lakasir/widgets/dialog.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/my_bottom_bar.dart';
import 'package:lakasir/widgets/my_bottom_bar_actions.dart';
import 'package:lakasir/widgets/my_card_list.dart';
import 'package:lakasir/widgets/select_input_feld.dart';
import 'package:lakasir/widgets/text_field.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});
  @override
  State<ProductScreen> createState() => _ProductScreen();
}

class _ProductScreen extends State<ProductScreen> {
  final ProductController _productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Layout(
      title: 'Product',
      bottomNavigationBar: MyBottomBar(
        label: const Text('Add Product'),
        onPressed: () {
          Get.toNamed('/menu/product/add');
        },
        actions: [
          MyBottomBarActions(
            label: 'Filter',
            onPressed: () {
              _productController.showFilterDialog();
            },
            icon: const Icon(Icons.filter_list, color: Colors.white),
          ),
          MyBottomBarActions(
            label: 'Search',
            onPressed: () {
              _productController.showSearchDialog();
            },
            icon: const Icon(Icons.search, color: Colors.white),
          ),
          MyBottomBarActions(
            label: 'Category',
            onPressed: () => {Get.toNamed('/menu/setting/category')},
            icon: const Icon(Icons.category, color: Colors.white),
          ),
        ],
      ),
      child: Obx(
        () {
          if (_productController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (_productController.products.isEmpty) {
            return Column(
              children: [
                if (_productController.isFiltered.value)
                  FilteredWidget(productController: _productController),
                if (_productController.searchByNameController.text.isNotEmpty)
                  SearchedWidget(productController: _productController),
                const Expanded(
                  child: Center(
                    child: Text('No Product'),
                  ),
                ),
              ],
            );
          }

          return Column(
            children: [
              if (_productController.isFiltered.value)
                FilteredWidget(productController: _productController),
              if (_productController.searchByNameController.text.isNotEmpty)
                SearchedWidget(productController: _productController),
              Expanded(
                child: ListView.separated(
                  itemCount: _productController.products.length + 1,
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  itemBuilder: (context, index) {
                    if (index == _productController.products.length) {
                      return SizedBox(
                        height: height * 10.0 / 100,
                      );
                    }
                    return buildMyCardList(index, context);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  MyCardList buildMyCardList(int index, BuildContext context) {
    return MyCardList(
      key: ValueKey(_productController.products[index].id),
      list: [
        Text(
          _productController.products[index].name ?? '',
          overflow: TextOverflow.ellipsis,
          maxLines: 4,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        Text(
          "stock: ${_productController.products[index].stock}",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w200,
          ),
        ),
        Text(
          _productController.buildPrice(index),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        )
      ],
      imagebox: Hero(
        tag: 'product-${_productController.products[index].id}',
        child: SizedBox(
          height: 90,
          width: 90,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: _productController.products[index].image != null
                  ? Image.network(
                      _productController.products[index].image!,
                      fit: BoxFit.cover,
                      frameBuilder: (BuildContext context, Widget child,
                          int? frame, bool wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded) {
                          return child;
                        }
                        return AnimatedOpacity(
                          opacity: frame == null ? 0 : 1,
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeOut,
                          child: child,
                        );
                      },
                    )
                  : Image.asset(
                      'assets/no-image-100.png',
                      fit: BoxFit.cover,
                    )),
        ),
      ),
      onTap: () {
        Get.toNamed(
          '/menu/product/detail',
          arguments: _productController.products[index],
        );
      },
    );
  }
}

class SearchedWidget extends StatelessWidget {
  const SearchedWidget({
    super.key,
    required ProductController productController,
  }) : _productController = productController;

  final ProductController _productController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Search Result',
          ),
          IconButton(
            onPressed: () {
              _productController.searchByNameController.clear();
              _productController.getProducts();
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}

class FilteredWidget extends StatelessWidget {
  const FilteredWidget({
    super.key,
    required ProductController productController,
  }) : _productController = productController;

  final ProductController _productController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filtered Result',
              ),
              IconButton(
                onPressed: () {
                  _productController.isFiltered(false);
                  _productController.clearSearch();
                  _productController.getProducts();
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Category: ',
              ),
              Text(
                _productController.searchByCategoryController.selectedLabel ??
                    '',
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Type: ',
              ),
              Text(
                _productController.searchByTypeController.selectedLabel ?? '',
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Unit: ',
              ),
              Text(
                _productController.searchByUnitController.text,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Name: ',
              ),
              Text(
                _productController.searchByNameController.text,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
