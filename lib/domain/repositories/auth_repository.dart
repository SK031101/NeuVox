import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, bool>> loginWithMicrosoft();
  Future<Either<Failure, void>> logout();
  Future<bool> isLoggedIn();
}
