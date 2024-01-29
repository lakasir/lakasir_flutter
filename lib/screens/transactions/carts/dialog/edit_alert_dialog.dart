import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/members/member_controller.dart';
import 'package:lakasir/controllers/transactions/cart_controller.dart';
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

  final MoneyMaskedTextController taxController = MoneyMaskedTextController(
    thousandSeparator: '.',
    decimalSeparator: ',',
    rightSymbol: ' %',
    precision: 1,
  );
  final MemberController _memberController = Get.put(MemberController());
  final _cartController = Get.put(CartController());

  @override
  void initState() {
    super.initState();
    if (_cartController.cartSessions.value.tax != null) {
      taxController.updateValue(_cartController.cartSessions.value.tax!);
    }

    if (_cartController.cartSessions.value.member != null) {
      selectInputWidgetController.selectedOption =
          _cartController.cartSessions.value.member!.id.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyDialog(
      title: "cart_edit_detail".tr,
      content: Column(
        children: [
          Obx(
            () => Container(
              margin: const EdgeInsets.only(
                bottom: 10,
              ),
              child: SelectInputWidget(
                label: "field_member".tr,
                hintText: _memberController.members.isEmpty
                    ? "global_no_item".trParams(
                        {"item": "menu_member".tr},
                      )
                    : "field_select_item".trParams(
                        {"item": "menu_member".tr},
                      ),
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
          ),
          Container(
            margin: const EdgeInsets.only(
              bottom: 10,
            ),
            child: MyTextField(
              label: "field_tax".tr,
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
          ),
          MyFilledButton(
            onPressed: () {
              _cartController.cartSessions.update((val) {
                if (selectInputWidgetController.selectedOption != null) {
                  for (var element in _memberController.members) {
                    if (element.id ==
                        int.parse(
                            selectInputWidgetController.selectedOption!)) {
                      val!.member = element;
                    }
                  }
                }
                if (taxController.text.isNotEmpty) {
                  val!.tax = taxController.numberValue;
                }
              });
              _cartController.cartSessions.refresh();
              Get.back();
            },
            child: Text("global_save_title".trParams(
              {"title": "detail".tr},
            )),
          ),
        ],
      ),
    );
  }
}
