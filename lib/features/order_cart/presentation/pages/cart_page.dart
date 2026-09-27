import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../ai_assistant/presentation/pages/ai_helper_page.dart';
import '../../../auth/data/services/auth_service.dart';
import '../../presentation/cubit/cart_cubit.dart';
import '../../../product/presentation/pages/home_page.dart';
import '../../../auth/presentation/pages/profile_page.dart';
import '../cubit/order_cubit.dart';
import 'order_history_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int _selectedIndex = 1;
  bool _orderCreated = false;
  String _orderNumber = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text("Sepetim", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      floatingActionButton: Transform.translate(
        offset: const Offset(0, 14),
        child: FloatingActionButton(
          backgroundColor: Colors.black,
          shape: const CircleBorder(),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const GeminiChatPage()));
            setState(() => _selectedIndex = 2);
          },
          child: const Icon(Icons.smart_toy, color: Colors.white, size: 32),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomAppBar(context),
      body: BlocListener<OrderCubit, OrderState>(
        listener: (context, state) {
          if (state is OrderSuccess) {
            context.read<CartCubit>().clearCart();
            setState(() {
              _orderCreated = true;
              _orderNumber = state.orderNumber;
            });
          } else if (state is OrderFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocBuilder<CartCubit, CartState>(
                builder: (context, cartState) {
                  final cartItems = cartState.items;

                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(14)),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Sepet Özeti", style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                            Icon(Icons.shopping_bag_outlined, color: Colors.white),
                          ],
                        ),
                      ),
                      if (cartItems.isEmpty)
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
                                const SizedBox(height: 20),
                                const Text("Sepetiniz Boş", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 10),
                                Text("Alışverişe başlamak için ürün ekleyin", style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  ),
                                  child: const Text("Alışverişe Başla", style: TextStyle(fontSize: 16, color: Colors.white)),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: ListView.builder(
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) {
                              final item = cartItems[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(color: Colors.grey.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 4)),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(14), bottomLeft: Radius.circular(14)),
                                      child: item.image.startsWith('http')
                                          ? Image.network(item.image, width: 100, height: 100, fit: BoxFit.cover)
                                          : Image.asset(item.image, width: 100, height: 100, fit: BoxFit.cover),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(item.brand, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                            Text(item.name, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                                            const SizedBox(height: 8),
                                            Text("${item.price.toStringAsFixed(2)} ₺", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: Column(
                                        children: [
                                          IconButton(
                                            onPressed: () => context.read<CartCubit>().incrementQuantity(index),
                                            icon: const Icon(Icons.add_circle_outline),
                                          ),
                                          Text(item.quantity.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                                          IconButton(
                                            onPressed: () => context.read<CartCubit>().decrementQuantity(index),
                                            icon: const Icon(Icons.remove_circle_outline),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      if (cartItems.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, -2)),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Toplam:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  Text("${cartState.totalPrice.toStringAsFixed(2)} ₺", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                                ],
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  onPressed: () async {
                                    final auth = AuthService();
                                    final localUser = await auth.getLocalUser();
                                    final userId = localUser?.id;

                                    if (userId == null || userId.toString().isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kullanıcı giriş yapmamış!")));
                                      return;
                                    }

                                    context.read<OrderCubit>().createOrder(userId.toString(), cartItems);
                                  },
                                  child: const Text("Satın Al", style: TextStyle(fontSize: 16, color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            if (_orderCreated)
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 15, offset: const Offset(0, 6)),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle_outline, size: 70, color: Colors.green[700]),
                      const SizedBox(height: 16),
                      const Text("Sipariş Başarıyla Oluşturuldu!", textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
                      const SizedBox(height: 10),
                      Text("Sipariş No: $_orderNumber", textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Colors.black54)),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() => _orderCreated = false);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text("Ana Sayfaya Dön"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      elevation: 10,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
                setState(() => _selectedIndex = 0);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.home, color: _selectedIndex == 0 ? Colors.black : Colors.grey),
                  const SizedBox(height: 2),
                  Text("Ana Sayfa", style: TextStyle(fontSize: 11, color: _selectedIndex == 0 ? Colors.black : Colors.grey)),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CartPage()));
                setState(() => _selectedIndex = 1);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_basket, color: _selectedIndex == 1 ? Colors.black : Colors.grey),
                  const SizedBox(height: 2),
                  Text("Sepetim", style: TextStyle(fontSize: 11, color: _selectedIndex == 1 ? Colors.black : Colors.grey)),
                ],
              ),
            ),
            const SizedBox(width: 40),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderHistoryPage()));
                setState(() => _selectedIndex = 3);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.list_alt, color: _selectedIndex == 3 ? Colors.black : Colors.grey),
                  const SizedBox(height: 2),
                  Text("Siparişler", style: TextStyle(fontSize: 11, color: _selectedIndex == 3 ? Colors.black : Colors.grey)),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage())),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person, color: _selectedIndex == 4 ? Colors.black : Colors.grey),
                  const SizedBox(height: 2),
                  Text("Profil", style: TextStyle(fontSize: 11, color: _selectedIndex == 4 ? Colors.black : Colors.grey, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}