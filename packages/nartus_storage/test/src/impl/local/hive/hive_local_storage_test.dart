// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nartus_storage/nartus_storage.dart';
import 'package:nartus_storage/src/impl/local/hive/hive_adapters.dart';
import 'package:nartus_storage/src/impl/local/hive/hive_local_storage.dart';
import 'package:hive/src/box_collection/box_collection_stub.dart'
    as implementation;

import 'hive_local_storage_test.mocks.dart';

@GenerateMocks(<Type>[HiveHelper, CollectionBox, Box])
final MockCollectionBox<HiveDiary> collectionBox =
    MockCollectionBox<HiveDiary>();

class MockBoxCollection extends Mock implements BoxCollection {
  @override
  Future<CollectionBox<HiveDiary>> openBox<HiveDiary>(String name,
          {bool preload = false,
          implementation.CollectionBox<HiveDiary> Function(
                  String p1, BoxCollection p2)?
              boxCreator}) =>
      Future<CollectionBox<HiveDiary>>.value(
          collectionBox as CollectionBox<HiveDiary>);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel =
      MethodChannel('plugins.flutter.io/path_provider_macos');

  channel.setMockMethodCallHandler((MethodCall methodCall) async {
    return '/';
  });

  const int timestamp = 12345678;
  const String boxName = '011970';
  const String name = 'diariesByMonth';

  final Diary diary = Diary(
      timestamp: timestamp,
      latLng: const LatLng(lat: 0.0, long: 0.0),
      title: 'title',
      contents: <Content>[],
      update: timestamp);

  final MockHiveHelper hiveHelper = MockHiveHelper();
  final MockBoxCollection boxCollection = MockBoxCollection();
  final HiveDiary hiveDiary = HiveDiary.fromDiary(diary);

  test(
      'given timestamp for diary not found, when delete diary, then return false',
      () async {
    when(hiveHelper.open(name, <String>{boxName}, path: '/')).thenAnswer(
        (Invocation realInvocation) =>
            Future<BoxCollection>.value(boxCollection));
    when(collectionBox.get(timestamp.toString())).thenAnswer(
        (Invocation realInvocation) => Future<HiveDiary?>.value(null));

    HiveLocalStorage hiveLocalStorage =
        HiveLocalStorage(hiveHelper: hiveHelper);

    final bool result = await hiveLocalStorage.deleteDiary(timestamp);

    expect(result, false);

    // ensure to close collection
    verify(boxCollection.close()).called(1);
  });

  test(
      'given timestamp for diary is found, when delete diary, then return true',
      () async {
    when(hiveHelper.open(name, <String>{boxName}, path: '/')).thenAnswer(
        (Invocation realInvocation) =>
            Future<BoxCollection>.value(boxCollection));
    when(collectionBox.get(timestamp.toString())).thenAnswer(
        (Invocation realInvocation) => Future<HiveDiary?>.value(hiveDiary));

    HiveLocalStorage hiveLocalStorage =
        HiveLocalStorage(hiveHelper: hiveHelper);

    final bool result = await hiveLocalStorage.deleteDiary(timestamp);

    expect(result, true);

    // ensure that diary is deleted in collectionBox
    verify(collectionBox.delete(timestamp.toString())).called(1);

    // ensure to close collection
    verify(boxCollection.close()).called(1);
  });

  test(
      'given diary for month is not available, when readDiaryForMonth, then return empty list',
      () async {
    when(hiveHelper.open(name, <String>{'112022'}, path: '/')).thenAnswer(
        (Invocation realInvocation) =>
            Future<BoxCollection>.value(boxCollection));
    when(collectionBox.getAllValues()).thenAnswer((Invocation realInvocation) =>
        Future<Map<String, HiveDiary>>.value(<String, HiveDiary>{}));

    HiveLocalStorage hiveLocalStorage =
        HiveLocalStorage(hiveHelper: hiveHelper);

    DateTime month = DateTime(2022, 11, 11);
    final DiaryCollection result =
        await hiveLocalStorage.readDiaryForMonth(month);

    expect(result.month, '112022');
    expect(result.diaries.length, 0);

    // ensure to close collection
    verify(boxCollection.close()).called(1);
  });

