import 'package:dio_cache_interceptor_file_store/dio_cache_interceptor_file_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

final mapCacheStoreProvider = FutureProvider<FileCacheStore>((ref) async {
  final dir = await getTemporaryDirectory();
  return FileCacheStore('${dir.path}/map_cache');
});
