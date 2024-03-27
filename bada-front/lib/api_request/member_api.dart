import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MembersApi {
  static const String _baseUrl = 'https://j10b207.p.ssafy.io/api/members';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> deleteMember() async {
    try {
      String? accessToken = await _storage.read(key: 'accessToken');

      if (accessToken == null) {
        throw Exception('Access token not found');
      }

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final response = await http.delete(Uri.parse(_baseUrl), headers: headers);

      if (response.statusCode == 200) {
        print('Member deleted successfully');
      } else {
        throw Exception('Failed to delete member');
      }
    } catch (e) {
      print(e.toString());
      throw Exception('Error deleting member');
    }
  }
}
