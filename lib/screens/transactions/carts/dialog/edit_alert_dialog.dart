import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/members/member_controller.dart';
import 'package:lakasir/controllers/payment_method_controller.dart';
import 'package:lakasir/controllers/transactions/cart_controller.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/widgets/dialog.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/select_input_feld.dart';
import 'package:lakasir/widgets/text_field.dart';

class EditDetailAlert extends StatefulWidget {
  const EditDetailAlert({super.key});

  @override
  State<EditDetailAlert> createState() => _EditDetailAlertState();
}

class _EditDetailAlertState extends State<EditDetailAlert> {
  final SelectInputWidgetController selectInputWidgetController =
      SelectInputWidgetController();

  final TextEditingController taxController = TextEditingController();
  final _memberController = Get.put(MemberController());
  final _paymentMethodController = Get.put(PaymentMethodController());
  final _cartController = Get.put(CartController());

  @override
  void initState() {
    super.initState();
    if (_cartController.cartSessions.value.tax != null) {
      taxController.text = _cartController.cartSessions.value.tax.toString();
    } else {
      taxController.text = "0";
    }

    if (_cartController.cartSessions.value.member != null) {
      selectInputWidgetController.selectedOption =
          _cartController.cartSessions.value.member!.id.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyDialog(
      title: "Edit Detail",
      content: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(
              bottom: 10,
            ),
            child: SelectInputWidget(
              hintText: _memberController.members.isEmpty
                  ? "No Member"
                  : "Select Member",
              options: _memberController.members
                  .map(
                    (e) => Option(
                      value: e.id.toString(),
                      name: e.name,
                    ),
                  )
                  .toList(),
              controller: selectInputWidgetController,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              bottom: 10,
            ),
            child: MyTextField(
              label: "TAX",
              hintText: "%",
              controller: taxController,
              keyboardType: TextInputType.number,
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(
              bottom: 10,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: const Text(
                    "Payment Method",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: secondary,
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
                              width: width * 25 / 100,
                              height: 55,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: _cartController.cartSessions.value
                                            .paymentMethod ==
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
          MyFilledButton(
            onPressed: () {
              _cartController.cartSessions.update((val) {
                if (selectInputWidgetController.selectedOption != null) {
                  for (var element in _memberController.members) {
                    if (element.id ==
                        int.parse(selectInputWidgetController.selectedOption!)) {
                      val!.member = element;
                    }
                  }
                }
                if (taxController.text.isNotEmpty) {
                  val!.tax = int.parse(taxController.text);
                }
              });
              _cartController.cartSessions.refresh();
              Get.back();
            },
            child: const Text("Save Detail"),
          ),
        ],
      ),
    );
  }
}
