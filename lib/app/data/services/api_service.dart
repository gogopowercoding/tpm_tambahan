import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class ApiService {
  static const String _baseUrl = 'https://api.spaceflightnewsapi.net/v4';

  static Future<List<Article>> fetchList(String type, {int limit = 15}) async {
    final url = Uri.parse('$_baseUrl/$type/?limit=$limit');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      return results.map((item) => Article.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat data: ${response.statusCode}');
    }
  }

  static Future<Article> fetchDetail(String type, int id) async {
    final url = Uri.parse('$_baseUrl/$type/$id/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Article.fromJson(data);
    } else {
      throw Exception('Gagal memuat detail: ${response.statusCode}');
    }
  }
}