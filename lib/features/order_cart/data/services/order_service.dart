import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/cart_item_model.dart';
import '../models/order_model.dart';

class OrderService {
  final Dio _dio = DioClient().dio;

  Future<String> createOrder(String userId, List<CartItemModel> cartItems) async {
    if (cartItems.isEmpty) throw Exception("Sepet boş");

    final orderItems = cartItems.map((item) => item.toJson()).toList();
    final total = cartItems.fold<double>(0, (sum, item) => sum + (item.price * item.quantity));

    final data = {
      "userId": userId,
      "total": total,
      "items": orderItems,
    };

    try {
      final response = await _dio.post(ApiConstants.ordersEndpoint, data: data);
      if (response.statusCode == 200) {
        return response.data['orderNumber'];
      }
      throw Exception('Sipariş oluşturulamadı: ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception('Sipariş Hatası: ${e.message}');
    }
  }

  Future<List<OrderModel>> getOrders(String userId) async {
    try {
      final response = await _dio.get('${ApiConstants.ordersEndpoint}/$userId');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final orders = data.map((e) => OrderModel.fromJson(e)).toList();
        return orders.reversed.toList();
      }
      throw Exception('Geçmiş siparişler getirilemedi');
    } on DioException catch (e) {
      throw Exception('Hata: ${e.message}');
    }
  }
}