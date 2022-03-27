import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant_list.dart';

import 'json_parsing_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('Fetch restaurant api', () {
    final restaurantTest = {
      "error": false,
      "message": "success",
      "count": 20,
      "restaurants": [
        {
          "id": "rqdv5juczeskfw1e867",
          "name": "Melting Pot",
          "description":
              "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...",
          "pictureId": "14",
          "city": "Medan",
          "rating": 4.2
        },
      ]
    };

    test('must contain a list of restaurant when api successful', () async {
      final api = ApiService();
      final client = MockClient();

      when(
        client.get(
          Uri.parse(ApiService.baseUrl + ApiService.list),
        ),
      ).thenAnswer((_) async => http.Response(jsonEncode(restaurantTest), 200));

      expect(await api.listRestaurant(client), isA<Restaurant>());
    });

    test('must contain a list of restaurant when api failed', () {
      //arrange
      final api = ApiService();
      final client = MockClient();

      when(
        client.get(
          Uri.parse(ApiService.baseUrl + ApiService.list),
        ),
      ).thenAnswer((_) async =>
          http.Response('Failed to load list of restaurants', 404));

      var restaurantActual = api.listRestaurant(client);
      expect(restaurantActual, throwsException);
    });

    test('must contain a list of restaurant when no internet connection', () {
      //arrange
      final api = ApiService();
      final client = MockClient();

      when(
        client.get(
          Uri.parse(ApiService.baseUrl + ApiService.list),
        ),
      ).thenAnswer(
          (_) async => throw const SocketException('No Internet Connection'));

      var restaurantActual = api.listRestaurant(client);
      expect(restaurantActual, throwsException);
    });
  });
}
