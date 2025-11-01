import 'package:assignment_travaly/presentation/home/data/models/search_autocomplete_model.dart';
import 'package:assignment_travaly/presentation/home/data/models/search_results_model.dart';
import 'package:assignment_travaly/presentation/home/data/repo/hotel_search_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'hotel_search_event.dart';
import 'hotel_search_state.dart';

class HotelSearchBloc extends Bloc<HotelSearchEvent, HotelSearchState> {
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
    if (state.searchQuery.trim().isEmpty) {
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

    // Reset search state and initiate search
    emit(
      state.copyWith(
        isSearchMode: true,
        searchStatus: SearchStatus.loading,
        searchResults: [],
        currentPage: 1,
        hasMoreData: true,
        errorMessage: null,
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
        currentPage: 1,
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
      // In a real implementation, you would call your API here
      // For now, using mock data

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Generate mock results
      final newResults = _generateMockResults(
        state.currentPage,
        state.searchQuery,
      );

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

      final updatedResults = isLoadMore
          ? [...state.searchResults, ...newResults]
          : newResults;

      emit(
        state.copyWith(
          searchStatus: SearchStatus.success,
          searchResults: updatedResults,
          hasMoreData: newResults.length == state.itemsPerPage,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          searchStatus: SearchStatus.failure,
          errorMessage: 'Failed to load results. Please try again.',
        ),
      );
    }
  }

  List<Hotel> _generateMockResults(int page, String query) {
    // Stop after 3 pages
    if (page > 3) return [];

    final cities = [
      'New York',
      'Miami',
      'Chicago',
      'Los Angeles',
      'Boston',
      'Seattle',
      'Austin',
      'Denver',
    ];
    final states = [
      'New York',
      'Florida',
      'Illinois',
      'California',
      'Massachusetts',
      'Washington',
      'Texas',
      'Colorado',
    ];
    final propertyTypes = [
      'Hotel',
      'Resort',
      'Villa',
      'Apartment',
      'Guesthouse',
    ];

    return List.generate(state.itemsPerPage, (index) {
      final globalIndex = (page - 1) * state.itemsPerPage + index;
      final cityIndex = globalIndex % cities.length;
      final basePrice = 150.0 + (globalIndex * 20);
      final rating = 4.0 + (globalIndex % 10) / 10;

      return Hotel(
        propertyCode: 'PROP${globalIndex + 1000}',
        propertyName:
            '${propertyTypes[globalIndex % propertyTypes.length]} $query ${globalIndex + 1}',
        propertyImage: PropertyImage(
          fullUrl: 'https://picsum.photos/400/300?random=${globalIndex + 10}',
          location: 'images/hotels/',
          imageName: 'hotel_${globalIndex + 1}.jpg',
        ),
        propertyType: propertyTypes[globalIndex % propertyTypes.length],
        propertyStar: (rating.toInt().clamp(1, 5)),
        propertyPoliciesAndAmmenities: PropertyPoliciesAndAmenities(
          present: true,
          data: PolicyData(
            freeWifi: globalIndex % 2 == 0,
            freeCancellation: globalIndex % 3 == 0,
            payAtHotel: globalIndex % 4 == 0,
            petsAllowed: globalIndex % 5 == 0,
            coupleFriendly: true,
            bachularsAllowed: globalIndex % 3 != 0,
            suitableForChildren: globalIndex % 2 == 0,
          ),
        ),
        propertyAddress: PropertyAddress(
          street: '${100 + globalIndex} Main Street',
          city: cities[cityIndex],
          state: states[cityIndex],
          country: 'USA',
          zipcode: '${10000 + globalIndex}',
          mapAddress: '${cities[cityIndex]}, ${states[cityIndex]}, USA',
          latitude: 40.7128 + (globalIndex * 0.1),
          longitude: -74.0060 + (globalIndex * 0.1),
        ),
        propertyUrl: 'https://example.com/hotel/${globalIndex + 1}',
        roomName: 'Deluxe Room',
        numberOfAdults: state.adults,
        markedPrice: Price(
          amount: basePrice * 1.2,
          displayAmount: '₹${(basePrice * 1.2).toStringAsFixed(0)}',
          currencyAmount: (basePrice * 1.2).toStringAsFixed(2),
          currencySymbol: '₹',
        ),
        propertyMinPrice: Price(
          amount: basePrice,
          displayAmount: '₹${basePrice.toStringAsFixed(0)}',
          currencyAmount: basePrice.toStringAsFixed(2),
          currencySymbol: '₹',
        ),
        propertyMaxPrice: Price(
          amount: basePrice * 1.5,
          displayAmount: '₹${(basePrice * 1.5).toStringAsFixed(0)}',
          currencyAmount: (basePrice * 1.5).toStringAsFixed(2),
          currencySymbol: '₹',
        ),
        availableDeals: [
          AvailableDeal(
            headerName: 'Early Bird Discount',
            websiteUrl: 'https://example.com/deals',
            dealType: 'discount',
            price: Price(
              amount: basePrice * 0.9,
              displayAmount: '₹${(basePrice * 0.9).toStringAsFixed(0)}',
              currencyAmount: (basePrice * 0.9).toStringAsFixed(2),
              currencySymbol: '₹',
            ),
          ),
        ],
        subscriptionStatus: SubscriptionStatus(status: globalIndex % 4 == 0),
        propertyView: 1000 + (globalIndex * 50),
        isFavorite: false,
        simplPriceList: SimplPriceList(
          simplPrice: Price(
            amount: basePrice * 0.95,
            displayAmount: '₹${(basePrice * 0.95).toStringAsFixed(0)}',
            currencyAmount: (basePrice * 0.95).toStringAsFixed(2),
            currencySymbol: '₹',
          ),
          originalPrice: basePrice,
        ),
        googleReview: GoogleReview(
          reviewPresent: true,
          data: ReviewData(
            overallRating: rating,
            totalUserRating: 100 + (globalIndex * 10),
            withoutDecimal: rating.toInt(),
          ),
        ),
      );
    });
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
      // API call placeholder
      final results = await _fetchAutocompleteResults(query);

      emit(
        state.copyWith(
          autocompleteResults: results,
          autocompleteStatus: AutocompleteStatus.success,
        ),
      );
    } catch (e) {
      emit(state.copyWith(autocompleteStatus: AutocompleteStatus.failure));
    }
  }

  void _onAutocompleteResultSelected(
    AutocompleteResultSelected event,
    Emitter<HotelSearchState> emit,
  ) {
    emit(
      state.copyWith(
        searchQuery: event.query,
        searchType: event.searchType,
        autocompleteResults: [], // Clear suggestions
        autocompleteStatus: AutocompleteStatus.initial,
      ),
    );
  }

  Future<List<AutocompleteItem>> _fetchAutocompleteResults(String query) async {
    try {
      final HotelSearchRepo hotelSearchRepo = HotelSearchRepo();

      final AutocompleteData data = await hotelSearchRepo
          .fetchSearchSuggestions(query: query);

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
      return [];
    }
  }

  // Method to build search payload for API calls
  Map<String, dynamic> buildSearchPayload() {
    return state.toSearchPayload();
  }
}