  test(
      'given diary for month has single entry, when readDiaryForMonth, then return list with 1 entry',
      () async {
    when(hiveHelper.open(name, <String>{'112022'}, path: '/')).thenAnswer(
        (Invocation realInvocation) =>
            Future<BoxCollection>.value(boxCollection));
    when(collectionBox.getAllValues()).thenAnswer((Invocation realInvocation) =>
        Future<Map<String, HiveDiary>>.value(
            <String, HiveDiary>{'1234566': hiveDiary}));

    HiveLocalStorage hiveLocalStorage =
        HiveLocalStorage(hiveHelper: hiveHelper);

    DateTime month = DateTime(2022, 11, 11);
    final DiaryCollection result =
        await hiveLocalStorage.readDiaryForMonth(month);

    expect(result.month, '112022');
    expect(result.diaries.length, 1);

    // ensure to close collection
    verify(boxCollection.close()).called(1);
  });

  test(
      'when saveDiary, then ensure to close collection box, and save diary into hive collection',
      () async {
    when(hiveHelper.open(name, <String>{'011970'}, path: '/')).thenAnswer(
        (Invocation realInvocation) =>
            Future<BoxCollection>.value(boxCollection));

    HiveLocalStorage hiveLocalStorage =
        HiveLocalStorage(hiveHelper: hiveHelper);

    await hiveLocalStorage.saveDiary(diary);

    // TODO test to save diary and save/update user can't be done
    // Issue filed: https://github.com/dart-lang/mockito/issues/590
    verify(collectionBox.put(
        timestamp.toString(), argThat(isInstanceOf<HiveDiary>())));
    // verify(boxCollection.close()).called(1);
  });

  test(
      'given user is in storage, when delete user, then successfully delete user',
      () async {
    const User user =
        User(uid: 'uid', firstName: 'firstName', lastName: 'lastName');
    final HiveUser hiveUser = HiveUser.fromUser(user);
    final Box<HiveUser> userBox = MockBox<HiveUser>();
    when(hiveHelper.openBox<HiveUser>('user', path: '/')).thenAnswer(
        (Invocation realInvocation) => Future<Box<HiveUser>>.value(userBox));
    when(userBox.get('uid'))
        .thenAnswer((Invocation realInvocation) => hiveUser);

    HiveLocalStorage hiveLocalStorage =
        HiveLocalStorage(hiveHelper: hiveHelper);

    final bool result = await hiveLocalStorage.deleteUser('uid');

    expect(result, true);

    verify(userBox.delete('uid'));
    verify(userBox.close());
  });

  test('given user is in not storage, when delete user, then return false',
      () async {
    final Box<HiveUser> userBox = MockBox<HiveUser>();
    when(hiveHelper.openBox<HiveUser>('user', path: '/')).thenAnswer(
        (Invocation realInvocation) => Future<Box<HiveUser>>.value(userBox));
    when(userBox.get('uid')).thenAnswer((Invocation realInvocation) => null);

    HiveLocalStorage hiveLocalStorage =
        HiveLocalStorage(hiveHelper: hiveHelper);

    final bool result = await hiveLocalStorage.deleteUser('uid');

    expect(result, false);

    verifyNever(userBox.delete('uid'));
    verify(userBox.close());
  });

  test(
      'given user is in not storage, when save user, then successfully save user',
      () async {
    const User user =
        User(uid: 'uid', firstName: 'firstName', lastName: 'lastName');
    final MockBox<HiveUser> userBox = MockBox<HiveUser>();
    when(hiveHelper.openBox<HiveUser>('user', path: '/')).thenAnswer(
        (Invocation realInvocation) => Future<Box<HiveUser>>.value(userBox));
    when(userBox.get('uid')).thenAnswer((Invocation realInvocation) => null);

    HiveLocalStorage hiveLocalStorage =
        HiveLocalStorage(hiveHelper: hiveHelper);

    await hiveLocalStorage.saveUserDetail(user);

    // TODO test to save diary and save/update user can't be done
    // Issue filed: https://github.com/dart-lang/mockito/issues/590
    verify(userBox.put('uid', argThat(isInstanceOf<HiveUser>()))).called(1);
    // ensure to close the box
    verify(userBox.close());
  });

