import 'package:flutter/widgets.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/models/restaurant_detail.dart';
import 'package:restaurant_app/data/models/restaurant_list.dart';
import 'package:http/http.dart' as http;

import '../util/result_state.dart';

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantProvider({required this.apiService}) {
    fetchRestaurants();
  }

  late RestaurantsResult _restaurantsResult;
  DetailRestaurantResult? _detailRestaurantResult;
  late ResultState _state;
  String _message = "";

  String get message => _message;

  ResultState get state => _state;

  RestaurantsResult get restaurantsResults => _restaurantsResult;

  DetailRestaurantResult? get detailRestaurantResult => _detailRestaurantResult;

  Future<dynamic> fetchRestaurants({String? query}) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurants = query == null
          ? await apiService.getRestaurants(client: http.Client())
          : await apiService.getRestaurants(
              client: http.Client(), query: query);
      if (restaurants.restaurants!.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = "Tidak ada data";
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurantsResult = restaurants;
      }
    } on Exception catch (_) {
      _state = ResultState.error;
      notifyListeners();
      return _message = "Gagal mendapatkan data";
    }
  }

  Future<dynamic> fetchDetailRestaurant(String id) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurant = await apiService.getDetailRestaurant(id);
      if (restaurant.restaurant.id.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = "Tidak ada data";
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _detailRestaurantResult = restaurant;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = "Gagal mendapatkan data";
    }
  }
}
