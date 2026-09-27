class OrderItemModel {
  final int productId;
  final String productName;
  final double unitPrice;
  final int quantity;

  OrderItemModel({
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    final unitPriceNum = json['unitPrice'];
    double unitPriceValue;
    if (unitPriceNum is int) {
      unitPriceValue = unitPriceNum.toDouble();
    } else if (unitPriceNum is double) {
      unitPriceValue = unitPriceNum;
    } else {
      unitPriceValue = double.tryParse(unitPriceNum.toString()) ?? 0.0;
    }

    return OrderItemModel(
      productId: json['productId'] is int
          ? json['productId']
          : int.tryParse(json['productId'].toString()) ?? 0,
      productName: json['productName']?.toString() ?? '',
      unitPrice: unitPriceValue,
      quantity: json['quantity'] is int
          ? json['quantity']
          : int.tryParse(json['quantity'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "productId": productId,
    "productName": productName,
    "unitPrice": unitPrice,
    "quantity": quantity,
  };
}

class OrderModel {
  final String id;
  final String orderNumber;
  final String userId;
  final double total;
  final List<OrderItemModel> items;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.userId,
    required this.total,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final totalNum = json['total'];
    double totalValue;
    if (totalNum is int) {
      totalValue = totalNum.toDouble();
    } else if (totalNum is double) {
      totalValue = totalNum;
    } else {
      totalValue = double.tryParse(totalNum.toString()) ?? 0.0;
    }

    return OrderModel(
      id: json['id']?.toString() ?? '',
      orderNumber: json['orderNumber']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      total: totalValue,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => OrderItemModel.fromJson(e))
          .toList() ??
          [],
    );
  }
}