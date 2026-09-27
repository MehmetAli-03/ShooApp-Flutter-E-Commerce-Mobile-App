import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/cart_item_model.dart';
import '../../data/models/order_model.dart';
import '../../data/services/order_service.dart';


abstract class OrderState {}

class OrderInitial extends OrderState {}
class OrderLoading extends OrderState {}
class OrderSuccess extends OrderState {
  final String orderNumber;
  OrderSuccess(this.orderNumber);
}
class OrderHistoryLoaded extends OrderState {
  final List<OrderModel> orders;
  OrderHistoryLoaded(this.orders);
}
class OrderFailure extends OrderState {
  final String errorMessage;
  OrderFailure(this.errorMessage);
}

class OrderCubit extends Cubit<OrderState> {
  final OrderService _orderService;

  OrderCubit(this._orderService) : super(OrderInitial());

  Future<void> createOrder(String userId, List<CartItemModel> items) async {
    emit(OrderLoading());
    try {
      final orderNumber = await _orderService.createOrder(userId, items);
      emit(OrderSuccess(orderNumber));
    } catch (e) {
      emit(OrderFailure(e.toString().replaceAll("Exception: ", "")));
    }
  }

  Future<void> fetchOrders(String userId) async {
    emit(OrderLoading());
    try {
      final orders = await _orderService.getOrders(userId);
      emit(OrderHistoryLoaded(orders));
    } catch (e) {
      emit(OrderFailure(e.toString().replaceAll("Exception: ", "")));
    }
  }
}