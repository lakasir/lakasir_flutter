import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/products/product_controller.dart';
import 'package:lakasir/controllers/setting_controller.dart';
import 'package:lakasir/screens/setting/selling_methods/fifo_screen.dart';
import 'package:lakasir/screens/setting/selling_methods/lifo_screen.dart';
import 'package:lakasir/screens/setting/selling_methods/normal_screen.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/widgets/layout.dart';

class SellingMethodScreen extends StatelessWidget {
  SellingMethodScreen({super.key});
  final _settingController = Get.put(SettingController());
  final _productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: 'selling_method'.tr,
      child: Column(
        children: [
          Text(
            "selling_method_info".tr,
            style: const TextStyle(fontSize: 16, color: error),
          ),
          DefaultTabController(
            length: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TabBar(
                  tabs: [
                    Tab(
                      text: "Fifo".tr,
                    ),
                    Tab(
                      text: "Lifo".tr,
                    ),
                    Tab(
                      text: "Normal".tr,
                    ),
                  ],
                ),
                SizedBox(
                  height: 400,
                  child: Obx(
                    () => TabBarView(
                      children: [
                        FifoScreen(
                          isEnable:
                              _settingController.setting.value.sellingMethod ==
                                  "fifo",
                          onChanged: (value) {
                            _settingController.updateSetting(
                              'selling_method',
                              'fifo',
                            );
                            _productController.getProducts();
                          },
                        ),
                        LifoScreen(
                          isEnable:
                              _settingController.setting.value.sellingMethod ==
                                  'lifo',
                          onChanged: (value) {
                            _settingController.updateSetting(
                              'selling_method',
                              'lifo',
                            );
                            _productController.getProducts();
                          },
                        ),
                        NormalScreen(
                          isEnable:
                              _settingController.setting.value.sellingMethod ==
                                  'normal',
                          onChanged: (value) {
                            _settingController.updateSetting(
                              'selling_method',
                              'normal',
                            );
                            _productController.getProducts();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
