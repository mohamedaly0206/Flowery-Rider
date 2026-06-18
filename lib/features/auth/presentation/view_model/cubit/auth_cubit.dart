import 'package:equatable/equatable.dart';
import 'package:flowery_rider/config/base_cubit/base_cubit.dart';
import 'package:flowery_rider/config/base_event/base_event.dart';
import 'package:flowery_rider/features/auth/presentation/view_model/intent/auth_intent.dart';
import 'package:injectable/injectable.dart';

part '../state/auth_state.dart';

@injectable
class AuthCubit extends BaseCubit<AuthState, BaseEvent> {
  AuthCubit() : super(const AuthState());
  void authIntentHandler(AuthIntent intent) async {
    switch (intent) {}
  }
}
