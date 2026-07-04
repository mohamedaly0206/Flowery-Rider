import 'package:bloc_test/bloc_test.dart';
import 'package:flowery_rider/config/base_state/base_state.dart';
import 'package:flowery_rider/features/order_tracking/domain/entities/response/pending_orders_entity.dart';
import 'package:flowery_rider/features/order_tracking/presentation/home/view_model/cubit/home_cubit.dart';
import 'package:flowery_rider/features/order_tracking/presentation/home/view_model/state/home_state.dart';
import 'package:flowery_rider/features/order_tracking/presentation/home/views/home_view.dart';
import 'package:flowery_rider/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// 1. Create a Mock class for the HomeCubit
class MockHomeCubit extends MockCubit<HomeState> implements HomeCubit {}

void main() {
  late MockHomeCubit mockHomeCubit;
  setUp(() {
    mockHomeCubit = MockHomeCubit();

    // 1. Define a default initial state
    const initialState = HomeState(
      getPendingOrdersState: BaseState(
        isLoading: false,
      ), // Or whatever your default is
    );

    // 2. Tell the mock to always return this state if no other stub is provided
    when(() => mockHomeCubit.state).thenReturn(initialState);

    // 3. Keep your existing stream stub
    when(
      () => mockHomeCubit.eventStream,
    ).thenAnswer((_) => const Stream.empty());
  });

  // A helper function to wrap the HomeView with necessary providers
  Widget buildTestableWidget(Widget widget) {
    return MaterialApp(
      // Provide the actual localizations so AppLocalizations.of(context) doesn't fail
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<HomeCubit>.value(value: mockHomeCubit, child: widget),
    );
  }

  group('HomeView Widget Tests', () {
    testWidgets('displays SpinKitFadingCircle when state is loading', (
      WidgetTester tester,
    ) async {
      // Arrange: Stub the state to simulate a loading scenario
      when(() => mockHomeCubit.state).thenReturn(
        const HomeState(getPendingOrdersState: BaseState(isLoading: true)),
      );
      // Stub the event stream to return an empty stream to satisfy initState
      when(
        () => mockHomeCubit.eventStream,
      ).thenAnswer((_) => const Stream.empty());

      // Act: Build the widget
      await tester.pumpWidget(buildTestableWidget(const HomeView()));

      // Assert: Verify the loading spinner is on the screen
      expect(find.byType(SpinKitFadingCircle), findsOneWidget);
      // Verify the empty list text is NOT there
      expect(find.byType(RefreshIndicator), findsNothing);
    });

    testWidgets('displays No Orders Found when orders list is empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget(const HomeView()));
      await tester.pumpAndSettle();

      // Arrange: Stub the state to simulate a successful API call with no data
      when(() => mockHomeCubit.state).thenReturn(
        HomeState(
          getPendingOrdersState: BaseState(
            isLoading: false,
            data: PendingOrdersEntity(orders: []),
          ),
        ),
      );
      when(
        () => mockHomeCubit.eventStream,
      ).thenAnswer((_) => const Stream.empty());

      // Act: Build the widget
      await tester.pumpWidget(buildTestableWidget(const HomeView()));

      // Wait for any localized text to render
      await tester.pumpAndSettle();
      final context = tester.element(find.byType(HomeView));
      final expectedText = AppLocalizations.of(context)!.noOrdersFound;
      // Assert: Verify the RefreshIndicator and empty state view are present
      expect(find.byType(RefreshIndicator), findsOneWidget);

      // We look for the localized text. Note: Depending on your default locale in the test,
      // you might need to check for the exact English or Arabic string here.
      // Assuming English is the default:
      expect(find.text(expectedText), findsOneWidget);
    });
  });
}
