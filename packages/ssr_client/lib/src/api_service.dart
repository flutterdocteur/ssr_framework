import 'dart:convert';
import 'package:angulardart/angulardart.dart';
import 'package:http/http.dart';

/// API service for client-server communication
@Injectable()
class ApiService {
  final Client _http;

  ApiService(this._http);

  /// Fetch data from API
  Future<Map<String, dynamic>> get(String path) async {
    final response = await _http.get(Uri.parse(path));
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('API error: ${response.statusCode}');
  }

  /// Post data to API
  Future<Map<String, dynamic>> post(String path, [Map<String, dynamic>? data]) async {
    final response = await _http.post(
      Uri.parse(path),
      headers: {'Content-Type': 'application/json'},
      body: data != null ? jsonEncode(data) : null,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('API error: ${response.statusCode}');
  }
}
