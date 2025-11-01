import 'package:assignment_travaly/presentation/home/data/models/hotel_search_payload.dart';
import 'package:assignment_travaly/presentation/home/data/models/search_autocomplete_model.dart';
import 'package:equatable/equatable.dart';

import '../data/models/search_results_model.dart';

enum SearchStatus { initial, loading, loadingMore, success, failure, empty }

enum AutocompleteStatus { initial, loading, success, failure }

class HotelSearchState extends Equatable {
  // Search Query
  final String searchQuery;
  final List<String> searchQueries; // Multiple queries from autocomplete

  // Date Selection
  final DateTime? checkInDate;
  final DateTime? checkOutDate;

  // Guest and Room Information
  final int rooms;
  final int adults;
  final int children;

  // Filters
  final List<String> selectedAccommodationTypes;
  final double minPrice;
  final double maxPrice;

  // Search Results
  final List<Hotel> searchResults;
  final SearchStatus searchStatus;
  final String? errorMessage;

  // Pagination
  final int currentPage; // Using 'rid' from API (0-based)
  final bool hasMoreData;
  final int itemsPerPage;

  // Navigation
  final bool isSearchMode;

  // Additional Configuration
  final String searchType;
  final List<String> excludedSearchTypes;
  final List<String> excludedHotels;
  final String currency;

  //auto-complete
  final List<AutocompleteItem> autocompleteResults;
  final AutocompleteStatus autocompleteStatus;

  const HotelSearchState({
    this.searchQuery = '',
    this.searchQueries = const [],
    this.checkInDate,
    this.checkOutDate,
    this.rooms = 1,
    this.adults = 1,
    this.children = 0,
    this.selectedAccommodationTypes = const ['all'],
    this.minPrice = 0,
    this.maxPrice = 50000,
    this.searchResults = const [],
    this.searchStatus = SearchStatus.initial,
    this.errorMessage,
    this.currentPage = 0,
    this.hasMoreData = true,
    this.itemsPerPage = 5,
    this.isSearchMode = false,
    this.searchType = 'citySearch',
    this.excludedSearchTypes = const [],
    this.excludedHotels = const [],
    this.currency = 'INR',
    this.autocompleteResults = const [],
    this.autocompleteStatus = AutocompleteStatus.initial,
  });

  // Computed Properties
  bool get hasActiveFilters =>
      selectedAccommodationTypes.first != 'all' ||
      minPrice != 0 ||
      maxPrice != 50000;

  bool get hasValidDates => checkInDate != null && checkOutDate != null;

  bool get canSearch =>
      (searchQuery.trim().isNotEmpty || searchQueries.isNotEmpty) &&
      hasValidDates;

  int get totalGuests => adults + children;

  int get numberOfNights {
    if (checkInDate == null || checkOutDate == null) return 0;
    return checkOutDate!.difference(checkInDate!).inDays;
  }

  bool get isLoading => searchStatus == SearchStatus.loading;
  bool get isLoadingMore => searchStatus == SearchStatus.loadingMore;
  bool get hasError => searchStatus == SearchStatus.failure;
  bool get isEmpty => searchStatus == SearchStatus.empty;
  bool get hasResults => searchResults.isNotEmpty;

  HotelSearchState copyWith({
    String? searchQuery,
    List<String>? searchQueries,
    DateTime? checkInDate,
    DateTime? checkOutDate,
    int? rooms,
    int? adults,
    int? children,
    List<String>? selectedAccommodationTypes,
    double? minPrice,
    double? maxPrice,
    List<Hotel>? searchResults,
    SearchStatus? searchStatus,
    String? errorMessage,
    int? currentPage,
    bool? hasMoreData,
    int? itemsPerPage,
    bool? isSearchMode,
    String? searchType,
    List<String>? excludedSearchTypes,
    List<String>? excludedHotels,
    String? currency,
    List<AutocompleteItem>? autocompleteResults,
    AutocompleteStatus? autocompleteStatus,
  }) {
    return HotelSearchState(
      searchQuery: searchQuery ?? this.searchQuery,
      searchQueries: searchQueries ?? this.searchQueries,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      rooms: rooms ?? this.rooms,
      adults: adults ?? this.adults,
      children: children ?? this.children,
      selectedAccommodationTypes:
          selectedAccommodationTypes ?? this.selectedAccommodationTypes,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      searchResults: searchResults ?? this.searchResults,
      searchStatus: searchStatus ?? this.searchStatus,
      errorMessage: errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      isSearchMode: isSearchMode ?? this.isSearchMode,
      searchType: searchType ?? this.searchType,
      excludedSearchTypes: excludedSearchTypes ?? this.excludedSearchTypes,
      excludedHotels: excludedHotels ?? this.excludedHotels,
      currency: currency ?? this.currency,
      autocompleteResults: autocompleteResults ?? this.autocompleteResults,
      autocompleteStatus: autocompleteStatus ?? this.autocompleteStatus,
    );
  }

