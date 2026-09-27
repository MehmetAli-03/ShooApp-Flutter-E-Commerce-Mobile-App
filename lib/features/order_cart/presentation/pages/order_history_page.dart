import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/data/services/auth_service.dart';
import '../cubit/order_cubit.dart';
import '../../../product/presentation/pages/home_page.dart';
import '../../../ai_assistant/presentation/pages/ai_helper_page.dart';
import '../../../auth/presentation/pages/profile_page.dart';
import 'cart_page.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  final Map<int, bool> _expandedMap = {};
  int _selectedIndex = 3;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders() async {
    final auth = AuthService();
    final localUser = await auth.getLocalUser();
    final userId = localUser?.id;

    if (userId != null && userId.toString().isNotEmpty) {
      context.read<OrderCubit>().fetchOrders(userId.toString());
    }
  }

  Widget _buildOrderStatusIcon(int index) {
    if (index == 0) {
      return Column(
        children: const [
          Icon(Icons.local_shipping, color: Colors.orange, size: 28),
          SizedBox(height: 4),
          Text("Kargoya Verildi", style: TextStyle(fontSize: 12, color: Colors.orange)),
        ],
      );
    } else {
      return Column(
        children: const [
          Icon(Icons.check_circle, color: Colors.green, size: 28),
          SizedBox(height: 4),
          Text("Teslim Edildi", style: TextStyle(fontSize: 12, color: Colors.green)),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Geçmiş Siparişler", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
      ),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderFailure) {
            return Center(child: Text("Hata: ${state.errorMessage}"));
          } else if (state is OrderHistoryLoaded) {
            final orders = state.orders;
            if (orders.isEmpty) {
              return const Center(child: Text("Geçmiş sipariş bulunamadı"));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final isExpanded = _expandedMap[index] ?? false;

                return Card(
                  color: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
                              child: const Icon(Icons.shopping_cart, size: 32, color: Colors.black87),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                order.orderNumber,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "${order.total.toStringAsFixed(2)} ₺",
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                                ),
                                const SizedBox(height: 4),
                                InkWell(
                                  onTap: () => setState(() => _expandedMap[index] = !isExpanded),
                                  child: Icon(isExpanded ? Icons.expand_less : Icons.expand_more, color: Colors.black54, size: 28),
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            _buildOrderStatusIcon(index),
                          ],
                        ),
                        if (isExpanded) ...[
                          const Divider(color: Colors.grey, height: 20, thickness: 1),
                          Column(
                            children: order.items.map<Widget>((item) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(item.productName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87)),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text("Adet: ${item.quantity}", style: const TextStyle(fontSize: 14, color: Colors.grey)),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text("${item.unitPrice.toStringAsFixed(2)} ₺", textAlign: TextAlign.end, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const GeminiChatPage()));
          setState(() => _selectedIndex = 2);
        },
        child: const Icon(Icons.smart_toy, color: Colors.white, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomAppBar(context),
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
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OrderHistoryPage()));
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
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
                setState(() => _selectedIndex = 4);
              },
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