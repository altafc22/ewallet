import 'package:ewallet/core/common/entities/auth/auth_entity.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/common/usecase/usecase.dart';
import '../repository/auth_repository.dart';

class CheckAuth implements UseCase<AuthEntity, NoParams> {
  final AuthRepository authRepository;
  CheckAuth(this.authRepository);

  @override
  Future<Either<Failure, AuthEntity>> call(NoParams params) async {
    return await authRepository.checkAuth();
  }
}
