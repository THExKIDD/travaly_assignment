import 'package:assignment_travaly/presentation/home/bloc/hotel_search_bloc.dart';
import 'package:assignment_travaly/presentation/home/bloc/hotel_search_state.dart';
import 'package:assignment_travaly/presentation/home/widgets/hotel_card.dart';
import 'package:assignment_travaly/presentation/home/widgets/search_filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/search_results_model.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController searchController;

  const HomeScreen({super.key, required this.searchController});

  // Sample hotel data for home
  static final List<Hotel> _sampleHotels = [
    Hotel(
      propertyCode: 'PROP1001',
      propertyName: 'Grand Luxury Hotel',
      propertyImage: PropertyImage(
        fullUrl: 'https://picsum.photos/400/300?random=1',
        location: 'images/hotels/',
        imageName: 'grand_luxury.jpg',
      ),
      propertyType: 'Hotel',
      propertyStar: 5,
      propertyPoliciesAndAmmenities: PropertyPoliciesAndAmenities(
        present: true,
        data: PolicyData(
          freeWifi: true,
          freeCancellation: true,
          payAtHotel: true,
          petsAllowed: false,
          coupleFriendly: true,
          bachularsAllowed: true,
          suitableForChildren: true,
        ),
      ),
      propertyAddress: PropertyAddress(
        street: '123 Fifth Avenue',
        city: 'New York',
        state: 'New York',
        country: 'USA',
        zipcode: '10001',
        mapAddress: 'New York, New York, USA',
        latitude: 40.7589,
        longitude: -73.9851,
      ),
      propertyUrl: 'https://example.com/hotel/1',
      roomName: 'Deluxe Suite',
      numberOfAdults: 2,
      markedPrice: Price(
        amount: 359.99,
        displayAmount: '₹359',
        currencyAmount: '359.99',
        currencySymbol: '₹',
      ),
      propertyMinPrice: Price(
        amount: 299.99,
        displayAmount: '₹299',
        currencyAmount: '299.99',
        currencySymbol: '₹',
      ),
      propertyMaxPrice: Price(
        amount: 449.99,
        displayAmount: '₹449',
        currencyAmount: '449.99',
        currencySymbol: '₹',
      ),
      availableDeals: [
        AvailableDeal(
          headerName: 'Early Bird Special',
          websiteUrl: 'https://example.com/deals/1',
          dealType: 'discount',
          price: Price(
            amount: 269.99,
            displayAmount: '₹269',
            currencyAmount: '269.99',
            currencySymbol: '₹',
          ),
        ),
      ],
      subscriptionStatus: SubscriptionStatus(status: true),
      propertyView: 1250,
      isFavorite: false,
      simplPriceList: SimplPriceList(
        simplPrice: Price(
          amount: 284.99,
          displayAmount: '₹284',
          currencyAmount: '284.99',
          currencySymbol: '₹',
        ),
        originalPrice: 299.99,
      ),
      googleReview: GoogleReview(
        reviewPresent: true,
        data: ReviewData(
          overallRating: 4.8,
          totalUserRating: 523,
          withoutDecimal: 4,
        ),
      ),
    ),
    Hotel(
      propertyCode: 'PROP1002',
      propertyName: 'Beach Paradise Resort',
      propertyImage: PropertyImage(
        fullUrl: 'https://picsum.photos/400/300?random=2',
        location: 'images/hotels/',
        imageName: 'beach_paradise.jpg',
      ),
      propertyType: 'Resort',
      propertyStar: 4,
      propertyPoliciesAndAmmenities: PropertyPoliciesAndAmenities(
        present: true,
        data: PolicyData(
          freeWifi: true,
          freeCancellation: false,
          payAtHotel: false,
          petsAllowed: true,
          coupleFriendly: true,
          bachularsAllowed: false,
          suitableForChildren: true,
        ),
      ),
      propertyAddress: PropertyAddress(
        street: '456 Ocean Drive',
        city: 'Miami',
        state: 'Florida',
        country: 'USA',
        zipcode: '33139',
        mapAddress: 'Miami, Florida, USA',
        latitude: 25.7907,
        longitude: -80.1300,
      ),
      propertyUrl: 'https://example.com/hotel/2',
      roomName: 'Ocean View Room',
      numberOfAdults: 2,
      markedPrice: Price(
        amount: 299.99,
        displayAmount: '₹299',
        currencyAmount: '299.99',
        currencySymbol: '₹',
      ),
      propertyMinPrice: Price(
        amount: 249.99,
        displayAmount: '₹249',
        currencyAmount: '249.99',
        currencySymbol: '₹',
      ),
      propertyMaxPrice: Price(
        amount: 349.99,
        displayAmount: '₹349',
        currencyAmount: '349.99',
        currencySymbol: '₹',
      ),
      availableDeals: [
        AvailableDeal(
          headerName: 'Summer Getaway',
          websiteUrl: 'https://example.com/deals/2',
          dealType: 'special',
          price: Price(
            amount: 224.99,
            displayAmount: '₹224',
            currencyAmount: '224.99',
            currencySymbol: '₹',
          ),
        ),
      ],
      subscriptionStatus: SubscriptionStatus(status: false),
      propertyView: 987,
      isFavorite: false,
      simplPriceList: SimplPriceList(
        simplPrice: Price(
          amount: 237.49,
          displayAmount: '₹237',
          currencyAmount: '237.49',
          currencySymbol: '₹',
        ),
        originalPrice: 249.99,
      ),
      googleReview: GoogleReview(
        reviewPresent: true,
        data: ReviewData(
          overallRating: 4.6,
          totalUserRating: 412,
          withoutDecimal: 4,
        ),
      ),
    ),
    Hotel(
      propertyCode: 'PROP1003',
      propertyName: 'Mountain View Lodge',
      propertyImage: PropertyImage(
        fullUrl: 'https://picsum.photos/400/300?random=3',
        location: 'images/hotels/',
        imageName: 'mountain_view.jpg',
      ),
      propertyType: 'Lodge',
      propertyStar: 4,
      propertyPoliciesAndAmmenities: PropertyPoliciesAndAmenities(
        present: true,
        data: PolicyData(
          freeWifi: true,
          freeCancellation: true,
          payAtHotel: true,
          petsAllowed: true,
          coupleFriendly: true,
          bachularsAllowed: true,
          suitableForChildren: true,
        ),
      ),
      propertyAddress: PropertyAddress(
        street: '789 Mountain Road',
        city: 'Denver',
        state: 'Colorado',
        country: 'USA',
        zipcode: '80202',
        mapAddress: 'Denver, Colorado, USA',
        latitude: 39.7392,
        longitude: -104.9903,
      ),
      propertyUrl: 'https://example.com/hotel/3',
      roomName: 'Mountain Suite',
      numberOfAdults: 2,
      markedPrice: Price(
        amount: 215.99,
        displayAmount: '₹215',
        currencyAmount: '215.99',
        currencySymbol: '₹',
      ),
      propertyMinPrice: Price(
        amount: 179.99,
        displayAmount: '₹179',
        currencyAmount: '179.99',
        currencySymbol: '₹',
      ),
      propertyMaxPrice: Price(
        amount: 269.99,
        displayAmount: '₹269',
        currencyAmount: '269.99',
        currencySymbol: '₹',
      ),
      availableDeals: [
        AvailableDeal(
          headerName: 'Adventure Package',
          websiteUrl: 'https://example.com/deals/3',
          dealType: 'package',
          price: Price(
            amount: 161.99,
            displayAmount: '₹161',
            currencyAmount: '161.99',
            currencySymbol: '₹',
          ),
        ),
      ],
      subscriptionStatus: SubscriptionStatus(status: true),
      propertyView: 756,
      isFavorite: false,
      simplPriceList: SimplPriceList(
        simplPrice: Price(
          amount: 170.99,
          displayAmount: '₹170',
          currencyAmount: '170.99',
          currencySymbol: '₹',
        ),
        originalPrice: 179.99,
      ),
      googleReview: GoogleReview(
        reviewPresent: true,
        data: ReviewData(
          overallRating: 4.7,
          totalUserRating: 298,
          withoutDecimal: 4,
        ),
      ),
    ),
    Hotel(
      propertyCode: 'PROP1004',
      propertyName: 'City Center Inn',
      propertyImage: PropertyImage(
        fullUrl: 'https://picsum.photos/400/300?random=4',
        location: 'images/hotels/',
        imageName: 'city_center.jpg',
      ),
      propertyType: 'Hotel',
      propertyStar: 4,
      propertyPoliciesAndAmmenities: PropertyPoliciesAndAmenities(
        present: true,
        data: PolicyData(
          freeWifi: true,
          freeCancellation: false,
          payAtHotel: true,
          petsAllowed: false,
          coupleFriendly: true,
          bachularsAllowed: true,
          suitableForChildren: false,
        ),
      ),
      propertyAddress: PropertyAddress(
        street: '321 Downtown Boulevard',
        city: 'Chicago',
        state: 'Illinois',
        country: 'USA',
        zipcode: '60601',
        mapAddress: 'Chicago, Illinois, USA',
        latitude: 41.8781,
        longitude: -87.6298,
      ),
      propertyUrl: 'https://example.com/hotel/4',
      roomName: 'Standard Room',
      numberOfAdults: 2,
      markedPrice: Price(
        amount: 239.99,
        displayAmount: '₹239',
        currencyAmount: '239.99',
        currencySymbol: '₹',
      ),
      propertyMinPrice: Price(
        amount: 199.99,
        displayAmount: '₹199',
        currencyAmount: '199.99',
        currencySymbol: '₹',
      ),
      propertyMaxPrice: Price(
        amount: 279.99,
        displayAmount: '₹279',
        currencyAmount: '279.99',
        currencySymbol: '₹',
      ),
      availableDeals: [
        AvailableDeal(
          headerName: 'Business Traveler Rate',
          websiteUrl: 'https://example.com/deals/4',
          dealType: 'discount',
          price: Price(
            amount: 179.99,
            displayAmount: '₹179',
            currencyAmount: '179.99',
            currencySymbol: '₹',
          ),
        ),
      ],
      subscriptionStatus: SubscriptionStatus(status: false),
      propertyView: 643,
      isFavorite: false,
      simplPriceList: SimplPriceList(
        simplPrice: Price(
          amount: 189.99,
          displayAmount: '₹189',
          currencyAmount: '189.99',
          currencySymbol: '₹',
        ),
        originalPrice: 199.99,
      ),
      googleReview: GoogleReview(
        reviewPresent: true,
        data: ReviewData(
          overallRating: 4.5,
          totalUserRating: 367,
          withoutDecimal: 4,
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HotelSearchBloc, HotelSearchState>(
      builder: (context, state) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFF5F4), Color(0xFFFFF0EE), Color(0xFFFFE8E5)],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF6F61).withOpacity(0.2),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/myTravaly.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFFFF6F61),
                                          Color(0xFFFF8F84),
                                        ],
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.apartment_rounded,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'My Travaly',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFFF6F61),
                                letterSpacing: -0.5,
                              ),
                            ),
                            Text(
                              'Discover your perfect stay',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B6B6B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFFF6F61,
                                ).withOpacity(0.15),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.person_outline,
                              color: Color(0xFFFF6F61),
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Search Filter Widget (now BLoC-enabled)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SearchFilterWidget(
                      searchController: searchController,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Section Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        const Text(
                          'Featured Hotels',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2C2C2C),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFFFF6F61),
                            padding: EdgeInsets.zero,
                          ),
                          child: const Row(
                            children: [
                              Text(
                                'See all',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward_rounded, size: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Hotel List
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: _sampleHotels.map((hotel) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: HotelCard(hotel: hotel),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
