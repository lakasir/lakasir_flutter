import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/api/responses/products/product_response.dart';
import 'package:lakasir/controllers/auths/auth_controller.dart';
import 'package:lakasir/controllers/products/product_detail_controller.dart';
import 'package:lakasir/controllers/products/stocks/product_stock_controller.dart';
import 'package:lakasir/utils/auth.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:lakasir/widgets/date_picker.dart';
import 'package:lakasir/widgets/dialog.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/my_card_list.dart';
import 'package:lakasir/widgets/text_field.dart';

class DetailStockScreen extends StatefulWidget {
  const DetailStockScreen({super.key});

  @override
  State<DetailStockScreen> createState() => _DetailStockScreenState();
}

class _DetailStockScreenState extends State<DetailStockScreen> {
  final _productDetailController = Get.put(ProductDetailController());
  final _productStockController = Get.put(ProductStockController());
  final _authController = Get.put(AuthController());

  @override
  void initState() {
    fetchDetail();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void fetchDetail() async {
    if (Get.arguments is ProductResponse) {
      final ProductResponse products = Get.arguments;
      await _productStockController.get(products.id);
      setState(() {
        _productDetailController.product.value = products;
      });
    } else {
      final String productId = Get.arguments;
      await _productStockController.get(int.parse(productId));
      await _productDetailController.get(int.parse(productId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: 'field_stock_history'.tr,
      child: Obx(
        () {
          if (_productStockController.isLoading.value ||
              _productDetailController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (_productDetailController.product.value.id == 0) {
            return Center(
              child:
                  Text('global_not_found'.trParams({'item': 'menu_product'})),
            );
          }
          String initialFormattedPrice = formatPrice(
            _productDetailController.product.value.initialPrice,
          );
          String sellingFormattedPrice = formatPrice(
            _productDetailController.product.value.sellingPrice,
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyCardList(
                list: [
                  Text(
                    _productDetailController.product.value.name,
                    style: const TextStyle(fontSize: 20),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                  ),
                  Text(
                    '${'field_stock'.tr}: ${_productDetailController.product.value.stock}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  Text(
                    '$initialFormattedPrice - $sellingFormattedPrice',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
                imagebox: SizedBox(
                  height: 90,
                  width: 90,
                  child: MyImage(
                    images: _productDetailController.product.value.image,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.all(16),
                height: 100,
                decoration: BoxDecoration(
                  color: grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "field_last_initial_price".tr,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(initialFormattedPrice),
                      ],
                    ),
                    if (can(
                      _authController.permissions,
                      ability: 'create product stock',
                    ))
                      SizedBox(
                        height: 33,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                            ),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return ActionModalStock(
                                  products:
                                      _productDetailController.product.value,
                                  initialFormattedPrice: initialFormattedPrice,
                                  productStockController:
                                      _productStockController,
                                );
                              },
                            );
                          },
                          child: Text(
                            "add_or_edit_stock".tr,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Text(
                  "field_stock_history".tr,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              if (_productStockController.isLoading.value)
                const Center(
                  child: CircularProgressIndicator(),
                ),
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: _productStockController.stocks.length,
                    itemBuilder: (context, index) {
                      final stockHistory =
                          _productStockController.stocks[index];

                      return Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          title: Text(
                            "${stockHistory.initStock} Items${stockHistory.type == "in" ? " Added" : " Reduced"}",
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                stockHistory.date,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                              Text(
                                "${formatPrice(stockHistory.initialPrice!)} - ${formatPrice(stockHistory.sellingPrice!)}",
                              ),
                            ],
                          ),
                          trailing: can(
                            _authController.permissions,
                            ability: 'delete product stock',
                          )
                              ? IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("global_delete_item"
                                              .trParams(
                                                  {"item": "feild_stock"})),
                                          content: Text("global_sure_content"
                                              .trParams({
                                            "item": "field_stock_history".tr
                                          })),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              child: Text("global_cancel".tr),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                _productStockController.delete(
                                                    _productDetailController
                                                        .product.value.id,
                                                    stockHistory.id);
                                                Get.back();
                                              },
                                              child: Text("global_ok".tr),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.delete),
                                )
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class MyImage extends StatelessWidget {
  const MyImage({
    super.key,
    this.images,
  });

  final String? images;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: images != null
          ? Image.network(
              images!,
              fit: BoxFit.cover,
              frameBuilder: (BuildContext context, Widget child, int? frame,
                  bool wasSynchronouslyLoaded) {
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
          : const Image(
              image: AssetImage('assets/no-image-100.png'),
              fit: BoxFit.cover,
            ),
    );
  }
}

class ActionModalStock extends StatefulWidget {
  const ActionModalStock({
    super.key,
    required this.products,
    required this.initialFormattedPrice,
    required this.productStockController,
  });

  final ProductResponse products;
  final String initialFormattedPrice;
  final ProductStockController productStockController;

  @override
  State<ActionModalStock> createState() => _ActionModalStockState();
}

class _ActionModalStockState extends State<ActionModalStock> {
  @override
  void dispose() {
    widget.productStockController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyDialog(
      title: "add_or_edit_stock".tr,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: widget.productStockController.formKey,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: MyCardList(
                    imagebox: SizedBox(
                      height: 60,
                      width: 60,
                      child: MyImage(images: widget.products.image),
                    ),
                    list: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 0.60 * MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(widget.products.name),
                                Text(
                                  widget.initialFormattedPrice,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w200,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${widget.products.stock} Stock',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: MyDatePicker(
                    label: "field_date".tr,
                    controller: widget
                        .productStockController.dateInputEditingController,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: Obx(
                    () => MyTextField(
                      controller: widget
                          .productStockController.stockInputEditingController,
                      label: "field_stock".tr,
                      keyboardType: TextInputType.number,
                      mandatory: true,
                      errorText: widget.productStockController
                              .stockErrorResponse.value.stock ??
                          '',
                    ),
                  ),
                ),
                Obx(
                  () {
                    if (widget.productStockController.type.value == "in") {
                      return Container(
                        margin: const EdgeInsets.only(
                          bottom: 10,
                        ),
                        child: Obx(
                          () => MyTextField(
                            controller: widget.productStockController
                                .initialPriceInputEditingController,
                            label: "field_initial_price".tr,
                            info: "field_last_initial_price_info".tr,
                            keyboardType: TextInputType.number,
                            errorText: widget.productStockController
                                    .stockErrorResponse.value.initialPrice ??
                                '',
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                Obx(
                  () {
                    if (widget.productStockController.type.value == "in") {
                      return Container(
                        margin: const EdgeInsets.only(
                          bottom: 20,
                        ),
                        child: Obx(
                          () => MyTextField(
                            controller: widget.productStockController
                                .sellingPriceInputEditingController,
                            label: "field_selling_price".tr,
                            info: "field_last_selling_price_info".tr,
                            keyboardType: TextInputType.number,
                            errorText: widget.productStockController
                                    .stockErrorResponse.value.sellingPrice ??
                                '',
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                Obx(
                  () => MyFilledButton(
                    onPressed: () => widget.productStockController
                        .create(widget.products.id),
                    isLoading: widget.productStockController.isLoading.value,
                    child: Text("global_save".tr),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
