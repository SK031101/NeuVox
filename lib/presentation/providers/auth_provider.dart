import 'package:flutter/material.dart';
import '../../domain/repositories/auth_repository.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthProvider(this._authRepository);

  AuthStatus _status = AuthStatus.initial;
  AuthStatus get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> checkAuthStatus() async {
    _status = AuthStatus.loading;
    notifyListeners();

    final isLoggedIn = await _authRepository.isLoggedIn();
    if (isLoggedIn) {
      _status = AuthStatus.authenticated;
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<void> login() async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _authRepository.loginWithMicrosoft();

    result.fold(
      (failure) {
        _status = AuthStatus.error;
        _errorMessage = "Login Failed. Please try again."; 
        notifyListeners();
      },
      (success) {
        _status = AuthStatus.authenticated;
        notifyListeners();
      },
    );
  }

  Future<void> logout() async {
    await _authRepository.logout();
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
