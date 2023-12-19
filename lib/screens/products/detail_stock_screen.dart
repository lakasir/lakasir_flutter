import 'package:flutter/material.dart';
import 'package:lakasir/api/responses/products/product_response.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/my_card_list.dart';
import 'package:lakasir/widgets/radio_group_field.dart';
import 'package:lakasir/widgets/text_field.dart';

class DetailStockScreen extends StatelessWidget {
  const DetailStockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductResponse products =
        ModalRoute.of(context)!.settings.arguments as ProductResponse;
    String initialFormattedPrice = formatPrice(products.initialPrice);
    String sellingFormattedPrice = formatPrice(products.sellingPrice);

    return Layout(
      title: 'Detail Stock',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyCardList(
            list: [
              Text(products.name, style: const TextStyle(fontSize: 20)),
              Text(
                'Stock: ${products.stock}',
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
              tag: 'product-${products.id}',
              child: SizedBox(
                height: 90,
                width: 90,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image(
                    width: 200,
                    height: 150,
                    image: NetworkImage(products.image),
                    fit: BoxFit.cover,
                  ),
                ),
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
                            products: products,
                            initialFormattedPrice: initialFormattedPrice,
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
          Expanded(
            child: ListView.builder(
              itemCount: products.stocks!.length,
              itemBuilder: (context, index) {
                final stockHistory = products.stocks![index];
                return Container(
                  margin: const EdgeInsets.only(top: 23),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${stockHistory.stock} Items',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            stockHistory.createdAt,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        stockHistory.type,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ActionModalStock extends StatelessWidget {
  const ActionModalStock({
    super.key,
    required this.products,
    required this.initialFormattedPrice,
  });

  final ProductResponse products;
  final String initialFormattedPrice;

  @override
  Widget build(BuildContext context) {
    TextEditingController dateInputEditingController = TextEditingController();
    TextEditingController initialPriceInputEditingController =
        TextEditingController();
    TextEditingController stockInputEditingController = TextEditingController();
    TextEditingController sellingPriceInputEditingController =
        TextEditingController();

    return AlertDialog.adaptive(
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
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
                    child: MyCardList(
                      imagebox: SizedBox(
                        height: 60,
                        width: 60,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(99),
                          child: Image(
                            width: 200,
                            height: 150,
                            image: NetworkImage(
                              products.image,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      list: [
                        Container(
                          width: 0.61 * MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(
                            left: 5,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(products.name),
                                  Text(
                                    initialFormattedPrice,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w200,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${products.stock} Stock',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  MyRadioGroup(
                    options: [
                      RadioOption(
                        label: "Add Stock",
                        value: "add",
                      ),
                      RadioOption(
                        label: "Reduce Stock",
                        value: "reduce",
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: MyTextField(
                      controller: dateInputEditingController,
                      label: "Date",
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: MyTextField(
                      controller: stockInputEditingController,
                      label: "Stock",
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: MyTextField(
                      controller: initialPriceInputEditingController,
                      label: "Initial Price",
                      mandatory: true,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 20,
                    ),
                    child: MyTextField(
                      controller: sellingPriceInputEditingController,
                      label: "Selling Price",
                      mandatory: true,
                    ),
                  ),
                  MyFilledButton(
                    onPressed: () {},
                    child: const Text("Save Stock"),
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
