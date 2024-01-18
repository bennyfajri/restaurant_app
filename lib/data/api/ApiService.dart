import 'dart:convert';

import 'package:restaurant_app/data/models/restaurant_detail.dart';

import '../models/restaurant_list.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = "https://restaurant-api.dicoding.dev/";

  Future<RestaurantsResult> getRestaurants({String? query}) async {
    final response = query == null
        ? await http.get(Uri.parse("${_baseUrl}list"))
        : await http.get(Uri.parse("${_baseUrl}search?q=$query"));

    if (response.statusCode == 200) {
      return RestaurantsResult.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load restaurants list");
    }
  }

  Future<DetailRestaurantResult> getDetailRestaurant(String id) async {
    final response = await http.get(Uri.parse("${_baseUrl}detail/$id"));
    if (response.statusCode == 200) {
      return DetailRestaurantResult.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load top headlines");
    }
  }
}
