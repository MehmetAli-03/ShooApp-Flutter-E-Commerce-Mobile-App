import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/category_model.dart';
import '../../data/models/product_model.dart';
import '../../data/services/product_service.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductService _productService;

  ProductCubit(this._productService) : super(ProductInitial());

  List<CategoryModel> _cachedCategories = [];

  Future<void> fetchHomeData() async {
    emit(ProductLoading());
    try {
      final products = await _productService.getProducts();
      _cachedCategories = await _productService.getCategories();

      emit(ProductLoaded(
        products: products,
        categories: _cachedCategories,
        selectedCategoryId: null,
      ));
    } catch (e) {
      emit(ProductFailure(e.toString().replaceAll("Exception: ", "")));
    }
  }

  Future<void> filterByCategory(int categoryId) async {
    emit(ProductLoading());
    try {
      final products = await _productService.getProductsByCategory(categoryId);
      emit(ProductLoaded(
        products: products,
        categories: _cachedCategories,
        selectedCategoryId: categoryId,
      ));
    } catch (e) {
      emit(ProductFailure(e.toString().replaceAll("Exception: ", "")));
    }
  }

  Future<void> filterProducts({
    int? categoryId,
    double? minPrice,
    double? maxPrice,
  }) async {
    emit(ProductLoading());
    try {
      final products = await _productService.filterProducts(
        categoryId: categoryId,
        minPrice: minPrice,
        maxPrice: maxPrice,
      );
      emit(ProductLoaded(
        products: products,
        categories: _cachedCategories,
        selectedCategoryId: categoryId,
      ));
    } catch (e) {
      emit(ProductFailure(e.toString().replaceAll("Exception: ", "")));
    }
  }
}