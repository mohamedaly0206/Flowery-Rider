import 'package:flowery_rider/features/auth/data/remote/data_sources/auth_remote_data_source_contract.dart';
import 'package:flowery_rider/features/auth/domain/repositories/auth_repo_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRepoContract)
class AuthRepoImpl implements AuthRepoContract {
  final AuthRemoteDataSourceContract _authRemoteDataSourceContract;

  AuthRepoImpl(this._authRemoteDataSourceContract);
}
