import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/cart_item_model.dart';

class CartState {
  final List<CartItemModel> items;
  CartState({required this.items});

  double get totalPrice => items.fold(0, (sum, item) => sum + (item.price * item.quantity));
}

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartState(items: []));

  void addToCart(CartItemModel newItem) {
    final updatedList = List<CartItemModel>.from(state.items);
    final existingIndex = updatedList.indexWhere((item) => item.id == newItem.id);

    if (existingIndex != -1) {
      updatedList[existingIndex].quantity += newItem.quantity;
    } else {
      updatedList.add(newItem);
    }
    emit(CartState(items: updatedList));
  }

  void incrementQuantity(int index) {
    final updatedList = List<CartItemModel>.from(state.items);
    updatedList[index].quantity++;
    emit(CartState(items: updatedList));
  }

  void decrementQuantity(int index) {
    final updatedList = List<CartItemModel>.from(state.items);
    if (updatedList[index].quantity > 1) {
      updatedList[index].quantity--;
    } else {
      updatedList.removeAt(index);
    }
    emit(CartState(items: updatedList));
  }

  void clearCart() {
    emit(CartState(items: []));
  }
}