import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../../data/models/user_model.dart';
import 'login_page.dart';
import '../../../ai_assistant/presentation/pages/ai_helper_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _tabIndex = 0;

  final TextEditingController _oldPass = TextEditingController();
  final TextEditingController _newPass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  ImageProvider<Object> _getProfilePhoto(String fullName) {
    final name = fullName.toLowerCase();
    if (name.contains("mehmet")) {
      return const AssetImage('assets/mehmet.jpg');
    } else if (name.contains("samet")) {
      return const AssetImage('assets/samet.jpg');
    } else {
      return const AssetImage('assets/erkek23.jpeg');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
          );
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        UserModel? user;
        if (state is AuthAuthenticated) {
          user = state.user;
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 18.0, top: 12.0),
                child: IconButton(
                  icon: const Icon(Icons.logout, color: Colors.black, size: 33),
                  onPressed: () => context.read<AuthCubit>().logout(),
                ),
              ),
            ],
          ),
          floatingActionButton: Transform.translate(
            offset: const Offset(0, 14),
            child: FloatingActionButton(
              backgroundColor: Colors.black,
              shape: const CircleBorder(),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GeminiChatPage()),
                );
              },
              child: const Icon(Icons.smart_toy, color: Colors.white, size: 32),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: _buildBottomBar(),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: _getProfilePhoto(user?.fullName ?? ""),
                    backgroundColor: Colors.grey[300],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user?.fullName ?? "Bilinmiyor",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? "",
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 24),

                  // Sekme Butonları
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _tabIndex == 0 ? Colors.black : Colors.grey[300],
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(12)),
                            ),
                          ),
                          onPressed: () => setState(() => _tabIndex = 0),
                          child: Text(
                            "Kullanıcı Bilgileri",
                            style: TextStyle(
                              color: _tabIndex == 0 ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _tabIndex == 1 ? Colors.black : Colors.grey[300],
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(topRight: Radius.circular(12)),
                            ),
                          ),
                          onPressed: () => setState(() => _tabIndex = 1),
                          child: Text(
                            "Parola Bilgileri",
                            style: TextStyle(
                              color: _tabIndex == 1 ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Sekme İçerikleri
                  _tabIndex == 0
                      ? _buildUserInfoTab(user)
                      : _buildPasswordTab(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserInfoTab(UserModel? user) {
    return Column(
      children: [
        _infoTile(Icons.phone, "Telefon", user?.phoneNumber ?? "-"),
        _infoTile(Icons.location_on, "Adres", user?.address ?? "-"),
      ],
    );
  }

  Widget _buildPasswordTab() {
    return Column(
      children: [
        TextField(
          controller: _oldPass,
          obscureText: true,
          decoration: const InputDecoration(labelText: "Mevcut Şifre"),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _newPass,
          obscureText: true,
          decoration: const InputDecoration(labelText: "Yeni Şifre"),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _confirmPass,
          obscureText: true,
          decoration: const InputDecoration(labelText: "Yeni Şifre Tekrar"),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Şifre güncelleme isteği gönderildi")),
            );
          },
          child: const Text("Şifreyi Güncelle", style: TextStyle(color: Colors.white)),
        )
      ],
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
    );
  }

  Widget _buildBottomBar() {
    return BottomNavigationBar(
      currentIndex: 4,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Ana Sayfa"),
        BottomNavigationBarItem(icon: Icon(Icons.category), label: "Kategoriler"),
        BottomNavigationBarItem(icon: SizedBox.shrink(), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: "Siparişler"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
      ],
    );
  }
}