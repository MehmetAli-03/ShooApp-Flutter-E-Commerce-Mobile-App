

import '../../data/models/category_model.dart';
import '../../data/models/product_model.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<ProductModel> products;
  final List<CategoryModel> categories;
  final int? selectedCategoryId;

  ProductLoaded({
    required this.products,
    required this.categories,
    this.selectedCategoryId,
  });

  ProductLoaded copyWith({
    List<ProductModel>? products,
    List<CategoryModel>? categories,
    int? selectedCategoryId,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      categories: categories ?? this.categories,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
    );
  }
}

class ProductFailure extends ProductState {
  final String errorMessage;
  ProductFailure(this.errorMessage);
}