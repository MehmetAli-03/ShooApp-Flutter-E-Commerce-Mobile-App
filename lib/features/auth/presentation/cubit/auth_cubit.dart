import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/login_model.dart';
import '../../data/models/register_model.dart';
import '../../data/services/auth_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;

  AuthCubit(this._authService) : super(AuthInitial());

  Future<void> checkAuthStatus() async {
    final user = await _authService.getLocalUser();
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      emit(AuthFailure("Lütfen tüm alanları doldurun."));
      return;
    }

    emit(AuthLoading());
    try {
      final user = await _authService.login(
        LoginModel(email: email, password: password),
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthFailure(e.toString().replaceAll("Exception: ", "")));
    }
  }

  Future<void> register(RegisterModel model) async {
    emit(AuthLoading());
    try {
      await _authService.register(model);
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthFailure(e.toString().replaceAll("Exception: ", "")));
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    emit(AuthUnauthenticated());
  }
}