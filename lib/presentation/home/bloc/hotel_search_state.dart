import 'package:assignment_travaly/presentation/home/data/models/hotel_model.dart';
import 'package:assignment_travaly/presentation/home/data/models/search_autocomplete_model.dart';
import 'package:equatable/equatable.dart';

enum SearchStatus { initial, loading, loadingMore, success, failure, empty }

enum AutocompleteStatus { initial, loading, success, failure }

class HotelSearchState extends Equatable {
  // Search Query
  final String searchQuery;

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
  final int currentPage;
  final bool hasMoreData;
  final int itemsPerPage;

  // Navigation
  final bool isSearchMode;

  // Additional Configuration
  final String searchType;
  final List<String> excludedSearchTypes;
  final String currency;

  //auto-complete
  final List<AutocompleteItem> autocompleteResults;
  final AutocompleteStatus autocompleteStatus;

  const HotelSearchState({
    this.searchQuery = '',
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
    this.currentPage = 1,
    this.hasMoreData = true,
    this.itemsPerPage = 10,
    this.isSearchMode = false,
    this.searchType = 'city',
    this.excludedSearchTypes = const [],
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

  bool get canSearch => searchQuery.trim().isNotEmpty && hasValidDates;

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
    String? currency,
    List<AutocompleteItem>? autocompleteResults,
    AutocompleteStatus? autocompleteStatus,
  }) {
    return HotelSearchState(
      searchQuery: searchQuery ?? this.searchQuery,
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
      currency: currency ?? this.currency,
      autocompleteResults: autocompleteResults ?? this.autocompleteResults,
      autocompleteStatus: autocompleteStatus ?? this.autocompleteStatus,
    );
  }

  // Helper method to clear nullable fields
  HotelSearchState clearDates() {
    return HotelSearchState(
      searchQuery: searchQuery,
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
      currentPage: 1,
      hasMoreData: true,
      isSearchMode: false,
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

  Map<String, dynamic> toSearchPayload() {
    if (!hasValidDates) return {};

    return {
      "searchCriteria": {
        "checkIn":
            "${checkInDate!.year}-${checkInDate!.month.toString().padLeft(2, '0')}-${checkInDate!.day.toString().padLeft(2, '0')}",
        "checkOut":
            "${checkOutDate!.year}-${checkOutDate!.month.toString().padLeft(2, '0')}-${checkOutDate!.day.toString().padLeft(2, '0')}",
        "rooms": rooms,
        "adults": adults,
        "children": children,
        "searchType": searchType,
        "searchQuery": [searchQuery],
        "accommodation": selectedAccommodationTypes,
        "arrayOfExcludedSearchType": excludedSearchTypes,
        "highPrice": maxPrice.toString(),
        "lowPrice": minPrice.toString(),
        "limit": itemsPerPage,
        "preloaderList": [],
        "currency": currency,
        "rid": currentPage - 1,
      },
    };
  }

  @override
  List<Object?> get props => [
    searchQuery,
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
    currency,
    autocompleteResults,
    autocompleteStatus,
  ];

  @override
  String toString() {
    return '''HotelSearchState {
      searchQuery: $searchQuery,
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
