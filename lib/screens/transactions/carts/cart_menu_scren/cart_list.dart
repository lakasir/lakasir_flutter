import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/widgets/card.dart';
import 'package:lakasir/widgets/my_card_list.dart';
import 'package:lakasir/controllers/transactions/cart_controller.dart';
import 'package:lakasir/widgets/text_field.dart';

class CartList extends StatefulWidget {
  const CartList({
    super.key,
    required this.cartItem,
  });

  final CartItem cartItem;

  @override
  State<CartList> createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  final MoneyMaskedTextController _discountController =
      MoneyMaskedTextController(precision: 0, decimalSeparator: "");
  final _cartController = Get.put(CartController());

  _onDiscountUpdate(String? value) {
    if (value!.isNotEmpty) {
      _cartController.calculateDiscountPrice(
        widget.cartItem,
        _discountController.numberValue,
      );
    } else {
      _cartController.calculateDiscountPrice(
        widget.cartItem,
        0,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _discountController.updateValue(
      _cartController
          .cartSessions
          .value
          .cartItems[_cartController.cartSessions.value.cartItems
              .indexOf(widget.cartItem)]
          .discountPrice,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MyCard(
      child: MyCardList(
        list: [
          SizedBox(
            width: Get.width * 88 / 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.cartItem.product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      width: 170, // Adjust the width as needed
                      height: 50, // Adjust the height as needed
                      child: MyTextField(
                        suffixText: "discount".tr,
                        keyboardType: TextInputType.number,
                        controller: _discountController,
                        debounce: 1000,
                        onChanged: _onDiscountUpdate,
                      ),
                    ),
                    SizedBox(
                      child: Text(
                        widget.cartItem.buildRowPrice(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: whiteGrey,
                      ),
                      height: 30,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MaterialButton(
                            minWidth: 50,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                              ),
                            ),
                            padding: const EdgeInsets.all(0),
                            onPressed: () {
                              _cartController.removeQty(
                                widget.cartItem,
                                context,
                              );
                            },
                            child: const Icon(
                              Icons.remove_rounded,
                              size: 15,
                            ),
                          ),
                          Flexible(
                            child: Center(
                              child: Text(
                                widget.cartItem.qty.toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          MaterialButton(
                            minWidth: 50,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                              ),
                            ),
                            padding: const EdgeInsets.all(0),
                            onPressed: () {
                              _cartController.addQty(widget.cartItem);
                            },
                            child: const Icon(
                              Icons.add_rounded,
                              size: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
