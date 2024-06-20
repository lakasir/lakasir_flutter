import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/api/responses/products/product_response.dart';
import 'package:lakasir/controllers/auths/auth_controller.dart';
import 'package:lakasir/controllers/setting_controller.dart';
import 'package:lakasir/controllers/settings/secure_initial_price_controller.dart';
import 'package:lakasir/utils/auth.dart';
import 'package:lakasir/utils/utils.dart';

class ProductDetailWidget extends StatefulWidget {
  const ProductDetailWidget({
    super.key,
    required this.width,
    required this.products,
    required SettingController settingController,
    this.isLoading = false,
  }) : _settingController = settingController;

  final double width;
  final ProductResponse products;
  final SettingController _settingController;
  final bool isLoading;

  @override
  State<ProductDetailWidget> createState() => _ProductDetailWidgetState();
}

class _ProductDetailWidgetState extends State<ProductDetailWidget> {
  final _secureInitialPriceController = Get.put(SecureInitialPriceController());
  final _authController = Get.put(AuthController());

  @override
  void dispose() {
    _secureInitialPriceController.isOpened(false);
    _secureInitialPriceController.passwordError.value = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: widget.width * 0.65,
                    child: Text(
                      widget.products.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (!widget.products.isNonStock)
                    Text(
                      "${"field_stock".tr}: ${widget.products.stock}",
                    ),
                  if (widget.products.isNonStock)
                    Text(
                      "field_is_non_stock".tr,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
              Text(
                formatPrice(widget.products.sellingPrice ?? 0),
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
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
        if (_authController.feature(feature: 'product-sku'))
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "field_sku".tr,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.products.sku,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (_authController.feature(feature: 'product-barcode'))
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "field_barcode".tr,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.products.barcode ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (_authController.can(
          ability: 'read detail initial price',
          feature: 'product-initial-price',
        ))
          fieldInitialPrice(),
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
                  widget.products.type,
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
                  widget.products.unit,
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
                  widget.products.category!.name,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container fieldInitialPrice() {
    return Container(
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
            child: InkWell(
              onTap: () {
                if (widget._settingController.setting.value.hideInitialPrice! &&
                    !_secureInitialPriceController.isOpened.value) {
                  _secureInitialPriceController.verifyPassword();
                }
              },
              child: Obx(
                () {
                  if (widget
                          ._settingController.setting.value.hideInitialPrice! &&
                      !_secureInitialPriceController.isOpened.value) {
                    return Text(
                      "click_to_show".tr,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                      ),
                    );
                  }
                  return Text(
                    formatPrice(widget.products.initialPrice ?? 0),
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
