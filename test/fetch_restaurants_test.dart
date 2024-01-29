import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/models/restaurant_list.dart';

import 'fetch_restaurants_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group("Fetch Restaurants", () {
    test("return an Restaurants if the http call completes successfully", () async {
      final client = MockClient();

      when(client
          .get(Uri.parse('${ApiService.baseUrl}list')))
          .thenAnswer((_) async =>
          http.Response('{"error": false, "message": "success", "count": 20}', 200));

      expect(await ApiService().getRestaurants(client: client), isA<RestaurantsResult>());
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();

      when(client
          .get(Uri.parse('${ApiService.baseUrl}list')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(ApiService().getRestaurants(client: client), throwsException);
    });
  });
}