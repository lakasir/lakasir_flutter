import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:lakasir/widgets/card.dart';
import 'package:lakasir/widgets/my_card_list.dart';
import 'package:lakasir/controllers/transactions/cart_controller.dart';
import 'package:lakasir/widgets/text_field.dart';

class CartList extends StatelessWidget {
  CartList({
    super.key,
    required this.cartItem,
    required CartController cartController,
  }) : _cartController = cartController;

  final CartItem cartItem;
  final CartController _cartController;
  final MoneyMaskedTextController _discountController =
      MoneyMaskedTextController(precision: 0, decimalSeparator: "");

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
                      cartItem.product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      child: Text(
                        cartItem.buildRowPrice(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 200, // Adjust the width as needed
                      height: 50, // Adjust the height as needed
                      child: MyTextField(
                        keyboardType: TextInputType.number,
                        controller: _discountController,
                        onTapOutside: (po) {
                          _cartController.calculateDiscountPrice(
                            cartItem,
                            _discountController.numberValue,
                          );
                          debug(_discountController.numberValue);
                          _discountController
                              .updateValue(_discountController.numberValue);
                        },
                      ),
                    )
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
                              _cartController.removeQty(cartItem);
                            },
                            child: const Icon(
                              Icons.remove_rounded,
                              size: 15,
                            ),
                          ),
                          Flexible(
                            child: Center(
                              child: Text(
                                cartItem.qty.toString(),
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
                              _cartController.addQty(cartItem);
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
