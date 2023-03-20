import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interactive_diary/features/writediary/bloc/write_diary_cubit.dart';
import 'package:interactive_diary/service_locator/service_locator.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nartus_storage/nartus_storage.dart';

import 'write_diary_cubit_test.mocks.dart';

@GenerateMocks(<Type>[StorageService])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final MockStorageService storageService = MockStorageService();

  setUpAll(() => ServiceLocator.instance.registerSingleton<StorageService>(storageService));
  
  group('Test save text diary', () {
    tearDown(() => reset(storageService));

    blocTest<WriteDiaryCubit, WriteDiaryState>(
      'given storage service, when saveDiary, then save diary to storage service',
      build: () => WriteDiaryCubit(),
      act: (WriteDiaryCubit bloc) => bloc.saveTextDiary(
          title: 'title',
          textContent: 'textContent',
          latLng: const LatLng(lat: 0.0, long: 0.0)),
      setUp: () => when(storageService.saveDiary(argThat(isA<Diary>())))
          .thenAnswer((_) => Future<void>.value(null)),
      seed: () => WriteDiaryInitial(),
      expect: () => <TypeMatcher<WriteDiaryState>>[
        isA<WriteDiaryStart>(),
        isA<WriteDiarySuccess>()
      ],
      verify: (WriteDiaryCubit bloc) =>
          verify(storageService.saveDiary(argThat(isA<Diary>()))),
    );
  });
}
