// autocomplete_models.dart

import 'package:equatable/equatable.dart';

/// Data container for autocomplete results
class AutocompleteData {
  final bool present;
  final int totalNumberOfResult;
  final AutocompleteList autoCompleteList;

  const AutocompleteData({
    required this.present,
    required this.totalNumberOfResult,
    required this.autoCompleteList,
  });

  factory AutocompleteData.fromJson(Map<String, dynamic> json) {
    return AutocompleteData(
      present: json['present'] ?? false,
      totalNumberOfResult: json['totalNumberOfResult'] ?? 0,
      autoCompleteList: AutocompleteList.fromJson(
        json['autoCompleteList'] ?? {},
      ),
    );
  }
}

/// Container for all autocomplete result categories
class AutocompleteList {
  final AutocompleteCategory byPropertyName;
  final AutocompleteCategory byStreet;
  final AutocompleteCategory byCity;
  final AutocompleteCategory byState;
  final AutocompleteCategory byCountry;

  const AutocompleteList({
    required this.byPropertyName,
    required this.byStreet,
    required this.byCity,
    required this.byState,
    required this.byCountry,
  });

  factory AutocompleteList.fromJson(Map<String, dynamic> json) {
    return AutocompleteList(
      byPropertyName: AutocompleteCategory.fromJson(
        json['byPropertyName'] ?? {},
      ),
      byStreet: AutocompleteCategory.fromJson(json['byStreet'] ?? {}),
      byCity: AutocompleteCategory.fromJson(json['byCity'] ?? {}),
      byState: AutocompleteCategory.fromJson(json['byState'] ?? {}),
      byCountry: AutocompleteCategory.fromJson(json['byCountry'] ?? {}),
    );
  }

  /// Get all results as a flat list
  List<AutocompleteResult> getAllResults() {
    return [
      ...byPropertyName.listOfResult,
      ...byCity.listOfResult,
      ...byState.listOfResult,
      ...byCountry.listOfResult,
      ...byStreet.listOfResult,
    ];
  }

  /// Get all results grouped by category with headers
  List<AutocompleteItem> getGroupedResults() {
    final items = <AutocompleteItem>[];

    if (byPropertyName.present && byPropertyName.numberOfResult > 0) {
      items.add(AutocompleteItem.header('Hotels'));
      items.addAll(
        byPropertyName.listOfResult.map((r) => AutocompleteItem.result(r)),
      );
    }

    if (byCity.present && byCity.numberOfResult > 0) {
      items.add(AutocompleteItem.header('Cities'));
      items.addAll(byCity.listOfResult.map((r) => AutocompleteItem.result(r)));
    }

    if (byState.present && byState.numberOfResult > 0) {
      items.add(AutocompleteItem.header('States'));
      items.addAll(byState.listOfResult.map((r) => AutocompleteItem.result(r)));
    }

    if (byCountry.present && byCountry.numberOfResult > 0) {
      items.add(AutocompleteItem.header('Countries'));
      items.addAll(
        byCountry.listOfResult.map((r) => AutocompleteItem.result(r)),
      );
    }

    if (byStreet.present && byStreet.numberOfResult > 0) {
      items.add(AutocompleteItem.header('Locations'));
      items.addAll(
        byStreet.listOfResult.map((r) => AutocompleteItem.result(r)),
      );
    }

    return items;
  }
}

/// Category of autocomplete results
class AutocompleteCategory {
  final bool present;
  final List<AutocompleteResult> listOfResult;
  final int numberOfResult;

  const AutocompleteCategory({
    required this.present,
    required this.listOfResult,
    required this.numberOfResult,
  });

  factory AutocompleteCategory.fromJson(Map<String, dynamic> json) {
    return AutocompleteCategory(
      present: json['present'] ?? false,
      listOfResult:
          (json['listOfResult'] as List<dynamic>?)
              ?.map((e) => AutocompleteResult.fromJson(e))
              .toList() ??
          [],
      numberOfResult: json['numberOfResult'] ?? 0,
    );
  }
}

/// Individual autocomplete result
class AutocompleteResult extends Equatable {
  final String valueToDisplay;
  final String? propertyName;
  final Address address;
  final SearchArray searchArray;

  const AutocompleteResult({
    required this.valueToDisplay,
    this.propertyName,
    required this.address,
    required this.searchArray,
  });

  factory AutocompleteResult.fromJson(Map<String, dynamic> json) {
    return AutocompleteResult(
      valueToDisplay: json['valueToDisplay'] ?? '',
      propertyName: json['propertyName'],
      address: Address.fromJson(json['address'] ?? {}),
      searchArray: SearchArray.fromJson(json['searchArray'] ?? {}),
    );
  }

  @override
  List<Object?> get props => [
    valueToDisplay,
    propertyName,
    address,
    searchArray,
  ];
}

/// Address information
class Address extends Equatable {
  final String? street;
  final String? city;
  final String? state;
  final String? country;

  const Address({this.street, this.city, this.state, this.country});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
    );
  }

  String get subtitle {
    final parts = <String>[];
    if (city != null && city!.isNotEmpty) parts.add(city!);
    if (state != null && state!.isNotEmpty) parts.add(state!);
    if (country != null && country!.isNotEmpty) parts.add(country!);
    return parts.join(', ');
  }

  @override
  List<Object?> get props => [street, city, state, country];
}

/// Search parameters for API call
class SearchArray extends Equatable {
  final String type;
  final List<String> query;

  const SearchArray({required this.type, required this.query});

  factory SearchArray.fromJson(Map<String, dynamic> json) {
    return SearchArray(
      type: json['type'] ?? '',
      query:
          (json['query'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  @override
  List<Object?> get props => [type, query];
}

/// UI item for displaying autocomplete (either header or result)
class AutocompleteItem {
  final bool isHeader;
  final String? headerText;
  final AutocompleteResult? result;

  const AutocompleteItem._({
    required this.isHeader,
    this.headerText,
    this.result,
  });

  factory AutocompleteItem.header(String text) {
    return AutocompleteItem._(isHeader: true, headerText: text);
  }

  factory AutocompleteItem.result(AutocompleteResult result) {
    return AutocompleteItem._(isHeader: false, result: result);
  }
}
