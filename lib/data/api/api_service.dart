import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/data/model/restaurant_list.dart';
import 'package:restaurant_app/data/model/restaurant_detail.dart';
import 'package:restaurant_app/data/model/restaurant_search.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev/';

  // API for Restaurant List
  Future<Restaurant> listRestaurant() async {
    final response = await http.get(Uri.parse(_baseUrl + "list"));
    if (response.statusCode == 200) {
      return Restaurant.fromJson(
          json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to Load Restaurant List');
    }
  }

  // API for Restaurant Detail
  Future<DetailRestaurant> detailRestaurant(String id) async {
    final response = await http.get(Uri.parse("${_baseUrl}detail/$id"));
    if (response.statusCode == 200) {
      return DetailRestaurant.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to Load Restaurant Detail');
    }
  }

  // API for Search Restaurant
  Future<RestaurantsSearch> searchingRestaurant(String query) async {
    final response = await http.get(Uri.parse("${_baseUrl}search?q=$query"));
    if (response.statusCode == 200) {
      return RestaurantsSearch.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to Load Seacrh Restaurant');
    }
  }
}
