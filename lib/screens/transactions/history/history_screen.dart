import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:lakasir/api/requests/pagination_request.dart';
import 'package:lakasir/api/responses/transactions/history_response.dart';
import 'package:lakasir/controllers/auths/auth_controller.dart';
import 'package:lakasir/controllers/setting_controller.dart';
import 'package:lakasir/controllers/settings/secure_initial_price_controller.dart';
import 'package:lakasir/controllers/transactions/analytics/analytics_controller.dart';
import 'package:lakasir/controllers/transactions/history_controller.dart';
import 'package:lakasir/utils/auth.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:lakasir/widgets/analytics_card.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/my_card_list.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _analyticsController = Get.put(AnalyticsController());
  final _historyController = Get.put(HistoryController());
  final _secureInitialPriceController = Get.put(SecureInitialPriceController());
  final _settingController = Get.put(SettingController());
  final _authController = Get.put(AuthController());
  final PagingController<int, TransactionHistoryResponse> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _secureInitialPriceController.isOpened.value = false;
    _pagingController.addPageRequestListener((pageKey) async {
      await _historyController.fetchTransaction(
        PaginationRequest(
          page: pageKey + 1,
          perPage: _historyController.perPage,
        ),
      );
      final isLastPage =
          _historyController.histories.length < _historyController.perPage;
      if (isLastPage) {
        _pagingController.appendLastPage(_historyController.histories);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(
          _historyController.histories,
          nextPageKey,
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "transaction_history".tr,
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "transaction_analytics".tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (_settingController.setting.value.hideInitialPrice! &&
                    can(
                      _authController.permissions,
                      'verify secure initial price',
                    ))
                  IconButton(
                    onPressed: () {
                      _secureInitialPriceController.verifyPassword();
                      // _pagingController.refresh();
                    },
                    icon: const Icon(Icons.remove_red_eye),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Obx(
                  () {
                    var isOpen =
                        _settingController.setting.value.hideInitialPrice! &&
                            !_secureInitialPriceController.isOpened.value;
                    return AnalyticsCard(
                      hideValue: isOpen,
                      textEmoji: "🤑",
                      title: "transaction_analytics_gross_profit".tr,
                      trendPercentage:
                          "${_analyticsController.totalGrossProfit.value.percentageChange}%",
                      trendIcon: HeroIcon(
                        _analyticsController
                                    .totalGrossProfit.value.percentageChange >=
                                0
                            ? HeroIcons.arrowTrendingUp
                            : HeroIcons.arrowTrendingDown,
                        color: _analyticsController
                                    .totalGrossProfit.value.percentageChange >=
                                0
                            ? Colors.green
                            : Colors.red,
                      ),
                      onFilter: (value) {
                        _analyticsController.fetchTotalGrossProfit(
                          filterType: value,
                        );
                      },
                      value: formatPrice(
                        _analyticsController
                            .totalGrossProfit.value.totalGrossProfit,
                        isSymbol: false,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 10),
                Obx(
                  () {
                    var isOpen =
                        _settingController.setting.value.hideInitialPrice! &&
                            !_secureInitialPriceController.isOpened.value;
                    return AnalyticsCard(
                      hideValue: isOpen,
                      backgroundColor: const Color.fromARGB(255, 81, 165, 176),
                      textEmoji: "💰",
                      title: "transaction_analytics_total_sales".tr,
                      trendPercentage:
                          "${_analyticsController.totalSales.value.percentageChange}%",
                      trendIcon: HeroIcon(
                        _analyticsController
                                    .totalSales.value.percentageChange >=
                                0
                            ? HeroIcons.arrowTrendingUp
                            : HeroIcons.arrowTrendingDown,
                        color: _analyticsController
                                    .totalSales.value.percentageChange >=
                                0
                            ? Colors.green
                            : Colors.red,
                      ),
                      onFilter: (value) {
                        _analyticsController.fetchTotalSales(
                          filterType: value,
                        );
                      },
                      value: _analyticsController.totalSales.value.totalSales
                          .toString(),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Obx(
                  () {
                    var isOpen =
                        _settingController.setting.value.hideInitialPrice! &&
                            !_secureInitialPriceController.isOpened.value;
                    return AnalyticsCard(
                      hideValue: isOpen,
                      backgroundColor: primary,
                      textEmoji: "💴",
                      title: "transaction_analytics_net_profit".tr,
                      trendPercentage:
                          "${_analyticsController.totalRevenue.value.percentageChange}%",
                      trendIcon: HeroIcon(
                        _analyticsController
                                    .totalRevenue.value.percentageChange >=
                                0
                            ? HeroIcons.arrowTrendingUp
                            : HeroIcons.arrowTrendingDown,
                        color: _analyticsController
                                    .totalRevenue.value.percentageChange >=
                                0
                            ? Colors.green
                            : Colors.red,
                      ),
                      onFilter: (value) {
                        _analyticsController.fetchTotalRevenue(
                          filterType: value,
                        );
                      },
                      value: formatPrice(
                        _analyticsController.totalRevenue.value.totalRevenue,
                        isSymbol: false,
                      ),
                    );
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "transaction_list".tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _pagingController.refresh();
                  },
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            Expanded(
              child: PagedListView(
                pagingController: _pagingController,
                builderDelegate:
                    PagedChildBuilderDelegate<TransactionHistoryResponse>(
                  itemBuilder: (context, history, index) => CardList(
                    history: history,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

class CardList extends StatelessWidget {
  const CardList({
    super.key,
    required this.history,
  });

  final TransactionHistoryResponse history;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        MyCardList(
          onTap: () {
            Get.toNamed('/menu/transaction/history/detail', arguments: history);
          },
          list: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('dd-MM-yyyy HH:mm')
                      .format(DateTime.parse(history.createdAt!).toLocal())
                      .toString(),
                ),
                Text(
                  "Total Qty: ${history.totalQuantity}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Total Price: ${formatPrice(history.totalPrice!, isSymbol: false)}",
              style: const TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}
