// search_payload_model.dart

import 'package:equatable/equatable.dart';

/// Root payload model for hotel search request
class HotelSearchPayload extends Equatable {
  final SearchRequest getSearchResultListOfHotels;

  const HotelSearchPayload({required this.getSearchResultListOfHotels});

  Map<String, dynamic> toJson() {
    return {
      'getSearchResultListOfHotels': getSearchResultListOfHotels.toJson(),
    };
  }

  @override
  List<Object?> get props => [getSearchResultListOfHotels];
}

/// Search request wrapper
class SearchRequest extends Equatable {
  final SearchCriteria searchCriteria;

  const SearchRequest({required this.searchCriteria});

  Map<String, dynamic> toJson() {
    return {'searchCriteria': searchCriteria.toJson()};
  }

  @override
  List<Object?> get props => [searchCriteria];
}

/// Search criteria containing all search parameters
class SearchCriteria extends Equatable {
  final String checkIn;
  final String checkOut;
  final int rooms;
  final int adults;
  final int children;
  final String searchType;
  final List<String> searchQuery;
  final List<String> accommodation;
  final List<String> arrayOfExcludedSearchType;
  final String highPrice;
  final String lowPrice;
  final int limit;
  final List<String> preloaderList;
  final String currency;
  final int rid;

  const SearchCriteria({
    required this.checkIn,
    required this.checkOut,
    required this.rooms,
    required this.adults,
    required this.children,
    required this.searchType,
    required this.searchQuery,
    required this.accommodation,
    required this.arrayOfExcludedSearchType,
    required this.highPrice,
    required this.lowPrice,
    required this.limit,
    required this.preloaderList,
    required this.currency,
    required this.rid,
  });

  factory SearchCriteria.fromState({
    required DateTime checkInDate,
    required DateTime checkOutDate,
    required int rooms,
    required int adults,
    required int children,
    required String searchType,
    required List<String> searchQuery,
    required List<String> accommodation,
    required List<String> excludedSearchTypes,
    required double minPrice,
    required double maxPrice,
    required int itemsPerPage,
    required List<String> excludedHotels,
    required String currency,
    required int currentPage,
  }) {
    // Format dates as YYYY-MM-DD
    final formattedCheckIn =
        '${checkInDate.year}-${checkInDate.month.toString().padLeft(2, '0')}-${checkInDate.day.toString().padLeft(2, '0')}';
    final formattedCheckOut =
        '${checkOutDate.year}-${checkOutDate.month.toString().padLeft(2, '0')}-${checkOutDate.day.toString().padLeft(2, '0')}';

    // Map excluded search types from API format to exclude format
    final mappedExcludedTypes = excludedSearchTypes
        .map((type) => type.replaceAll('Search', '').toLowerCase())
        .toList();

    return SearchCriteria(
      checkIn: formattedCheckIn,
      checkOut: formattedCheckOut,
      rooms: rooms,
      adults: adults,
      children: children,
      searchType: searchType,
      searchQuery: searchQuery,
      accommodation: accommodation,
      arrayOfExcludedSearchType: mappedExcludedTypes,
      highPrice: maxPrice.toString(),
      lowPrice: minPrice.toString(),
      limit: itemsPerPage,
      preloaderList: excludedHotels,
      currency: currency,
      rid: currentPage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'checkIn': checkIn,
      'checkOut': checkOut,
      'rooms': rooms,
      'adults': adults,
      'children': children,
      'searchType': searchType,
      'searchQuery': searchQuery,
      'accommodation': accommodation,
      'arrayOfExcludedSearchType': arrayOfExcludedSearchType,
      'highPrice': highPrice,
      'lowPrice': lowPrice,
      'limit': limit,
      'preloaderList': preloaderList,
      'currency': currency,
      'rid': rid,
    };
  }

  @override
  List<Object?> get props => [
    checkIn,
    checkOut,
    rooms,
    adults,
    children,
    searchType,
    searchQuery,
    accommodation,
    arrayOfExcludedSearchType,
    highPrice,
    lowPrice,
    limit,
    preloaderList,
    currency,
    rid,
  ];

  @override
  String toString() {
    return '''SearchCriteria {
      checkIn: $checkIn,
      checkOut: $checkOut,
      rooms: $rooms,
      adults: $adults,
      children: $children,
      searchType: $searchType,
      searchQuery: $searchQuery,
      accommodation: $accommodation,
      arrayOfExcludedSearchType: $arrayOfExcludedSearchType,
      highPrice: $highPrice,
      lowPrice: $lowPrice,
      limit: $limit,
      preloaderList: $preloaderList,
      currency: $currency,
      rid: $rid,
    }''';
  }
}
