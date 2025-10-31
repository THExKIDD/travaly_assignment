import 'package:equatable/equatable.dart';

abstract class HotelSearchEvent extends Equatable {
  const HotelSearchEvent();

  @override
  List<Object?> get props => [];
}

// Search Query Events
class SearchQueryChanged extends HotelSearchEvent {
  final String query;

  const SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class SearchQueryCleared extends HotelSearchEvent {
  const SearchQueryCleared();
}

// Date Selection Events
class CheckInDateSelected extends HotelSearchEvent {
  final DateTime date;

  const CheckInDateSelected(this.date);

  @override
  List<Object?> get props => [date];
}

class CheckOutDateSelected extends HotelSearchEvent {
  final DateTime date;

  const CheckOutDateSelected(this.date);

  @override
  List<Object?> get props => [date];
}

class DateRangeSelected extends HotelSearchEvent {
  final DateTime checkIn;
  final DateTime checkOut;

  const DateRangeSelected({required this.checkIn, required this.checkOut});

  @override
  List<Object?> get props => [checkIn, checkOut];
}

// Guest and Room Events
class RoomsUpdated extends HotelSearchEvent {
  final int rooms;

  const RoomsUpdated(this.rooms);

  @override
  List<Object?> get props => [rooms];
}

class AdultsUpdated extends HotelSearchEvent {
  final int adults;

  const AdultsUpdated(this.adults);

  @override
  List<Object?> get props => [adults];
}

class ChildrenUpdated extends HotelSearchEvent {
  final int children;

  const ChildrenUpdated(this.children);

  @override
  List<Object?> get props => [children];
}

class GuestRoomDataUpdated extends HotelSearchEvent {
  final int? rooms;
  final int? adults;
  final int? children;

  const GuestRoomDataUpdated({this.rooms, this.adults, this.children});

  @override
  List<Object?> get props => [rooms, adults, children];
}

// Filter Events
class AccommodationTypesUpdated extends HotelSearchEvent {
  final List<String> types;

  const AccommodationTypesUpdated(this.types);

  @override
  List<Object?> get props => [types];
}

class PriceRangeUpdated extends HotelSearchEvent {
  final double minPrice;
  final double maxPrice;

  const PriceRangeUpdated({required this.minPrice, required this.maxPrice});

  @override
  List<Object?> get props => [minPrice, maxPrice];
}

class FiltersUpdated extends HotelSearchEvent {
  final List<String>? accommodationTypes;
  final double? minPrice;
  final double? maxPrice;

  const FiltersUpdated({this.accommodationTypes, this.minPrice, this.maxPrice});

  @override
  List<Object?> get props => [accommodationTypes, minPrice, maxPrice];
}

class FiltersReset extends HotelSearchEvent {
  const FiltersReset();
}

// Search Execution Events
class SearchSubmitted extends HotelSearchEvent {
  const SearchSubmitted();
}

class SearchInitiated extends HotelSearchEvent {
  final String query;

  const SearchInitiated(this.query);

  @override
  List<Object?> get props => [query];
}

class LoadMoreResults extends HotelSearchEvent {
  const LoadMoreResults();
}

class SearchResultsCleared extends HotelSearchEvent {
  const SearchResultsCleared();
}

// Navigation Events
class NavigateToSearchResults extends HotelSearchEvent {
  const NavigateToSearchResults();
}

class NavigateToHome extends HotelSearchEvent {
  const NavigateToHome();
}

// Additional Helper Events
class SearchModeEnabled extends HotelSearchEvent {
  const SearchModeEnabled();
}

class SearchModeDisabled extends HotelSearchEvent {
  const SearchModeDisabled();
}

class RetrySearch extends HotelSearchEvent {
  const RetrySearch();
}

class FetchAutocomplete extends HotelSearchEvent {
  final String query;

  const FetchAutocomplete(this.query);

  @override
  List<Object?> get props => [query];
}

class AutocompleteResultSelected extends HotelSearchEvent {
  final String query;
  final String searchType;
  final List<String> searchQueries;

  const AutocompleteResultSelected({
    required this.query,
    required this.searchType,
    required this.searchQueries,
  });

  @override
  List<Object?> get props => [query, searchType, searchQueries];
}
