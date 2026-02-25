import 'package:dartz/dartz.dart';
import 'package:getx_starter/core/errors/failures.dart';
import 'package:getx_starter/domain/entities/user_entity.dart';
import 'package:getx_starter/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  const LoginUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(String email, String password) {
    return repository.login(email, password);
  }
}
