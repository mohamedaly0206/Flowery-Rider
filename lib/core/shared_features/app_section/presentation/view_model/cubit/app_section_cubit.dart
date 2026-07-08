import 'package:flowery_rider/config/base_cubit/base_cubit.dart';
import 'package:flowery_rider/config/base_event/base_event.dart';
import 'package:flowery_rider/core/shared_features/app_section/presentation/view_model/intent/app_section_intent.dart';
import 'package:flowery_rider/core/shared_features/app_section/presentation/view_model/state/app_section_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class AppSectionCubit extends BaseCubit<AppSectionState, BaseEvent> {
  AppSectionCubit() : super(const AppSectionState());
  void appSectionHandleIntent(AppSectionIntent intent) {
    switch (intent) {
      case AppSectionIndexChangedIntent():
        updateCurrentIndex(intent.index);
    }
  }

  void updateCurrentIndex(int index) {
    emit(state.copyWith(currentIndex: index));
  }
}
