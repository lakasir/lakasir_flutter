class CashierReportResponse {
  final TransactionCashierReportResponse? transaction;
  final TotalCashierReportResponse? total;

  CashierReportResponse({
    this.transaction,
    this.total,
  });

  factory CashierReportResponse.fromJson(Map<String, dynamic> json) {
    return CashierReportResponse(
      transaction: json['transaction'] == null
          ? null
          : TransactionCashierReportResponse.fromJson(
              json['transaction'] as Map<String, dynamic>,
            ),
      total: json['total'] == null
          ? null
          : TotalCashierReportResponse.fromJson(
              json['total'] as Map<String, dynamic>,
            ),
    );
  }
}

class TotalCashierReportResponse {
  final double? grossProfit;
  final double? totalCost;
  final double? totalNetProfit;

  TotalCashierReportResponse({
    this.grossProfit,
    this.totalCost,
    this.totalNetProfit,
  });

  factory TotalCashierReportResponse.fromJson(Map<String, dynamic> json) {
    return TotalCashierReportResponse(
      grossProfit: json['gross_profit'].toDouble(),
      totalCost: json['total_cost'].toDouble(),
      totalNetProfit: json['total_net_profit'].toDouble(),
    );
  }
}

class TransactionCashierReportResponse {
  final int? id;
  final String? date;
  final String? number;
  final String? user;
  final List<ItemTransactionCashierReportResponse>? items;

  TransactionCashierReportResponse({
    this.id,
    this.date,
    this.number,
    this.user,
    this.items,
  });

  factory TransactionCashierReportResponse.fromJson(Map<String, dynamic> json) {
    return TransactionCashierReportResponse(
      id: json['id'] as int?,
      date: json['created_at'] as String?,
      number: json['number'] as String?,
      user: json['user'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => ItemTransactionCashierReportResponse.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ItemTransactionCashierReportResponse {
  final String? product;
  final int? quantity;
  final double? price;
  final double? cost;
  final double? netProfit;

  ItemTransactionCashierReportResponse({
    this.product,
    this.quantity,
    this.price,
    this.cost,
    this.netProfit,
  });

  factory ItemTransactionCashierReportResponse.fromJson(
      Map<String, dynamic> json) {
    return ItemTransactionCashierReportResponse(
      product: json['product'] as String?,
      quantity: json['quantity'] as int?,
      price: json['price'].toDouble(),
      cost: json['cost'].toDouble(),
      netProfit: json['net_profit'].toDouble(),
    );
  }
}
