import 'package:neuvox/core/error/failures.dart';
import 'package:dartz/dartz.dart';

// Domain: Repository Interface
abstract class AuthRepository {
  Future<Either<Failure, bool>> loginWithMicrosoft();
  Future<Either<Failure, void>> logout();
  Future<bool> isLoggedIn();
}

// Data: Implementation (Mock)
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Either<Failure, bool>> loginWithMicrosoft() async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Simulate success
    return const Right(true);
  }

  @override
  Future<Either<Failure, void>> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const Right(null);
  }

  @override
  Future<bool> isLoggedIn() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return false; // Always return false to force login for demo
  }
}
