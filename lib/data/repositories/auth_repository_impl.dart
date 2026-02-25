import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:getx_starter/core/errors/failures.dart';
import 'package:getx_starter/data/datasources/remote/auth_remote_datasource.dart';
import 'package:getx_starter/data/models/user_model.dart';
import 'package:getx_starter/domain/entities/user_entity.dart';
import 'package:getx_starter/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  const AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UserEntity>> login(
    String email,
    String password,
  ) async {
    try {
      final credential = await remoteDataSource.login(email, password);
      final user = credential.user;
      if (user == null) {
        return left(const AuthFailure('Login failed: no user returned.'));
      }
      return right(UserModel.fromFirebaseUser(user));
    } on FirebaseAuthException catch (e) {
      return left(AuthFailure(_mapFirebaseError(e.code)));
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register(
    String email,
    String password,
  ) async {
    try {
      final credential = await remoteDataSource.register(email, password);
      final user = credential.user;
      if (user == null) {
        return left(
          const AuthFailure('Registration failed: no user returned.'),
        );
      }
      return right(UserModel.fromFirebaseUser(user));
    } on FirebaseAuthException catch (e) {
      return left(AuthFailure(_mapFirebaseError(e.code)));
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return right(null);
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }

  @override
  UserEntity? getCurrentUser() {
    final user = remoteDataSource.currentUser;
    if (user == null) return null;
    return UserModel.fromFirebaseUser(user);
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found for this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'invalid-credential':
        return 'Invalid credentials. Check your email and password.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
