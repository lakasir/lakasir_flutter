import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/api/responses/products/product_response.dart';
import 'package:lakasir/controllers/products/product_detail_controller.dart';
import 'package:lakasir/controllers/products/stocks/product_stock_controller.dart';
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
  final _productStockController = Get.put(ProductStockController());
  final _productDetailController = Get.find<ProductDetailController>();

  @override
  void initState() {
    fetchDetail();
    super.initState();
  }

  void fetchDetail() async {
    final ProductResponse products = Get.arguments;
    await _productDetailController.get(products.id);
    await _productStockController.get(products.id);
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: 'Detail Stock',
      child: Obx(
        () {
          if (_productDetailController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (_productDetailController.product.value.id == 0) {
            return const Center(
              child: Text("Product Not Found"),
            );
          }
          String initialFormattedPrice = formatPrice(
              _productDetailController.product.value.initialPrice ?? 0);
          String sellingFormattedPrice = formatPrice(
              _productDetailController.product.value.sellingPrice ?? 0);

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
                    'Stock: ${_productDetailController.product.value.stock}',
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
                imagebox: Hero(
                  tag: 'product-${_productDetailController.product.value.id}',
                  child: SizedBox(
                    height: 90,
                    width: 90,
                    child: MyImage(
                        images: _productDetailController.product.value.image),
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
                        const Text(
                          "The last initial price",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(initialFormattedPrice),
                      ],
                    ),
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
                                productStockController: _productStockController,
                              );
                            },
                          );
                        },
                        child: const Text(
                          "Add / Edit Initial Price",
                          style: TextStyle(
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
                child: const Text(
                  "Stock History",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
                          trailing: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Delete Stock"),
                                    content: const Text(
                                        "Are you sure want to delete this stock?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _productStockController.delete(
                                              _productDetailController
                                                  .product.value.id,
                                              stockHistory.id);
                                          Get.back();
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
      title: "Add / Edit Initial Price",
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
                    label: "Date",
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
                      label: "Stock",
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
                            label: "Initial Price",
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
                            label: "Selling Price",
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
                    child: const Text("Save Stock"),
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
