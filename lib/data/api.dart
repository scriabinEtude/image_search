import 'dart:convert';

import 'package:image_search/model/photo.dart';
import 'package:http/http.dart' as http;

class PixabayApi {
  static const baseUrl = 'https://pixabay.com/api/';
  static const key = '24950244-6d390dac86c0a77fb258181dc';

  Future<List<Photo>> fetch(String query) async {
    final response = await http.get(
        Uri.parse("$baseUrl?key=$key&q=$query&image_type=photo&pretty=true"));

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    Iterable hits = jsonResponse['hits'];
    return hits.map((e) => Photo.fromJson(e).toList()).toList();
  }
}
