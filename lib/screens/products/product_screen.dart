import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lakasir/controllers/auths/auth_controller.dart';
import 'package:lakasir/controllers/products/product_controller.dart';
import 'package:lakasir/controllers/setting_controller.dart';
import 'package:lakasir/utils/auth.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/widgets/build_list_image.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/my_bottom_bar.dart';
import 'package:lakasir/widgets/my_bottom_bar_actions.dart';
import 'package:lakasir/widgets/my_card_list.dart';
import 'package:lakasir/api/responses/products/product_response.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductController _productController = Get.put(ProductController());
  final SettingController _settingController = Get.put(SettingController());
  final AuthController _authController = Get.put(AuthController());
  final PagingController<int, ProductResponse> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) async {
      try {
        final response = await _productController.fetchPage(pageKey);
        final items = response.data ?? [];
        final isLastPage = response.links?.next == null;
        if (isLastPage) {
          _pagingController.appendLastPage(items);
        } else {
          _pagingController.appendPage(items, pageKey + 1);
        }
      } catch (error) {
        _pagingController.error = error;
      }
    });

    ever(_productController.refreshTrigger, (_) {
      _pagingController.refresh();
    });

    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  void _clearSearchAndRefresh() {
    _productController.clearSearch();
    _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Layout(
      title: 'menu_product'.tr,
      bottomNavigationBar: MyBottomBar(
        label: Text('product_add'.tr),
        icon: Icons.add,
        hideBlockButton: !can(
          _authController.permissions,
          ability: 'create product',
        ),
        onPressed: () {
          Get.toNamed('/menu/product/add');
        },
        actions: [
          MyBottomBarActions(
            badge: 'global_filter'.tr,
            onPressed: () {
              _productController.showFilterDialog(
                onRefresh: () => _pagingController.refresh(),
              );
            },
            icon: const Icon(Icons.filter_list, color: Colors.white),
          ),
          MyBottomBarActions(
            badge: 'global_search'.tr,
            onPressed: () {
              _productController.showSearchDialog(
                onRefresh: () => _pagingController.refresh(),
              );
            },
            icon: const Icon(Icons.search, color: Colors.white),
          ),
          if (can(
            _authController.permissions,
            ability: 'read category',
          ))
            MyBottomBarActions(
              badge: 'setting_category'.tr,
              onPressed: () => {Get.toNamed('/menu/setting/category')},
              icon: const Icon(Icons.category, color: Colors.white),
            ),
        ],
      ),
      child: Column(
        children: [
          Obx(() {
            if (_productController.isFiltered.value) {
              return FilteredWidget(
                productController: _productController,
                onClear: _clearSearchAndRefresh,
              );
            }
            if (_productController.searchByNameController.text.isNotEmpty) {
              return SearchedWidget(
                onClear: _clearSearchAndRefresh,
              );
            }
            return const SizedBox.shrink();
          }),
          Expanded(
            child: PagedListView<int, ProductResponse>(
              pagingController: _pagingController,
              builderDelegate:
                  PagedChildBuilderDelegate<ProductResponse>(
                noItemsFoundIndicatorBuilder: (_) => Center(
                  child: Text('global_no_item'.trParams(
                    {'item': 'menu_product'.tr},
                  )),
                ),
                firstPageProgressIndicatorBuilder: (_) => const Center(
                  child: CircularProgressIndicator(),
                ),
                newPageProgressIndicatorBuilder: (_) => const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
                itemBuilder: (context, product, index) {
                  if (index == _pagingController.itemList!.length - 1) {
                    return Column(
                      children: [
                        buildMyCardList(product, context),
                        SizedBox(height: height * 10.0 / 100),
                      ],
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: buildMyCardList(product, context),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  MyCardList buildMyCardList(ProductResponse product, BuildContext context) {
    return MyCardList(
      key: ValueKey(product.id),
      list: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                product.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            if (!product.isNonStock)
              if (product.stock! <=
                  _settingController.setting.value.minimumStock!)
                const Icon(Icons.warning, color: error),
          ],
        ),
        if (_authController.feature(feature: 'product-stock'))
          if (product.isNonStock)
            Text(
              "field_is_non_stock".tr,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w200,
                color: error,
              ),
            ),
        if (_authController.feature(feature: 'product-stock'))
          if (!product.isNonStock)
            Text(
              "stock: ${product.stock}",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w200,
              ),
            ),
        Text(
          _productController.buildPrice(product),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
      imagebox: Hero(
        tag: 'product-${product.id}',
        child: BuildListImage(url: product.image),
      ),
      onTap: () {
        Get.toNamed('/menu/product/detail', arguments: product);
      },
    );
  }
}

class SearchedWidget extends StatelessWidget {
  const SearchedWidget({
    super.key,
    required this.onClear,
  });

  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Search Result'),
          IconButton(
            onPressed: onClear,
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
    required this.onClear,
  }) : _productController = productController;

  final ProductController _productController;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Filtered Result'),
              IconButton(
                onPressed: onClear,
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Category: '),
              Text(
                _productController.searchByCategoryController.selectedLabel ??
                    '',
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Type: '),
              Text(
                _productController.searchByTypeController.selectedLabel ?? '',
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Unit: '),
              Text(_productController.searchByUnitController.text),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Name: '),
              Text(_productController.searchByNameController.text),
            ],
          ),
        ],
      ),
    );
  }
}
