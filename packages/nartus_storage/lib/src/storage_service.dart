import 'package:nartus_storage/src/data/diary.dart';
import 'package:nartus_storage/src/data/user.dart';
import 'package:nartus_storage/src/impl/local/hive/hive_local_storage.dart';

part 'impl/local/local_storage_service_impl.dart';
part 'impl/cloud/cloud_storage_service_impl.dart';

enum StorageType { local, cloud }

class StorageException implements Exception {
  final String message;

  StorageException(this.message);
}

abstract class StorageService {
  StorageService._(this.type);

  factory StorageService(StorageType type) {
    switch (type) {
      case StorageType.local:
        return LocalStorageServiceImpl();
      case StorageType.cloud:
        return CloudStorageServiceImpl();
    }
  }

  /// implementation
  final StorageType type;

  /// Diary implementation
  Future<void> saveDiary(Diary diary);

  Future<DiaryCollection> readDiaryForMonth(DateTime month);

  Future<bool> deleteDiary(int timestamp);

  /// user implementation
  Future<void> saveUserDetail(User user);

  Future<User> getUserDetail(String uid);

  Future<bool> deleteUser(String uid);

  Future<bool> updateUserDetail(User user);
}
