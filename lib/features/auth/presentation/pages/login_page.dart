import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'register_page.dart';
import 'profile_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Giriş başarılı ✅")),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage), backgroundColor: Colors.redAccent),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Shoply KLK",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: Colors.black,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Tarzını yansıt, alışverişe başla 🛍️",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Email Input
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "E-posta adresi",
                      prefixIcon: const Icon(Icons.email_outlined),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Şifre Input
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Şifre",
                      prefixIcon: const Icon(Icons.lock_outline),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Şifremi unuttum?",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Giriş Yap Butonu
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: isLoading
                          ? null
                          : () {
                        context.read<AuthCubit>().login(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                        );
                      },
                      child: isLoading
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                          : const Text(
                        "Giriş Yap",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    children: const [
                      Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text("VEYA", style: TextStyle(color: Colors.grey)),
                      ),
                      Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  _socialButton(
                    imagePath: 'assets/google.png',
                    text: "Google ile devam et",
                    backgroundColor: const Color(0xFFDB4437),
                    textColor: Colors.white,
                  ),
                  const SizedBox(height: 12),

                  _socialButton(
                    imagePath: 'assets/apple1.png',
                    text: "Apple ile devam et",
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Hesabın yok mu? ",
                        style: TextStyle(color: Colors.black54, fontSize: 13),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const RegisterPage()),
                          );
                        },
                        child: const Text(
                          "Kayıt Ol",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _socialButton({
    required String imagePath,
    required String text,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            height: 25,
            width: 25,
            color: textColor == Colors.white ? Colors.white : null,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 15,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}