  // Helper method to clear nullable fields
  HotelSearchState clearDates() {
    return HotelSearchState(
      searchQuery: searchQuery,
      searchQueries: searchQueries,
      checkInDate: null,
      checkOutDate: null,
      rooms: rooms,
      adults: adults,
      children: children,
      selectedAccommodationTypes: selectedAccommodationTypes,
      minPrice: minPrice,
      maxPrice: maxPrice,
      searchResults: searchResults,
      searchStatus: searchStatus,
      errorMessage: errorMessage,
      currentPage: currentPage,
      hasMoreData: hasMoreData,
      itemsPerPage: itemsPerPage,
      isSearchMode: isSearchMode,
      searchType: searchType,
      excludedSearchTypes: excludedSearchTypes,
      excludedHotels: excludedHotels,
      currency: currency,
    );
  }

  // Reset to initial state
  HotelSearchState reset() {
    return const HotelSearchState();
  }

  // Reset only search results and pagination
  HotelSearchState resetSearch() {
    return copyWith(
      searchResults: [],
      searchStatus: SearchStatus.initial,
      errorMessage: null,
      currentPage: 0,
      hasMoreData: true,
      isSearchMode: false,
      excludedHotels: [],
    );
  }

  // Reset only filters
  HotelSearchState resetFilters() {
    return copyWith(
      selectedAccommodationTypes: ['all'],
      minPrice: 0,
      maxPrice: 50000,
    );
  }

  /// Creates a properly structured search payload using the model classes
  Map<String, dynamic> toSearchPayload() {
    if (!hasValidDates) return {};

    // Determine search queries to use
    // Priority: Use searchQueries from autocomplete if available, otherwise use typed searchQuery
    List<String> queries;
    if (searchQueries.isNotEmpty) {
      queries = searchQueries;
      print(
        '🔍 Using autocomplete queries: $searchQueries (Type: $searchType)',
      );
    } else {
      queries = [searchQuery.trim()];
      print('🔍 Using typed query: ${searchQuery.trim()} (Type: $searchType)');
    }

    // Create search criteria from state
    final searchCriteria = SearchCriteria.fromState(
      checkInDate: checkInDate!,
      checkOutDate: checkOutDate!,
      rooms: rooms,
      adults: adults,
      children: children,
      searchType: searchType,
      searchQuery: queries,
      accommodation: selectedAccommodationTypes,
      excludedSearchTypes: excludedSearchTypes,
      minPrice: minPrice,
      maxPrice: maxPrice,
      itemsPerPage: itemsPerPage,
      excludedHotels: excludedHotels,
      currency: currency,
      currentPage: currentPage,
    );

    // Create the full payload structure
    final payload = HotelSearchPayload(
      getSearchResultListOfHotels: SearchRequest(
        searchCriteria: searchCriteria,
      ),
    );

    final payloadJson = payload.toJson();

    print('📦 Final payload searchType: $searchType');
    print('📦 Final payload searchQuery: $queries');
    print('📦 Complete payload: $payloadJson');

    return payloadJson;
  }

  @override
  List<Object?> get props => [
    searchQuery,
    searchQueries,
    checkInDate,
    checkOutDate,
    rooms,
    adults,
    children,
    selectedAccommodationTypes,
    minPrice,
    maxPrice,
    searchResults,
    searchStatus,
    errorMessage,
    currentPage,
    hasMoreData,
    itemsPerPage,
    isSearchMode,
    searchType,
    excludedSearchTypes,
    excludedHotels,
    currency,
    autocompleteResults,
    autocompleteStatus,
  ];

  @override
  String toString() {
    return '''HotelSearchState {
      searchQuery: $searchQuery,
      searchQueries: $searchQueries,
      checkInDate: $checkInDate,
      checkOutDate: $checkOutDate,
      rooms: $rooms,
      adults: $adults,
      children: $children,
      filters: ${selectedAccommodationTypes.first}, ₹$minPrice-₹$maxPrice,
      searchStatus: $searchStatus,
      resultsCount: ${searchResults.length},
      currentPage: $currentPage,
      hasMoreData: $hasMoreData,
      isSearchMode: $isSearchMode,
      autocompleteStatus: $autocompleteStatus,
    }''';
  }
}
