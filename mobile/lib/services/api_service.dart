import 'dart:convert';
import 'package:http/http.dart' as http;

const String _base = 'http://127.0.0.1:8000';

class ApiService {
  static Future<Map<String, dynamic>> chat({
    required String message,
    String userId = 'uid_001',
    double userLat = 25.3960,
    double userLng = 68.3578,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$_base/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'message': message,
          'user_id': userId,
          'user_lat': userLat,
          'user_lng': userLng,
        }),
      ).timeout(const Duration(seconds: 30));
      if (res.statusCode == 200) return jsonDecode(res.body);
      throw Exception('Server error ${res.statusCode}');
    } catch (e) {
      return {
        'response': 'معذرت! سرور سے رابطہ نہیں ہو سکا۔ براہ کرم دوبارہ کوشش کریں۔',
        'error': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> bookService({
    required String providerId,
    required String slot,
    required Map<String, dynamic> pricing,
    required bool isUrgent,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$_base/book'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'provider_id': providerId,
          'slot': slot,
          'pricing': pricing,
          'is_urgent': isUrgent,
        }),
      ).timeout(const Duration(seconds: 15));
      if (res.statusCode == 200) return jsonDecode(res.body);
      throw Exception('Server error ${res.statusCode}');
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  static Future<List<Map<String, dynamic>>> getArtifacts() async {
    try {
      final res = await http.get(Uri.parse('$_base/artifacts'))
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return List<Map<String, dynamic>>.from(data['artifacts'] ?? []);
      }
    } catch (_) {}
    return [];
  }

  static Future<Map<String, dynamic>> submitReview({
    required String bookingId,
    required double rating,
    required String comment,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$_base/review'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'booking_id': bookingId, 'rating': rating, 'comment': comment}),
      ).timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) return jsonDecode(res.body);
    } catch (_) {}
    return {'status': 'error'};
  }

  static Future<Map<String, dynamic>> submitDispute({
    required String bookingId,
    required String issue,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$_base/dispute'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'booking_id': bookingId, 'issue': issue}),
      ).timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) return jsonDecode(res.body);
    } catch (_) {}
    return {'status': 'error'};
  }
}
