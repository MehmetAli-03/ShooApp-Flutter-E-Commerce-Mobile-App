import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../auth/data/services/auth_service.dart';
import '../../../order_cart/data/models/cart_item_model.dart';
import '../../../order_cart/presentation/cubit/cart_cubit.dart';
import '../../../order_cart/presentation/pages/cart_page.dart';
import '../../data/models/comment_model.dart';
import '../../data/services/product_service.dart';
import '../../../ai_assistant/presentation/pages/ai_helper_page.dart';
import 'home_page.dart';

class ProductDetailPage extends StatefulWidget {
  final int id;
  final String brand;
  final String description;
  final String price;
  final String imagePath;

  const ProductDetailPage({
    super.key,
    required this.id,
    required this.brand,
    required this.description,
    required this.price,
    required this.imagePath,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String selectedSize = "M";
  int _selectedIndex = 0;

  final TextEditingController _commentController = TextEditingController();
  int _selectedRating = 5;
  List<CommentModel> _comments = [];

  final ProductService _productService = ProductService();
  final AuthService _auth = AuthService();

  bool _loadingComments = true;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    setState(() => _loadingComments = true);
    try {
      final result = await _productService.getComments(widget.id);
      setState(() {
        _comments = result;
        _loadingComments = false;
      });
    } catch (e) {
      setState(() => _loadingComments = false);
      debugPrint("Yorumlar yüklenirken hata: $e");
    }
  }

  Future<void> _addComment() async {
    final user = await _auth.getLocalUser();
    final userName = user?.fullName ?? "Bilinmeyen";

    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    try {
      final comment = await _productService.addComment(
        userName: userName,
        productId: widget.id,
        text: text,
        rating: _selectedRating,
      );

      setState(() {
        _comments.insert(0, comment);
        _commentController.clear();
        _selectedRating = 5;
      });
    } catch (e) {
      debugPrint("Yorum eklenirken hata: $e");
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.brand,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
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
      bottomNavigationBar: buildBottomBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
              child: widget.imagePath.startsWith('http')
                  ? Image.network(widget.imagePath, width: double.infinity, height: 370, fit: BoxFit.cover)
                  : Image.asset(widget.imagePath, width: double.infinity, height: 370, fit: BoxFit.cover),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildBrandAndRating(),
                  const SizedBox(height: 25),
                  buildSizeSelector(),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        double price = double.tryParse(widget.price.replaceAll("₺", "").trim()) ?? 0;

                        context.read<CartCubit>().addToCart(
                          CartItemModel(
                            id: widget.id,
                            brand: widget.brand,
                            name: widget.brand,
                            price: price,
                            image: widget.imagePath,
                          ),
                        );

                        Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage()));
                      },
                      child: const Text("Sepete Ekle", style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 35),
                  const Text("Müşteri Yorumları", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Yorum Yap", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 10),
                        Row(
                          children: List.generate(5, (index) {
                            return IconButton(
                              onPressed: () => setState(() => _selectedRating = index + 1),
                              icon: Icon(index < _selectedRating ? Icons.star : Icons.star_border, color: Colors.amber, size: 28),
                            );
                          }),
                        ),
                        TextField(
                          controller: _commentController,
                          maxLines: 2,
                          decoration: InputDecoration(
                            hintText: "Yorumunuzu yazın...",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                            suffixIcon: IconButton(icon: const Icon(Icons.send, color: Colors.black), onPressed: _addComment),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _loadingComments
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                    children: _comments.map((c) => _commentItem(c.userName, c.rating, c.text, c.createdAt)).toList(),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBottomBar() {
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
              onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CartPage())),
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
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage()));
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
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person, color: _selectedIndex == 4 ? Colors.black : Colors.grey),
                const SizedBox(height: 2),
                Text("Profil", style: TextStyle(fontSize: 11, color: _selectedIndex == 4 ? Colors.black : Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBrandAndRating() {
    double averageRating = 0;
    if (_comments.isNotEmpty) {
      averageRating = _comments.map((c) => c.rating).reduce((a, b) => a + b) / _comments.length;
    }

    double price = double.tryParse(widget.price.replaceAll("₺", "").trim()) ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.brand, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            Row(
              children: [
                ...List.generate(5, (index) {
                  return Icon(index < averageRating.round() ? Icons.star : Icons.star_border, color: Colors.amber, size: 22);
                }),
                const SizedBox(width: 6),
                Text(averageRating.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(width: 4),
                Text("(${_comments.length})", style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text("₺${price.toStringAsFixed(2)}", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
      ],
    );
  }

  Widget buildSizeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Beden Seçin", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        const SizedBox(height: 12),
        Row(
          children: ["S", "M", "L", "XL"].map((size) {
            final isSelected = selectedSize == size;
            return GestureDetector(
              onTap: () => setState(() => selectedSize = size),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 10),
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 3))] : [],
                ),
                alignment: Alignment.center,
                child: Text(size, style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _commentItem(String userName, int rating, String text, DateTime createdAt) {
    final date = DateFormat('dd MMM yyyy').format(createdAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(backgroundColor: Colors.grey[300], child: const Icon(Icons.person, color: Colors.black54)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(index < rating ? Icons.star : Icons.star_border, color: Colors.amber, size: 18);
                  }),
                ),
                const SizedBox(height: 6),
                Text(text, style: const TextStyle(fontSize: 13, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}