class ProductModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String categoryName;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.categoryName,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      categoryName: json['categoryName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'imageUrl': imageUrl,
    'categoryName': categoryName,
  };
}