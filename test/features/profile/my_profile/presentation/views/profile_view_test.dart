import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flowery_rider/config/base_event/base_event.dart';
import 'package:flowery_rider/features/profile/domain/entities/driver_profile_entity.dart';
import 'package:flowery_rider/features/profile/presentation/profile/view_model/cubit/profile_cubit.dart';
import 'package:flowery_rider/features/profile/presentation/profile/view_model/state/profile_state.dart';
import 'package:flowery_rider/features/profile/presentation/profile/views/profile_view.dart';
import 'package:flowery_rider/features/profile/presentation/profile/widgets/custom_profile_empty_state.dart';
import 'package:flowery_rider/features/profile/presentation/profile/widgets/profile_info_card.dart';
import 'package:flowery_rider/l10n/app_localizations.dart';

class MockProfileCubit extends MockCubit<ProfileState>
    implements ProfileCubit {}

void main() {
  late MockProfileCubit mockProfileCubit;
  late StreamController<BaseEvent> eventStreamController;

  final tDriverProfile = DriverProfileEntity(
    id: "1",
    country: "Egypt",
    firstName: "Ahmed",
    lastName: "Khodary",
    vehicleType: "676b31a45d05310ca82657ac",
    vehicleNumber: "123456",
    vehicleLicense: "license.png",
    nid: "12345678901234",
    nidImg: "nid.png",
    email: "ahmedmohamedcom@gmail.com",
    gender: "male",
    phone: "01289757455",
    photo: "photo.png",
    role: "driver",
  );

  setUp(() {
    mockProfileCubit = MockProfileCubit();
    eventStreamController = StreamController<BaseEvent>.broadcast();
    when(
      () => mockProfileCubit.eventStream,
    ).thenAnswer((_) => eventStreamController.stream);
  });

  tearDown(() {
    eventStreamController.close();
  });

  Widget makeTestableWidget() {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: BlocProvider<ProfileCubit>.value(
        value: mockProfileCubit,
        child: const ProfileView(),
      ),
    );
  }

  group('ProfileView Widget Tests', () {
    testWidgets(
      '1. Should display SpinKitFadingCircle when state is loading and data is null',
      (WidgetTester tester) async {
        when(() => mockProfileCubit.state).thenReturn(
          const ProfileState(isLoading: true, data: null, languageCode: 'en'),
        );

        await tester.pumpWidget(makeTestableWidget());
        expect(find.byType(SpinKitFadingCircle), findsOneWidget);
      },
    );

    testWidgets(
      '2. Should display CustomProfileEmptyState when data is null and loading completes',
      (WidgetTester tester) async {
        when(() => mockProfileCubit.state).thenReturn(
          const ProfileState(isLoading: false, data: null, languageCode: 'en'),
        );

        await tester.pumpWidget(makeTestableWidget());
        expect(find.byType(CustomProfileEmptyState), findsOneWidget);
      },
    );

    testWidgets(
      '3. Should display driver data card and version text when profile loads successfully',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 1920);
        tester.view.devicePixelRatio = 1.0;

        when(() => mockProfileCubit.state).thenReturn(
          ProfileState(
            isLoading: false,
            data: tDriverProfile,
            languageCode: 'en',
          ),
        );

        await tester.pumpWidget(makeTestableWidget());
        await tester.pumpAndSettle();

        expect(find.byType(ProfileInfoCard), findsNWidgets(2));

        final versionFinder = find.text('v 6.3.0 - (446)');
        await tester.ensureVisible(versionFinder);
        expect(versionFinder, findsOneWidget);

        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
      },
    );
  });
}
