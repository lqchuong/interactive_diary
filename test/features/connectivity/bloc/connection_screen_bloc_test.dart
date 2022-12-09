import 'package:bloc_test/bloc_test.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:interactive_diary/features/connectivity/bloc/connection_screen_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nartus_connectivity/nartus_connectivity.dart';

import 'connection_screen_bloc_test.mocks.dart';

@GenerateMocks(<Type>[ConnectivityService])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final MockConnectivityService service = MockConnectivityService();

  group('event change connectivity', () {
    blocTest(
      'There is not network connection, turn on wifi, then return true',
      build: () => ConnectionScreenBloc(connectivity: service),
      setUp: (() {
        when(service.onConnectivityChange)
            .thenAnswer((Invocation value) => Stream<bool>.value(true));
      }),
      act: (ConnectionScreenBloc bloc) =>
          bloc.add(ChangeConnectConnectivityEvent()),
      expect: () =>
          <TypeMatcher<ChangeConnectedState>>[isA<ChangeConnectedState>()],
    );
    blocTest(
      'There is network connection, turn off wifi, then return false',
      build: () => ConnectionScreenBloc(connectivity: service),
      setUp: (() {
        when(service.onConnectivityChange)
            .thenAnswer((Invocation value) => Stream<bool>.value(false));
      }),
      act: (ConnectionScreenBloc bloc) =>
          bloc.add(ChangeConnectConnectivityEvent()),
      expect: () =>
          <TypeMatcher<ChangeDisonnectedState>>[isA<ChangeDisonnectedState>()],
    );
  });

  test('verify all events has empty props', () {
    final ChangeConnectConnectivityEvent event =
        ChangeConnectConnectivityEvent();

    expect(event.props.length, 0);
  });
}
