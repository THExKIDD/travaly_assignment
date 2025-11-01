import 'dart:developer';

import 'package:assignment_travaly/presentation/home/data/models/search_autocomplete_model.dart';
import 'package:assignment_travaly/presentation/home/data/repo/hotel_search_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'hotel_search_event.dart';
import 'hotel_search_state.dart';

class HotelSearchBloc extends Bloc<HotelSearchEvent, HotelSearchState> {
  final HotelSearchRepo _hotelSearchRepo = HotelSearchRepo();

  HotelSearchBloc() : super(const HotelSearchState()) {
    // Search Query Events
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<SearchQueryCleared>(_onSearchQueryCleared);

    // Date Selection Events
    on<CheckInDateSelected>(_onCheckInDateSelected);
    on<CheckOutDateSelected>(_onCheckOutDateSelected);
    on<DateRangeSelected>(_onDateRangeSelected);

    // Guest and Room Events
    on<RoomsUpdated>(_onRoomsUpdated);
    on<AdultsUpdated>(_onAdultsUpdated);
    on<ChildrenUpdated>(_onChildrenUpdated);
    on<GuestRoomDataUpdated>(_onGuestRoomDataUpdated);

    // Filter Events
    on<AccommodationTypesUpdated>(_onAccommodationTypesUpdated);
    on<PriceRangeUpdated>(_onPriceRangeUpdated);
    on<FiltersUpdated>(_onFiltersUpdated);
    on<FiltersReset>(_onFiltersReset);

    // Search Execution Events
    on<SearchSubmitted>(_onSearchSubmitted);
    on<SearchInitiated>(_onSearchInitiated);
    on<LoadMoreResults>(_onLoadMoreResults);
    on<SearchResultsCleared>(_onSearchResultsCleared);

    // Navigation Events
    on<NavigateToSearchResults>(_onNavigateToSearchResults);
    on<NavigateToHome>(_onNavigateToHome);

    //Auto-complete Handlers
    on<FetchAutocomplete>(_onFetchAutocomplete);
    on<AutocompleteResultSelected>(_onAutocompleteResultSelected);

    // Additional Helper Events
    on<SearchModeEnabled>(_onSearchModeEnabled);
    on<SearchModeDisabled>(_onSearchModeDisabled);
    on<RetrySearch>(_onRetrySearch);
  }

