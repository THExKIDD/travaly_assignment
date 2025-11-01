import 'dart:developer';

import 'package:assignment_travaly/core/services/dio/dio_client.dart';
import 'package:assignment_travaly/presentation/home/data/models/search_autocomplete_model.dart';
import 'package:assignment_travaly/presentation/home/data/models/search_results_model.dart';

class HotelSearchRepo {
  final dioClient = DioClient();

  Future<AutocompleteData> fetchSearchSuggestions({
    required String query,
  }) async {
    try {
      final response = await dioClient.post(
        'searchAutoComplete',
        data: {
          "searchAutoComplete": {
            "inputText": query,
            "searchType": [
              "byCity",
              "byState",
              "byCountry",
              "byRandom",
              "byPropertyName",
            ],
            "limit": 10,
          },
        },
      );

      if (response.statusCode == 200) {
        return AutocompleteData.fromJson(response.data['data']);
      } else {
        throw Exception(
          'Failed to fetch search suggestions with status code ${response.statusCode} and message ${response.statusMessage}',
        );
      }
    } catch (e) {
      log('Error fetching autocomplete: $e');
      rethrow;
    }
  }

  Future<HotelSearchResponse> searchHotels({
    required Map<String, dynamic> searchPayload,
  }) async {
    try {
      log('Searching hotels with payload: $searchPayload');

      final response = await dioClient.post(
        'getSearchResultListOfHotels',
        data: searchPayload,
      );

      if (response.statusCode == 200) {
        log('Search successful: ${response.data}');
        return HotelSearchResponse.fromJson(response.data);
      } else {
        throw Exception(
          'Failed to fetch hotel search results with status code ${response.statusCode} and message ${response.statusMessage}',
        );
      }
    } catch (e) {
      log('Error searching hotels: $e');
      rethrow;
    }
  }
}
