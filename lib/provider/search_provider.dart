import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant_search.dart';
import 'package:restaurant_app/utils/result_state.dart';

class SearchProvider extends ChangeNotifier {
  final ApiService apiService;

  SearchProvider({required this.apiService}) {
    fetchAllRestaurantSearch(query);
  }

  RestaurantsSearch? _resultRestaurantsSearch;
  String _message = '';
  String _query = '';
  ResultState? _state;

  String get message => _message;
  String get query => _query;

  RestaurantsSearch? get result => _resultRestaurantsSearch;

  ResultState? get state => _state;

  Future<dynamic> fetchAllRestaurantSearch(String query) async {
    try {
      _state = ResultState.loading;
      _query = query;

      final restaurantSearch = await apiService.searchingRestaurant(query);
      if (restaurantSearch.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Restaurant or Menu\nCould Not Be Found';
      } else {
        _state = ResultState.hasData;

        notifyListeners();
        return _resultRestaurantsSearch = restaurantSearch;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
