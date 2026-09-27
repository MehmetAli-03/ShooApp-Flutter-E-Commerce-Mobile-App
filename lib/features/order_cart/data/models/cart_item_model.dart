class CartItemModel {
  final int id;
  final String brand;
  final String name;
  final double price;
  final String image;
  int quantity;

  CartItemModel({
    required this.id,
    required this.brand,
    required this.name,
    required this.price,
    required this.image,
    this.quantity = 1,
  });

  Map<String, dynamic> toJson() => {
    "productId": id,
    "productName": name,
    "unitPrice": price,
    "quantity": quantity,
  };
}