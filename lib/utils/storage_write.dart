import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const FlutterSecureStorage storage = FlutterSecureStorage();
writeStorage(List<Map<String, String?>> keyValuePairs) async {
  for (var pair in keyValuePairs) {
    String key = pair.keys.first; // 첫 번째 키 가져오기
    String? value = pair.values.first; // 해당 키에 대한 값 가져오기
    await storage.write(key: key, value: value);
  }
}
