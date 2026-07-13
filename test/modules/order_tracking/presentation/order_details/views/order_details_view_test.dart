import 'package:bloc_test/bloc_test.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/order_entity.dart';
import 'package:flowery_rider/modules/order_tracking/presentation/order_details/view_model/cubit/order_details_cubit.dart';
import 'package:flowery_rider/modules/order_tracking/presentation/order_details/view_model/intent/order_details_intent.dart';
import 'package:flowery_rider/modules/order_tracking/presentation/order_details/view_model/state/order_details_state.dart';
import 'package:flowery_rider/modules/order_tracking/presentation/order_details/views/order_details_view.dart';
import 'package:flowery_rider/modules/order_tracking/presentation/order_details/widgets/order_action_button.dart';
import 'package:flowery_rider/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOrderDetailsCubit extends MockCubit<OrderDetailsState>
    implements OrderDetailsCubit {}

class MockOrderEntity extends Mock implements OrderEntity {}

void main() {
  late MockOrderDetailsCubit mockOrderDetailsCubit;
  late MockOrderEntity mockOrder;

  setUpAll(() {
    registerFallbackValue(const OrderDetailsState());
    registerFallbackValue(UpdateOrderDetailsStatuesIntent());
    registerFallbackValue(InitTrackingIntent(const OrderEntity()));
    registerFallbackValue(const OrderEntity());
  });

  setUp(() {
    mockOrderDetailsCubit = MockOrderDetailsCubit();
    mockOrder = MockOrderEntity();

    //---------------- Cubit Stubs ----------------//
    when(() => mockOrderDetailsCubit.state).thenReturn(
      OrderDetailsState(
        order: mockOrder,
        formattedDate: '02 Jul 2026, 10:00 AM',
      ),
    );

    when(() => mockOrderDetailsCubit.stream)
        .thenAnswer((_) => const Stream<OrderDetailsState>.empty());

    when(() => mockOrderDetailsCubit.eventStream)
        .thenAnswer((_) => const Stream.empty());

    when(() => mockOrderDetailsCubit.handleOrderDetailsIntent(any()))
        .thenReturn(null);

    //---------------- Order Entity Stubs ----------------//
    when(() => mockOrder.id).thenReturn('order_123');
    when(() => mockOrder.createdAt)
        .thenReturn(DateTime.parse('2026-07-02T10:00:00.000Z'));
    when(() => mockOrder.totalPrice).thenReturn(150);
    when(() => mockOrder.paymentType).thenReturn('Cash');
    when(() => mockOrder.store).thenReturn(null);
    when(() => mockOrder.user).thenReturn(null);
    when(() => mockOrder.shippingAddress).thenReturn(null);
    when(() => mockOrder.orderItems).thenReturn([]);
  });

  Widget buildTestableWidget() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<OrderDetailsCubit>.value(
        value: mockOrderDetailsCubit,
        child: OrderDetailsView(order: mockOrder),
      ),
    );
  }

  group('OrderDetailsView', () {
    testWidgets('renders order details correctly and sends InitTrackingIntent', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      // Verify that the view sends the correct Intent upon initialization
      verify(() => mockOrderDetailsCubit.handleOrderDetailsIntent(
            any(that: isA<InitTrackingIntent>()),
          )).called(1);

      expect(find.text('Cash'), findsOneWidget);
      expect(find.textContaining('150'), findsOneWidget);
    });

    testWidgets('tapping action button sends UpdateOrderDetailsStatuesIntent', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      final button = find.byType(OrderActionButton);
      expect(button, findsOneWidget);

      await tester.tap(button);
      await tester.pumpAndSettle();

      verify(
        () => mockOrderDetailsCubit.handleOrderDetailsIntent(
          any(that: isA<UpdateOrderDetailsStatuesIntent>()),
        ),
      ).called(1);
    });
  });
}