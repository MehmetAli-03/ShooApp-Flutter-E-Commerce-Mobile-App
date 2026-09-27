import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/login_model.dart';
import '../models/register_model.dart';
import '../models/user_model.dart';

class AuthService {
  final Dio _dio = DioClient().dio;

  Future<UserModel> login(LoginModel model) async {
    try {
      final response = await _dio.post(
        ApiConstants.loginEndpoint,
        data: model.toJson(),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final userMap = (data is Map && data.containsKey('user'))
            ? data['user']
            : data;

        if (userMap is Map<String, dynamic>) {
          final user = UserModel.fromJson(userMap);
          await saveLocalUser(user);
          return user;
        }
      }
      throw Exception('Giriş başarısız, yanıt biçimi geçersiz.');
    } on DioException catch (e) {
      throw Exception(e.response?.data?.toString() ?? 'Bağlantı hatası oluştu.');
    }
  }

  Future<String> register(RegisterModel model) async {
    try {
      final response = await _dio.post(
        ApiConstants.registerEndpoint,
        data: model.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return "Kayıt başarıyla tamamlandı. (success)";
      }
      return "Kayıt oluşturulamadı.";
    } on DioException catch (e) {
      return e.response?.data?.toString() ?? 'Kayıt sırasında hata oluştu.';
    } catch (e) {
      return 'Beklenmeyen bir hata oluştu: $e';
    }
  }

  Future<void> saveLocalUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", true);
    await prefs.setString("userId", user.id);
    await prefs.setString("fullName", user.fullName);
    await prefs.setString("email", user.email);
    await prefs.setString("phoneNumber", user.phoneNumber);
    await prefs.setString("address", user.address);
  }

  Future<UserModel?> getLocalUser() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool("isLoggedIn") ?? false;
    if (!isLoggedIn) return null;

    return UserModel(
      id: prefs.getString("userId") ?? "",
      fullName: prefs.getString("fullName") ?? "",
      email: prefs.getString("email") ?? "",
      phoneNumber: prefs.getString("phoneNumber") ?? "",
      address: prefs.getString("address") ?? "",
    );
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}