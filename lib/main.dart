import 'package:ecommerceapp/features/order_cart/data/services/order_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Cubit Import'ları
import 'features/product/presentation/cubit/product_cubit.dart';
import 'features/product/data/services/product_service.dart';
import 'features/order_cart/presentation/cubit/order_cubit.dart';
import 'features/order_cart/presentation/cubit/cart_cubit.dart'; // CartCubit'i import et
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/data/services/auth_service.dart';

// Page Import'ları
import 'features/product/presentation/pages/home_page.dart';
import 'features/order_cart/presentation/pages/cart_page.dart';
import 'features/order_cart/presentation/pages/order_history_page.dart';
import 'features/auth/presentation/pages/profile_page.dart';
import 'features/ai_assistant/presentation/pages/ai_helper_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductCubit>(
          create: (context) => ProductCubit(ProductService()),
        ),
        BlocProvider<OrderCubit>(
          create: (context) => OrderCubit(OrderService()),
        ),
        BlocProvider<CartCubit>( // CartCubit buraya eklendi
          create: (context) => CartCubit(),
        ),
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(AuthService()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: "/HomePage",
        routes: {
          "/HomePage": (context) => const HomePage(),
          "/CartPage": (context) => const CartPage(),
          "/OrdersPage": (context) => const OrderHistoryPage(),
          "/ProfilePage": (context) => const ProfilePage(),
          "/ChatPage": (context) => const GeminiChatPage(),
        },
      ),
    );
  }
}