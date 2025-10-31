import 'dart:developer';

import 'package:assignment_travaly/core/services/dio/dio_client.dart';
import 'package:assignment_travaly/presentation/home/data/models/search_autocomplete_model.dart';

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
            "searchType": ["byCity", "byState"],
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
      log(e.toString());
      rethrow;
    }
  }
}
