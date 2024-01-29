import 'dart:convert';

import 'package:restaurant_app/data/models/restaurant_detail.dart';

import '../models/restaurant_list.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://restaurant-api.dicoding.dev/";

  Future<RestaurantsResult> getRestaurants(
      {required http.Client client, String? query}) async {
    final response = query == null
        ? await client.get(Uri.parse("${baseUrl}list"))
        : await client.get(Uri.parse("${baseUrl}search?q=$query"));

    if (response.statusCode == 200) {
      return RestaurantsResult.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load restaurants list");
    }
  }

  Future<DetailRestaurantResult> getDetailRestaurant(String id) async {
    final response = await http.get(Uri.parse("${baseUrl}detail/$id"));
    if (response.statusCode == 200) {
      return DetailRestaurantResult.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load top headlines");
    }
  }
}