  test('given user is in storage, when save user, then throw error', () async {
    const User user =
        User(uid: 'uid', firstName: 'firstName', lastName: 'lastName');
    final Box<HiveUser> userBox = MockBox<HiveUser>();
    final HiveUser hiveUser = HiveUser.fromUser(user);
    when(hiveHelper.openBox<HiveUser>('user', path: '/')).thenAnswer(
        (Invocation realInvocation) => Future<Box<HiveUser>>.value(userBox));
    when(userBox.get('uid'))
        .thenAnswer((Invocation realInvocation) => hiveUser);

    HiveLocalStorage hiveLocalStorage =
        HiveLocalStorage(hiveHelper: hiveHelper);

    expect(() async => await hiveLocalStorage.saveUserDetail(user),
        throwsA(isA<HiveError>()));

    // TODO test to save diary and save/update user can't be done
    // Issue filed: https://github.com/dart-lang/mockito/issues/590
    // verify(userBox.put('uid', argThat(isInstanceOf<HiveUser>()))).called(1);
  });

  test(
      'given user is in not storage, when update user details, then do not update',
      () async {
    const User user =
        User(uid: 'uid', firstName: 'firstName', lastName: 'lastName');
    final MockBox<HiveUser> userBox = MockBox<HiveUser>();
    when(hiveHelper.openBox<HiveUser>('user', path: '/')).thenAnswer(
        (Invocation realInvocation) => Future<Box<HiveUser>>.value(userBox));
    when(userBox.get('uid')).thenAnswer((Invocation realInvocation) => null);

    HiveLocalStorage hiveLocalStorage =
        HiveLocalStorage(hiveHelper: hiveHelper);

    await hiveLocalStorage.updateUserDetail(user);

    // TODO test to save diary and save/update user can't be done
    // Issue filed: https://github.com/dart-lang/mockito/issues/590
    verifyNever(userBox.put('uid', argThat(isInstanceOf<HiveUser>())));

    // ensure to close the box
    verify(userBox.close());
  });

  test('given user is in storage, when update user details, then do not update',
      () async {
    const User user =
        User(uid: 'uid', firstName: 'firstName', lastName: 'lastName');
    final HiveUser hiveUser = HiveUser.fromUser(user);
    final MockBox<HiveUser> userBox = MockBox<HiveUser>();
    when(hiveHelper.openBox<HiveUser>('user', path: '/')).thenAnswer(
        (Invocation realInvocation) => Future<Box<HiveUser>>.value(userBox));
    when(userBox.get('uid'))
        .thenAnswer((Invocation realInvocation) => hiveUser);

    HiveLocalStorage hiveLocalStorage =
        HiveLocalStorage(hiveHelper: hiveHelper);

    await hiveLocalStorage.updateUserDetail(user);

    // TODO test to save diary and save/update user can't be done
    // Issue filed: https://github.com/dart-lang/mockito/issues/590
    verify(userBox.put('uid', argThat(isInstanceOf<HiveUser>()))).called(1);

    // ensure to close the box
    verify(userBox.close());
  });

  test('given user is not in storage, when get user details, then throw error',
      () async {
    final Box<HiveUser> userBox = MockBox<HiveUser>();
    when(hiveHelper.openBox<HiveUser>('user', path: '/')).thenAnswer(
        (Invocation realInvocation) => Future<Box<HiveUser>>.value(userBox));
    when(userBox.get('uid')).thenAnswer((Invocation realInvocation) => null);

    HiveLocalStorage hiveLocalStorage =
        HiveLocalStorage(hiveHelper: hiveHelper);

    expect(() async => await hiveLocalStorage.getUserDetail('uid'),
        throwsA(isA<HiveError>()));
  });

  test('given user is in storage, when get user details, then return user',
      () async {
    const User user =
        User(uid: 'uid', firstName: 'firstName', lastName: 'lastName');
    final HiveUser hiveUser = HiveUser.fromUser(user);
    final Box<HiveUser> userBox = MockBox<HiveUser>();
    when(hiveHelper.openBox<HiveUser>('user', path: '/')).thenAnswer(
        (Invocation realInvocation) => Future<Box<HiveUser>>.value(userBox));
    when(userBox.get('uid'))
        .thenAnswer((Invocation realInvocation) => hiveUser);

    HiveLocalStorage hiveLocalStorage =
        HiveLocalStorage(hiveHelper: hiveHelper);

    final User result = await hiveLocalStorage.getUserDetail('uid');

    expect(result.uid, 'uid');
    expect(result.firstName, 'firstName');
    expect(result.lastName, 'lastName');
  });
}
