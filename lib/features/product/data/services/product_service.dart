import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/category_model.dart';
import '../models/comment_model.dart';
import '../models/product_model.dart';

class ProductService {
  final Dio _dio = DioClient().dio;

  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _dio.get(ApiConstants.productsEndpoint);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => ProductModel.fromJson(e)).toList();
      }
      throw Exception('Ürünler alınamadı.');
    } on DioException catch (e) {
      throw Exception('Dio Hatası: ${e.message}');
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _dio.get(ApiConstants.categoriesEndpoint);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => CategoryModel.fromJson(e)).toList();
      }
      throw Exception('Kategoriler alınamadı.');
    } on DioException catch (e) {
      throw Exception('Dio Hatası: ${e.message}');
    }
  }

  Future<List<ProductModel>> getProductsByCategory(int categoryId) async {
    try {
      final response = await _dio.get('${ApiConstants.productsEndpoint}/byCategory/$categoryId');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => ProductModel.fromJson(e)).toList();
      }
      throw Exception('Kategoriye ait ürünler getirilemedi.');
    } on DioException catch (e) {
      throw Exception('Dio Hatası: ${e.message}');
    }
  }

  Future<List<ProductModel>> filterProducts({
    int? categoryId,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.productsEndpoint}/filter',
        queryParameters: {
          if (categoryId != null) "categoryId": categoryId,
          if (minPrice != null) "minPrice": minPrice,
          if (maxPrice != null) "maxPrice": maxPrice,
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((x) => ProductModel.fromJson(x)).toList();
      }
      throw Exception("Filtreleme başarısız.");
    } on DioException catch (e) {
      throw Exception('Dio Hatası: ${e.message}');
    }
  }

  Future<List<CommentModel>> getComments(int productId) async {
    try {
      final response = await _dio.get('${ApiConstants.commentsEndpoint}/$productId');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => CommentModel.fromJson(e)).toList();
      }
      throw Exception('Yorumlar yüklenemedi.');
    } on DioException catch (e) {
      throw Exception('Dio Hatası: ${e.message}');
    }
  }

  Future<CommentModel> addComment({
    required String userName,
    required int productId,
    required String text,
    required int rating,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.commentsEndpoint,
        data: {
          "userName": userName,
          "productId": productId,
          "text": text,
          "rating": rating,
        },
      );
      return CommentModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Yorum eklenirken hata: ${e.message}');
    }
  }
}