import 'package:dartz/dartz.dart';
import 'package:getx_starter/core/errors/failures.dart';
import 'package:getx_starter/features/auth/domain/entites/user_entity.dart';
import 'package:getx_starter/features/auth/domain/repos/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  const RegisterUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(String email, String password) {
    return repository.register(email, password);
  }
}
