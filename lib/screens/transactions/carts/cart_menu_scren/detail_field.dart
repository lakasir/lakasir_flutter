import 'package:flutter/material.dart';
import 'package:lakasir/controllers/auths/auth_controller.dart';
import 'package:lakasir/controllers/payment_method_controller.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/transactions/cart_controller.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/widgets/card.dart';

class DetailField extends StatelessWidget {
  DetailField({
    super.key,
  });

  final _paymentMethodController = Get.put(PaymentMethodController());
  final _authController = Get.put(AuthController());
  final CartController _cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_authController.feature(feature: 'member'))
          MyCard(
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'field_member'.tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _cartController.cartSessions.value.member?.name ??
                        'global_no_item'.trParams(
                          {"item": "field_member".tr},
                        ),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        MyCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: Get.width,
                margin: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: Text(
                  "field_payment_method".tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Obx(
                () {
                  if (_paymentMethodController.isFetching.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(
                      _paymentMethodController.paymentMethods.length,
                      (index) {
                        double width = Get.width;
                        return Obx(
                          () => Container(
                            width: width * (context.isTablet ? 10 : 25) / 100,
                            height: 55,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: _cartController
                                          .cartSessions.value.paymentMethod ==
                                      _paymentMethodController
                                          .paymentMethods[index]
                                  ? grey
                                  : whiteGrey,
                            ),
                            child: MaterialButton(
                              onPressed: () {
                                _cartController
                                        .cartSessions.value.paymentMethod =
                                    _paymentMethodController
                                        .paymentMethods[index];
                                _cartController.cartSessions.refresh();
                              },
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Center(
                                child: Text(
                                  _paymentMethodController
                                      .paymentMethods[index].name,
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        MyCard(
          child: Obx(
            () => SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'field_note'.tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _cartController.cartSessions.value.getNote,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
