import 'package:flowery_rider/features/auth/data/remote/api_client/auth_api_client.dart';
import 'package:flowery_rider/features/auth/data/remote/data_sources/auth_remote_data_source_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRemoteDataSourceContract)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSourceContract {
  final AuthApiClient _authApiClient;

  AuthRemoteDataSourceImpl(this._authApiClient);
}