  // Search Query Handlers
  void _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<HotelSearchState> emit,
  ) {
    // When user types, clear previous autocomplete selection
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onSearchQueryCleared(
    SearchQueryCleared event,
    Emitter<HotelSearchState> emit,
  ) {
    emit(state.copyWith(searchQuery: ''));
  }

  // Date Selection Handlers
  void _onCheckInDateSelected(
    CheckInDateSelected event,
    Emitter<HotelSearchState> emit,
  ) {
    DateTime? checkOut = state.checkOutDate;

    // Auto-adjust checkout if it's before new check-in
    if (checkOut != null &&
        checkOut.isBefore(event.date.add(const Duration(days: 1)))) {
      checkOut = event.date.add(const Duration(days: 1));
    }

    emit(state.copyWith(checkInDate: event.date, checkOutDate: checkOut));
  }

  void _onCheckOutDateSelected(
    CheckOutDateSelected event,
    Emitter<HotelSearchState> emit,
  ) {
    emit(state.copyWith(checkOutDate: event.date));
  }

  void _onDateRangeSelected(
    DateRangeSelected event,
    Emitter<HotelSearchState> emit,
  ) {
    emit(
      state.copyWith(checkInDate: event.checkIn, checkOutDate: event.checkOut),
    );
  }

  // Guest and Room Handlers
  void _onRoomsUpdated(RoomsUpdated event, Emitter<HotelSearchState> emit) {
    emit(state.copyWith(rooms: event.rooms));
  }

  void _onAdultsUpdated(AdultsUpdated event, Emitter<HotelSearchState> emit) {
    emit(state.copyWith(adults: event.adults));
  }

  void _onChildrenUpdated(
    ChildrenUpdated event,
    Emitter<HotelSearchState> emit,
  ) {
    emit(state.copyWith(children: event.children));
  }

  void _onGuestRoomDataUpdated(
    GuestRoomDataUpdated event,
    Emitter<HotelSearchState> emit,
  ) {
    emit(
      state.copyWith(
        rooms: event.rooms,
        adults: event.adults,
        children: event.children,
      ),
    );
  }

  // Filter Handlers
  void _onAccommodationTypesUpdated(
    AccommodationTypesUpdated event,
    Emitter<HotelSearchState> emit,
  ) {
    emit(state.copyWith(selectedAccommodationTypes: event.types));
  }

  void _onPriceRangeUpdated(
    PriceRangeUpdated event,
    Emitter<HotelSearchState> emit,
  ) {
    emit(state.copyWith(minPrice: event.minPrice, maxPrice: event.maxPrice));
  }

  void _onFiltersUpdated(FiltersUpdated event, Emitter<HotelSearchState> emit) {
    emit(
      state.copyWith(
        selectedAccommodationTypes: event.accommodationTypes,
        minPrice: event.minPrice,
        maxPrice: event.maxPrice,
      ),
    );
  }

  void _onFiltersReset(FiltersReset event, Emitter<HotelSearchState> emit) {
    emit(state.resetFilters());
  }

  // Search Execution Handlers
  Future<void> _onSearchSubmitted(
    SearchSubmitted event,
    Emitter<HotelSearchState> emit,
  ) async {
    // Validation
    if (state.searchQuery.trim().isEmpty && state.searchQueries.isEmpty) {
      emit(
        state.copyWith(
          searchStatus: SearchStatus.failure,
          errorMessage: 'Please enter a destination',
        ),
      );
      return;
    }

    if (!state.hasValidDates) {
      emit(
        state.copyWith(
          searchStatus: SearchStatus.failure,
          errorMessage: 'Please select check-in and check-out dates',
        ),
      );
      return;
    }

    // If searchQueries is empty (user typed without selecting autocomplete),
    // use searchByKeywords as the search type
    String searchType = state.searchType;
    if (state.searchQueries.isEmpty && state.searchQuery.isNotEmpty) {
      searchType = 'searchByKeywords';
      log('Using searchByKeywords for typed query: ${state.searchQuery}');
    }

    // Reset search state and initiate search
    emit(
      state.copyWith(
        isSearchMode: true,
        searchStatus: SearchStatus.loading,
        searchResults: [],
        currentPage: 0,
        hasMoreData: true,
        errorMessage: null,
        searchType: searchType, // Update search type if needed
      ),
    );

    await _performSearch(emit);
  }

  Future<void> _onSearchInitiated(
    SearchInitiated event,
    Emitter<HotelSearchState> emit,
  ) async {
    emit(
      state.copyWith(
        searchQuery: event.query,
        isSearchMode: true,
        searchStatus: SearchStatus.loading,
        searchResults: [],
        currentPage: 0,
        hasMoreData: true,
        errorMessage: null,
      ),
    );

    await _performSearch(emit);
  }

  Future<void> _onLoadMoreResults(
    LoadMoreResults event,
    Emitter<HotelSearchState> emit,
  ) async {
    if (!state.hasMoreData || state.isLoadingMore) return;

    emit(
      state.copyWith(
        searchStatus: SearchStatus.loadingMore,
        currentPage: state.currentPage + 1,
      ),
    );

    await _performSearch(emit, isLoadMore: true);
  }

  void _onSearchResultsCleared(
    SearchResultsCleared event,
    Emitter<HotelSearchState> emit,
  ) {
    emit(state.resetSearch());
  }

  // Navigation Handlers
  void _onNavigateToSearchResults(
    NavigateToSearchResults event,
    Emitter<HotelSearchState> emit,
  ) {
    emit(state.copyWith(isSearchMode: true));
  }

  void _onNavigateToHome(NavigateToHome event, Emitter<HotelSearchState> emit) {
    emit(state.copyWith(isSearchMode: false));
  }

  // Helper Event Handlers
  void _onSearchModeEnabled(
    SearchModeEnabled event,
    Emitter<HotelSearchState> emit,
  ) {
    emit(state.copyWith(isSearchMode: true));
  }

  void _onSearchModeDisabled(
    SearchModeDisabled event,
    Emitter<HotelSearchState> emit,
  ) {
    emit(state.copyWith(isSearchMode: false));
  }

  Future<void> _onRetrySearch(
    RetrySearch event,
    Emitter<HotelSearchState> emit,
  ) async {
    emit(
      state.copyWith(searchStatus: SearchStatus.loading, errorMessage: null),
    );

    await _performSearch(emit);
  }

  // Private Helper Methods
  Future<void> _performSearch(
    Emitter<HotelSearchState> emit, {
    bool isLoadMore = false,
  }) async {
    try {
      log('Performing search with state: ${state.toString()}');

      // Build search payload
      final searchPayload = state.toSearchPayload();

      log('Search payload: $searchPayload');

      // Call API
      final response = await _hotelSearchRepo.searchHotels(
        searchPayload: searchPayload,
      );

      // Extract hotel list from response
      final newResults = response.data?.arrayOfHotelList ?? [];

      log('Received ${newResults.length} results');

      // Handle empty results
      if (newResults.isEmpty) {
        if (isLoadMore) {
          emit(
            state.copyWith(
              searchStatus: SearchStatus.success,
              hasMoreData: false,
            ),
          );
        } else {
          emit(
            state.copyWith(
              searchStatus: SearchStatus.empty,
              searchResults: [],
              hasMoreData: false,
            ),
          );
        }
        return;
      }

      // Update results
      final updatedResults = isLoadMore
          ? [...state.searchResults, ...newResults]
          : newResults;

      // Check if there are more results
      final hasMore = newResults.length >= state.itemsPerPage;

      // Update excluded hotels and search types for next pagination
      final excludedHotels = response.data?.arrayOfExcludedHotels ?? [];
      final excludedSearchTypes =
          response.data?.arrayOfExcludedSearchType ?? [];

      emit(
        state.copyWith(
          searchStatus: SearchStatus.success,
          searchResults: updatedResults,
          hasMoreData: hasMore,
          errorMessage: null,
          excludedHotels: excludedHotels,
          excludedSearchTypes: excludedSearchTypes,
        ),
      );
    } catch (e) {
      log('Search error: $e');
      emit(
        state.copyWith(
          searchStatus: SearchStatus.failure,
          errorMessage: 'Failed to load results. Please try again.',
        ),
      );
    }
  }

  Future<void> _onFetchAutocomplete(
    FetchAutocomplete event,
    Emitter<HotelSearchState> emit,
  ) async {
    final query = event.query.trim();

    if (query.isEmpty) {
      // Clear results if query is empty
      return emit(
        state.copyWith(
          autocompleteResults: [],
          autocompleteStatus: AutocompleteStatus.initial,
        ),
      );
    }

    emit(state.copyWith(autocompleteStatus: AutocompleteStatus.loading));

    try {
      // API call
      final results = await _fetchAutocompleteResults(query);

      emit(
        state.copyWith(
          autocompleteResults: results,
          autocompleteStatus: AutocompleteStatus.success,
        ),
      );
    } catch (e) {
      log('Autocomplete error: $e');
      emit(state.copyWith(autocompleteStatus: AutocompleteStatus.failure));
    }
  }

  void _onAutocompleteResultSelected(
    AutocompleteResultSelected event,
    Emitter<HotelSearchState> emit,
  ) {
    // Map autocomplete search type to API search type
    String apiSearchType = _mapSearchTypeToAPI(event.searchType);

    log(
      'Autocomplete selected - Query: ${event.query}, Type: $apiSearchType, Queries: ${event.searchQueries}',
    );

    emit(
      state.copyWith(
        searchQuery: event.query,
        searchType: apiSearchType,
        searchQueries: event
            .searchQueries, // Use the actual query values from autocomplete
        autocompleteResults: [], // Clear suggestions
        autocompleteStatus: AutocompleteStatus.initial,
      ),
    );
  }

  // Map autocomplete search types to API expected format
  String _mapSearchTypeToAPI(String autocompleteType) {
    switch (autocompleteType.toLowerCase()) {
      case 'bycity':
      case 'citysearch':
        return 'citySearch';
      case 'bystate':
      case 'statesearch':
        return 'stateSearch';
      case 'bycountry':
      case 'countrysearch':
        return 'countrySearch';
      case 'bystreet':
      case 'streetsearch':
        return 'streetSearch';
      case 'hotelidsearch':
      case 'byhotelid':
        return 'hotelIdSearch';
      case 'bykeywords':
      case 'keywords':
        return 'searchByKeywords';
      default:
        return 'citySearch'; // Default to city search
    }
  }

  Future<List<AutocompleteItem>> _fetchAutocompleteResults(String query) async {
    try {
      final data = await _hotelSearchRepo.fetchSearchSuggestions(query: query);

      final filteredResults = data.autoCompleteList.getGroupedResults().where((
        item,
      ) {
        if (item.isHeader) return true;
        return item.result!.valueToDisplay.toLowerCase().contains(
          query.toLowerCase(),
        );
      }).toList();

      return filteredResults;
    } catch (e) {
      log('Error fetching autocomplete: $e');
      return [];
    }
  }

  // Method to build search payload for API calls
  Map<String, dynamic> buildSearchPayload() {
    return state.toSearchPayload();
  }
}
