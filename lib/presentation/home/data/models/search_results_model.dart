import 'dart:convert';

HotelSearchResponse hotelSearchResponseFromJson(String str) =>
    HotelSearchResponse.fromJson(json.decode(str));

String hotelSearchResponseToJson(HotelSearchResponse data) =>
    json.encode(data.toJson());

class HotelSearchResponse {
  final HotelData? data;

  HotelSearchResponse({this.data});

  factory HotelSearchResponse.fromJson(Map<String, dynamic> json) =>
      HotelSearchResponse(
        data: json["data"] == null ? null : HotelData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"data": data?.toJson()};
}

class HotelData {
  final List<Hotel>? arrayOfHotelList;
  final List<String>? arrayOfExcludedHotels;
  final List<String>? arrayOfExcludedSearchType;

  HotelData({
    this.arrayOfHotelList,
    this.arrayOfExcludedHotels,
    this.arrayOfExcludedSearchType,
  });

  factory HotelData.fromJson(Map<String, dynamic> json) => HotelData(
    arrayOfHotelList: json["arrayOfHotelList"] == null
        ? []
        : List<Hotel>.from(
            json["arrayOfHotelList"].map((x) => Hotel.fromJson(x)),
          ),
    arrayOfExcludedHotels: json["arrayOfExcludedHotels"] == null
        ? []
        : List<String>.from(json["arrayOfExcludedHotels"].map((x) => x)),
    arrayOfExcludedSearchType: json["arrayOfExcludedSearchType"] == null
        ? []
        : List<String>.from(json["arrayOfExcludedSearchType"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "arrayOfHotelList": arrayOfHotelList == null
        ? []
        : arrayOfHotelList!.map((x) => x.toJson()).toList(),
    "arrayOfExcludedHotels": arrayOfExcludedHotels,
    "arrayOfExcludedSearchType": arrayOfExcludedSearchType,
  };
}

class Hotel {
  final String? propertyCode;
  final String? propertyName;
  final PropertyImage? propertyImage;
  final String? propertyType;
  final int? propertyStar;
  final PropertyPoliciesAndAmenities? propertyPoliciesAndAmmenities;
  final PropertyAddress? propertyAddress;
  final String? propertyUrl;
  final String? roomName;
  final int? numberOfAdults;
  final Price? markedPrice;
  final Price? propertyMaxPrice;
  final Price? propertyMinPrice;
  final List<AvailableDeal>? availableDeals;
  final SubscriptionStatus? subscriptionStatus;
  final int? propertyView;
  final bool? isFavorite;
  final SimplPriceList? simplPriceList;
  final GoogleReview? googleReview;

  Hotel({
    this.propertyCode,
    this.propertyName,
    this.propertyImage,
    this.propertyType,
    this.propertyStar,
    this.propertyPoliciesAndAmmenities,
    this.propertyAddress,
    this.propertyUrl,
    this.roomName,
    this.numberOfAdults,
    this.markedPrice,
    this.propertyMaxPrice,
    this.propertyMinPrice,
    this.availableDeals,
    this.subscriptionStatus,
    this.propertyView,
    this.isFavorite,
    this.simplPriceList,
    this.googleReview,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) => Hotel(
    propertyCode: json["propertyCode"],
    propertyName: json["propertyName"],
    propertyImage: json["propertyImage"] == null
        ? null
        : PropertyImage.fromJson(json["propertyImage"]),
    propertyType: json["propertytype"],
    propertyStar: json["propertyStar"],
    propertyPoliciesAndAmmenities: json["propertyPoliciesAndAmmenities"] == null
        ? null
        : PropertyPoliciesAndAmenities.fromJson(
            json["propertyPoliciesAndAmmenities"],
          ),
    propertyAddress: json["propertyAddress"] == null
        ? null
        : PropertyAddress.fromJson(json["propertyAddress"]),
    propertyUrl: json["propertyUrl"],
    roomName: json["roomName"],
    numberOfAdults: json["numberOfAdults"],
    markedPrice: json["markedPrice"] == null
        ? null
        : Price.fromJson(json["markedPrice"]),
    propertyMaxPrice: json["propertyMaxPrice"] == null
        ? null
        : Price.fromJson(json["propertyMaxPrice"]),
    propertyMinPrice: json["propertyMinPrice"] == null
        ? null
        : Price.fromJson(json["propertyMinPrice"]),
    availableDeals: json["availableDeals"] == null
        ? []
        : List<AvailableDeal>.from(
            json["availableDeals"].map((x) => AvailableDeal.fromJson(x)),
          ),
    subscriptionStatus: json["subscriptionStatus"] == null
        ? null
        : SubscriptionStatus.fromJson(json["subscriptionStatus"]),
    propertyView: json["propertyView"],
    isFavorite: json["isFavorite"],
    simplPriceList: json["simplPriceList"] == null
        ? null
        : SimplPriceList.fromJson(json["simplPriceList"]),
    googleReview: json["googleReview"] == null
        ? null
        : GoogleReview.fromJson(json["googleReview"]),
  );

  Map<String, dynamic> toJson() => {
    "propertyCode": propertyCode,
    "propertyName": propertyName,
    "propertyImage": propertyImage?.toJson(),
    "propertytype": propertyType,
    "propertyStar": propertyStar,
    "propertyPoliciesAndAmmenities": propertyPoliciesAndAmmenities?.toJson(),
    "propertyAddress": propertyAddress?.toJson(),
    "propertyUrl": propertyUrl,
    "roomName": roomName,
    "numberOfAdults": numberOfAdults,
    "markedPrice": markedPrice?.toJson(),
    "propertyMaxPrice": propertyMaxPrice?.toJson(),
    "propertyMinPrice": propertyMinPrice?.toJson(),
    "availableDeals": availableDeals == null
        ? []
        : availableDeals!.map((x) => x.toJson()).toList(),
    "subscriptionStatus": subscriptionStatus?.toJson(),
    "propertyView": propertyView,
    "isFavorite": isFavorite,
    "simplPriceList": simplPriceList?.toJson(),
    "googleReview": googleReview?.toJson(),
  };
}

class PropertyImage {
  final String? fullUrl;
  final String? location;
  final String? imageName;

  PropertyImage({this.fullUrl, this.location, this.imageName});

  factory PropertyImage.fromJson(Map<String, dynamic> json) => PropertyImage(
    fullUrl: json["fullUrl"],
    location: json["location"],
    imageName: json["imageName"],
  );

  Map<String, dynamic> toJson() => {
    "fullUrl": fullUrl,
    "location": location,
    "imageName": imageName,
  };
}

class PropertyPoliciesAndAmenities {
  final bool? present;
  final PolicyData? data;

  PropertyPoliciesAndAmenities({this.present, this.data});

  factory PropertyPoliciesAndAmenities.fromJson(Map<String, dynamic> json) =>
      PropertyPoliciesAndAmenities(
        present: json["present"],
        data: json["data"] == null ? null : PolicyData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"present": present, "data": data?.toJson()};
}

class PolicyData {
  final String? cancelPolicy;
  final String? refundPolicy;
  final String? childPolicy;
  final String? damagePolicy;
  final String? propertyRestriction;
  final bool? petsAllowed;
  final bool? coupleFriendly;
  final bool? suitableForChildren;
  final bool? bachularsAllowed;
  final bool? freeWifi;
  final bool? freeCancellation;
  final bool? payAtHotel;
  final bool? payNow;
  final String? lastUpdatedOn;

  PolicyData({
    this.cancelPolicy,
    this.refundPolicy,
    this.childPolicy,
    this.damagePolicy,
    this.propertyRestriction,
    this.petsAllowed,
    this.coupleFriendly,
    this.suitableForChildren,
    this.bachularsAllowed,
    this.freeWifi,
    this.freeCancellation,
    this.payAtHotel,
    this.payNow,
    this.lastUpdatedOn,
  });

  factory PolicyData.fromJson(Map<String, dynamic> json) => PolicyData(
    cancelPolicy: json["cancelPolicy"],
    refundPolicy: json["refundPolicy"],
    childPolicy: json["childPolicy"],
    damagePolicy: json["damagePolicy"],
    propertyRestriction: json["propertyRestriction"],
    petsAllowed: json["petsAllowed"],
    coupleFriendly: json["coupleFriendly"],
    suitableForChildren: json["suitableForChildren"],
    bachularsAllowed: json["bachularsAllowed"],
    freeWifi: json["freeWifi"],
    freeCancellation: json["freeCancellation"],
    payAtHotel: json["payAtHotel"],
    payNow: json["payNow"],
    lastUpdatedOn: json["lastUpdatedOn"],
  );

  Map<String, dynamic> toJson() => {
    "cancelPolicy": cancelPolicy,
    "refundPolicy": refundPolicy,
    "childPolicy": childPolicy,
    "damagePolicy": damagePolicy,
    "propertyRestriction": propertyRestriction,
    "petsAllowed": petsAllowed,
    "coupleFriendly": coupleFriendly,
    "suitableForChildren": suitableForChildren,
    "bachularsAllowed": bachularsAllowed,
    "freeWifi": freeWifi,
    "freeCancellation": freeCancellation,
    "payAtHotel": payAtHotel,
    "payNow": payNow,
    "lastUpdatedOn": lastUpdatedOn,
  };
}

class PropertyAddress {
  final String? street;
  final String? city;
  final String? state;
  final String? country;
  final String? zipcode;
  final String? mapAddress;
  final double? latitude;
  final double? longitude;

  PropertyAddress({
    this.street,
    this.city,
    this.state,
    this.country,
    this.zipcode,
    this.mapAddress,
    this.latitude,
    this.longitude,
  });

  factory PropertyAddress.fromJson(Map<String, dynamic> json) =>
      PropertyAddress(
        street: json["street"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        zipcode: json["zipcode"],
        mapAddress: json["mapAddress"],
        latitude: (json["latitude"] as num?)?.toDouble(),
        longitude: (json["longitude"] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
    "street": street,
    "city": city,
    "state": state,
    "country": country,
    "zipcode": zipcode,
    "mapAddress": mapAddress,
    "latitude": latitude,
    "longitude": longitude,
  };
}

class Price {
  final double? amount;
  final String? displayAmount;
  final String? currencyAmount;
  final String? currencySymbol;

  Price({
    this.amount,
    this.displayAmount,
    this.currencyAmount,
    this.currencySymbol,
  });

  factory Price.fromJson(Map<String, dynamic> json) => Price(
    amount: (json["amount"] as num?)?.toDouble(),
    displayAmount: json["displayAmount"],
    currencyAmount: json["currencyAmount"],
    currencySymbol: json["currencySymbol"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "displayAmount": displayAmount,
    "currencyAmount": currencyAmount,
    "currencySymbol": currencySymbol,
  };
}

class AvailableDeal {
  final String? headerName;
  final String? websiteUrl;
  final String? dealType;
  final Price? price;

  AvailableDeal({this.headerName, this.websiteUrl, this.dealType, this.price});

  factory AvailableDeal.fromJson(Map<String, dynamic> json) => AvailableDeal(
    headerName: json["headerName"],
    websiteUrl: json["websiteUrl"],
    dealType: json["dealType"],
    price: json["price"] == null ? null : Price.fromJson(json["price"]),
  );

  Map<String, dynamic> toJson() => {
    "headerName": headerName,
    "websiteUrl": websiteUrl,
    "dealType": dealType,
    "price": price?.toJson(),
  };
}

class SubscriptionStatus {
  final bool? status;

  SubscriptionStatus({this.status});

  factory SubscriptionStatus.fromJson(Map<String, dynamic> json) =>
      SubscriptionStatus(status: json["status"]);

  Map<String, dynamic> toJson() => {"status": status};
}

class SimplPriceList {
  final Price? simplPrice;
  final double? originalPrice;

  SimplPriceList({this.simplPrice, this.originalPrice});

  factory SimplPriceList.fromJson(Map<String, dynamic> json) => SimplPriceList(
    simplPrice: json["simplPrice"] == null
        ? null
        : Price.fromJson(json["simplPrice"]),
    originalPrice: (json["originalPrice"] as num?)?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "simplPrice": simplPrice?.toJson(),
    "originalPrice": originalPrice,
  };
}

class GoogleReview {
  final bool? reviewPresent;
  final ReviewData? data;

  GoogleReview({this.reviewPresent, this.data});

  factory GoogleReview.fromJson(Map<String, dynamic> json) => GoogleReview(
    reviewPresent: json["reviewPresent"],
    data: json["data"] == null ? null : ReviewData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "reviewPresent": reviewPresent,
    "data": data?.toJson(),
  };
}

class ReviewData {
  final double? overallRating;
  final int? totalUserRating;
  final int? withoutDecimal;

  ReviewData({this.overallRating, this.totalUserRating, this.withoutDecimal});

  factory ReviewData.fromJson(Map<String, dynamic> json) => ReviewData(
    overallRating: (json["overallRating"] as num?)?.toDouble(),
    totalUserRating: json["totalUserRating"],
    withoutDecimal: json["withoutDecimal"],
  );

  Map<String, dynamic> toJson() => {
    "overallRating": overallRating,
    "totalUserRating": totalUserRating,
    "withoutDecimal": withoutDecimal,
  };
}
