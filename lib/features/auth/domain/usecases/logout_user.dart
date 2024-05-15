import 'package:ewallet/core/error/failures.dart';
import 'package:ewallet/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/common/usecase/usecase.dart';

class UserLogout implements UseCase<String, NoParams> {
  final AuthRepository authRepository;
  UserLogout(this.authRepository);

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    var response = await authRepository.logout();
    print("UserLogout USecase Response $response");
    return response;
  }
}
