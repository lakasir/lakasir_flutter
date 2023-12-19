import 'package:flutter/material.dart';
import 'package:lakasir/api/responses/abouts/about_response.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/widgets/layout.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  AboutResponse shop = AboutResponse(
    shopeName: "Profile Name",
    businessType: "retail",
    ownerName: "John Doe",
    location: "lorem ipsum dolor sit amet",
    currency: "IDR",
  );

  @override
  Widget build(BuildContext context) {
    return Layout(
      noAppBar: true,
      noPadding: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  title: const Center(
                    child: Text(
                      'About',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  expandedHeight: MediaQuery.of(context).size.height * 0.5,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: const BoxDecoration(
                        color: primary,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 20, left: 50),
                                width: 160,
                                height: 160,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: const Icon(
                                  Icons.shopping_bag,
                                  size: 100,
                                  color: whiteGrey,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/menu/about/edit',
                                    arguments: shop,
                                  );
                                },
                                icon: const Icon(
                                  size: 30,
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'John Doe',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Shop Name",
                              style: TextStyle(fontSize: 16)),
                          const SizedBox(height: 5),
                          Text(
                            shop.shopeName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Bussiness Type",
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            shop.businessType,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Owner's Name",
                              style: TextStyle(fontSize: 16)),
                          const SizedBox(height: 5),
                          Text(
                            shop.ownerName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Location",
                              style: TextStyle(fontSize: 16)),
                          const SizedBox(height: 5),
                          Text(
                            shop.location,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Currency",
                              style: TextStyle(fontSize: 16)),
                          const SizedBox(height: 5),
                          Text(
                            shop.currency,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
