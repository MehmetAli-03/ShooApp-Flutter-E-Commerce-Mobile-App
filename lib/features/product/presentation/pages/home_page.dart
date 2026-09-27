import 'package:ecommerceapp/features/product/presentation/pages/product_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/pages/profile_page.dart';
import '../../../order_cart/presentation/pages/cart_page.dart';
import '../../../order_cart/presentation/pages/order_history_page.dart';
import '../../data/models/category_model.dart';
import '../../data/models/product_model.dart';
import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';
import '../../../ai_assistant/presentation/pages/ai_helper_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().fetchHomeData();
  }

  void _openFilterSheet(List<CategoryModel> categories) {
    double minInput = 0;
    double maxInput = 10000;
    int? selectedCategory;
    String? selectedBrand;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (context, setStateSB) {
            Widget brandBox(String brandName, String imagePath, bool isSelected, VoidCallback onTap) {
              return GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? Colors.black : Colors.grey.shade300,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: isSelected ? Colors.black.withOpacity(0.05) : Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Image.asset(imagePath, fit: BoxFit.contain),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        brandName,
                        style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 20,
                  right: 20,
                  top: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Kategori", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 10),

                    DropdownButton<int>(
                      isExpanded: true,
                      value: selectedCategory,
                      hint: const Text("Kategori seç"),
                      items: categories.map((cat) {
                        return DropdownMenuItem(
                          value: cat.id,
                          child: Text(cat.name),
                        );
                      }).toList(),
                      onChanged: (value) => setStateSB(() => selectedCategory = value),
                    ),

                    const SizedBox(height: 20),
                    const Text("Marka", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 10),

                    SizedBox(
                      height: 250,
                      child: GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        children: [
                          brandBox("Prada", "assets/prada-logo.png", selectedBrand == "Prada", () => setStateSB(() => selectedBrand = "Prada")),
                          brandBox("Gucci", "assets/gucci.png", selectedBrand == "Gucci", () => setStateSB(() => selectedBrand = "Gucci")),
                          brandBox("Moncler", "assets/Moncler-Logo.png", selectedBrand == "Moncler", () => setStateSB(() => selectedBrand = "Moncler")),
                          brandBox("Guess", "assets/guess.png", selectedBrand == "Guess", () => setStateSB(() => selectedBrand = "Guess")),
                          brandBox("Tommy", "assets/tommy.png", selectedBrand == "Tommy", () => setStateSB(() => selectedBrand = "Tommy")),
                          brandBox("CK", "assets/ck.png", selectedBrand == "CK", () => setStateSB(() => selectedBrand = "CK")),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Text("Min Fiyat", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: "En düşük fiyat"),
                      onChanged: (val) => minInput = double.tryParse(val) ?? 0,
                    ),

                    const SizedBox(height: 20),
                    const Text("Max Fiyat", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: "En yüksek fiyat"),
                      onChanged: (val) => maxInput = double.tryParse(val) ?? 10000,
                    ),

                    const SizedBox(height: 25),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        this.context.read<ProductCubit>().filterProducts(
                          categoryId: selectedCategory,
                          minPrice: minInput,
                          maxPrice: maxInput,
                        );
                      },
                      child: const Text("Uygula", style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocConsumer<ProductCubit, ProductState>(
            listener: (context, state) {
              if (state is ProductFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage), backgroundColor: Colors.redAccent),
                );
              }
            },
            builder: (context, state) {
              if (state is ProductLoading) {
                return const Center(child: CircularProgressIndicator(color: Colors.black));
              }

              List<ProductModel> products = [];
              List<CategoryModel> categories = [];
              int? selectedCategoryId;

              if (state is ProductLoaded) {
                products = state.products;
                categories = state.categories;
                selectedCategoryId = state.selectedCategoryId;
              }

              return Column(
                children: [
                  // Arama ve Filtre Üst Barı
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search Keywords',
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () => context.read<ProductCubit>().fetchHomeData(),
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1))],
                                ),
                                child: const Icon(Icons.production_quantity_limits, size: 25),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => _openFilterSheet(categories),
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1))],
                                ),
                                child: const Icon(Icons.filter_alt, size: 25),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Kategori Listesi
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final bool isSelected = category.id == selectedCategoryId;

                        return GestureDetector(
                          onTap: () => context.read<ProductCubit>().filterByCategory(category.id),
                          child: _categoryItem(category.name, isSelected: isSelected),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Shop by Brands", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 21)),
                  ),
                  const SizedBox(height: 12),

                  // Markalar
                  SizedBox(
                    height: 60,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _brandItem("assets/prada-logo.png"),
                        _brandItem("assets/gucci.png"),
                        _brandItem("assets/Moncler-Logo.png"),
                        _brandItem("assets/ck.png"),
                        _brandItem("assets/guess.png"),
                        _brandItem("assets/tommy.png"),
                        _brandItem("assets/gant.png"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Reccomend for You..", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 21)),
                  ),
                  const SizedBox(height: 10),

                  // Ürün Grid Listesi
                  Expanded(
                    child: products.isEmpty
                        ? const Center(child: Text("Ürün bulunamadı."))
                        : GridView.builder(
                      itemCount: products.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 0.65,
                      ),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return _productItem(
                          brand: product.name,
                          description: product.description,
                          price: "${product.price}₺",
                          imagePath: product.imageUrl.isNotEmpty ? product.imageUrl : "assets/tshirt.webp",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductDetailPage(
                                  id: product.id,
                                  brand: product.name,
                                  description: product.description,
                                  price: "${product.price}₺",
                                  imagePath: product.imageUrl.isNotEmpty ? product.imageUrl : "assets/tshirt.webp",
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _categoryItem(String name, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 100,
      height: 25,
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Text(
        name,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isSelected ? Colors.white : Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _brandItem(String imagePath) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 130,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(imagePath, width: 60, height: 60, fit: BoxFit.cover),
          ),
        ],
      ),
    );
  }

  Widget _productItem({
    required String brand,
    required String description,
    required String price,
    required String imagePath,
    VoidCallback? onTap,
    bool isFavorite = false,
    VoidCallback? onFavoriteToggle,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 12, bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: imagePath.startsWith('http')
                      ? Image.network(imagePath, height: 160, width: double.infinity, fit: BoxFit.cover)
                      : Image.asset(imagePath, height: 160, width: double.infinity, fit: BoxFit.cover),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: InkWell(
                    onTap: onFavoriteToggle ?? () {},
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.black54,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(brand, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    price,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87),
                  ),
                ],
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
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage())),
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