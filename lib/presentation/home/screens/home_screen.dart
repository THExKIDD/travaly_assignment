import 'package:assignment_travaly/presentation/home/data/models/hotel_model.dart';
import 'package:assignment_travaly/presentation/home/widgets/hotel_card.dart';
import 'package:assignment_travaly/presentation/home/widgets/search_filter_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController searchController;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final int rooms;
  final int adults;
  final int children;
  final List<String> selectedAccommodationTypes;
  final double minPrice;
  final double maxPrice;
  final VoidCallback onSearch;
  final Function(DateTime) onCheckInDateSelected;
  final Function(DateTime) onCheckOutDateSelected;
  final Function({int? rooms, int? adults, int? children}) onGuestRoomUpdate;
  final Function({
    List<String>? accommodationTypes,
    double? minPrice,
    double? maxPrice,
  })
  onFiltersUpdate;

  const HomeScreen({
    super.key,
    required this.searchController,
    this.checkInDate,
    this.checkOutDate,
    required this.rooms,
    required this.adults,
    required this.children,
    required this.selectedAccommodationTypes,
    required this.minPrice,
    required this.maxPrice,
    required this.onSearch,
    required this.onCheckInDateSelected,
    required this.onCheckOutDateSelected,
    required this.onGuestRoomUpdate,
    required this.onFiltersUpdate,
  });

  // Sample hotel data for home
  static final List<Hotel> _sampleHotels = [
    Hotel(
      name: 'Grand Luxury Hotel',
      city: 'New York',
      state: 'New York',
      country: 'USA',
      rating: 4.8,
      pricePerNight: 299.99,
      imageUrl: 'https://picsum.photos/400/300?random=1',
    ),
    Hotel(
      name: 'Beach Paradise Resort',
      city: 'Miami',
      state: 'Florida',
      country: 'USA',
      rating: 4.6,
      pricePerNight: 249.99,
      imageUrl: 'https://picsum.photos/400/300?random=2',
    ),
    Hotel(
      name: 'Mountain View Lodge',
      city: 'Denver',
      state: 'Colorado',
      country: 'USA',
      rating: 4.7,
      pricePerNight: 179.99,
      imageUrl: 'https://picsum.photos/400/300?random=3',
    ),
    Hotel(
      name: 'City Center Inn',
      city: 'Chicago',
      state: 'Illinois',
      country: 'USA',
      rating: 4.5,
      pricePerNight: 199.99,
      imageUrl: 'https://picsum.photos/400/300?random=4',
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
                            color: const Color(0xFFFF6F61).withOpacity(0.15),
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

              // Search Filter Widget
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SearchFilterWidget(
                  searchController: searchController,
                  checkInDate: checkInDate,
                  checkOutDate: checkOutDate,
                  rooms: rooms,
                  adults: adults,
                  children: children,
                  selectedAccommodationTypes: selectedAccommodationTypes,
                  minPrice: minPrice,
                  maxPrice: maxPrice,
                  onSearch: onSearch,
                  onCheckInDateSelected: onCheckInDateSelected,
                  onCheckOutDateSelected: onCheckOutDateSelected,
                  onGuestRoomUpdate: onGuestRoomUpdate,
                  onFiltersUpdate: onFiltersUpdate,
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
  }
}
