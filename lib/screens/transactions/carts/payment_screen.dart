import 'package:flutter/material.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:lakasir/widgets/calculator_payment_button.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/my_bottom_bar.dart';
import 'package:lakasir/widgets/my_bottom_bar_actions.dart';
import 'package:lakasir/widgets/select_input_feld.dart';
import 'package:lakasir/widgets/text_field.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  double money = 0;

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: 'Total: Rp. 100.000',
      bottomNavigationBar: MyBottomBar(
        onPressed: () {
          Navigator.pushNamed(context, '/menu/transaction/cashier/receipt');
        },
        label: const Text(
          "Pay it",
        ),
        actions: [
          MyBottomBarActions(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => EditDetailAlert(),
              );
            },
            label: "Edit Detail",
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            formatPrice(money, isSymbol: false),
            style: const TextStyle(
              fontSize: 47,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          CalculatorPaymentButton(
            onUpdated: (String value) {
              setState(() {
                money = double.parse(value);
              });
            },
          ),
        ],
      ),
    );
  }
}

class EditDetailAlert extends StatelessWidget {
  EditDetailAlert({super.key});

  final SelectInputWidgetController selectInputWidgetController =
      SelectInputWidgetController();
  final TextEditingController taxController = TextEditingController();
  final List<Container> payments = [
    Container(
      padding: const EdgeInsets.all(8),
      color: Colors.teal[100],
      child: const Text("He'd have you all unravel at the"),
    ),
    Container(
      padding: const EdgeInsets.all(8),
      color: Colors.teal[100],
      child: const Text("He'd have you all unravel at the"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: const EdgeInsets.all(0),
      surfaceTintColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
      content: SizedBox(
        width: 0.9 * MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Action",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Container(
              height: 1,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: secondary),
                borderRadius: BorderRadius.circular(12),
                color: whiteGrey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: SelectInputWidget(
                      hintText: "Select Member",
                      options: [
                        Option(
                          name: "Member 1",
                          value: "member_1",
                        ),
                      ],
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
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(
                            payments.length,
                            (index) {
                              double width = MediaQuery.of(context).size.width;
                              return Container(
                                width: width * 25 / 100,
                                height: 55,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: whiteGrey,
                                ),
                                child: MaterialButton(
                                  onPressed: () {},
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Item $index',
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  MyFilledButton(
                    onPressed: () {},
                    child: const Text("Save Detail"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
