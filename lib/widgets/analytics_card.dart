import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

class AnalyticsCard extends StatefulWidget {
  const AnalyticsCard({
    super.key,
    this.textEmoji = "🤑",
    this.value,
    required this.title,
    required this.onFilter,
    required this.trendPercentage,
    required this.trendIcon,
    this.backgroundColor = const Color.fromARGB(255, 165, 50, 236),
  });

  final String textEmoji;
  final dynamic value;
  final String title;
  final void Function(String) onFilter;
  final String trendPercentage;
  final HeroIcon trendIcon;
  final Color backgroundColor;

  @override
  State<AnalyticsCard> createState() => _AnalyticsCardState();
}

class _AnalyticsCardState extends State<AnalyticsCard> {
  final _filterOptions = {
    "today": "transaction_analytics_filter_today".tr,
    // "yesterday": "transaction_analytics_filter_yesterday".tr,
    "this_week": "transaction_analytics_filter_this_week".tr,
    // "last_week": "transaction_analytics_filter_last_week".tr,
    "this_month": "transaction_analytics_filter_this_month".tr,
    // "last_month": "transaction_analytics_filter_last_month".tr,
    "this_year": "transaction_analytics_filter_this_year".tr,
    // "last_year": "transaction_analytics_filter_last_year".tr,
  };

  String selectedFilter = "today";

  String getTrendWord(String filter) {
    switch (filter) {
      case "today":
        return "${"global_from".tr} ${"transaction_analytics_filter_yesterday".tr}";
      case "this_week":
        return "${"global_from".tr} ${"transaction_analytics_filter_last_week".tr}";
      case "this_month":
        return "${"global_from".tr} ${"transaction_analytics_filter_last_month".tr}";
      case "this_year":
        return "${"global_from".tr} ${"transaction_analytics_filter_last_year".tr}";
      default:
        return "${"global_from".tr} ${"transaction_analytics_filter_yesterday".tr}";
    }
  }

  @override
  Widget build(BuildContext context) {
    var menuController = MenuController();
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(
          left: 12,
          right: 0,
          top: 12,
          bottom: 10,
        ),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        color: Colors.white,
                      ),
                      child: Text(widget.textEmoji),
                    ),
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                      softWrap: false,
                    ),
                  ],
                ),
                MenuAnchor(
                  controller: menuController,
                  builder: (
                    BuildContext context,
                    MenuController controller,
                    Widget? child,
                  ) {
                    return InkWell(
                      onTap: () {
                        if (controller.isOpen) {
                          controller.close();
                        } else {
                          controller.open();
                        }
                      },
                      child: const HeroIcon(
                        HeroIcons.ellipsisVertical,
                        color: Colors.white,
                      ),
                    );
                  },
                  menuChildren: List<InkWell>.generate(
                    _filterOptions.length,
                    (index) => InkWell(
                      onTap: () {
                        widget.onFilter(_filterOptions.keys.elementAt(index));
                        setState(() {
                          selectedFilter = _filterOptions.keys.elementAt(index);
                        });
                        menuController.close();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        width: 100,
                        child: Text(_filterOptions.values.elementAt(index)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              widget.value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              children: [
                widget.trendIcon,
                const SizedBox(width: 5),
                Text(
                  "${widget.trendPercentage} ${getTrendWord(selectedFilter)}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w200,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
