import 'package:assignment_travaly/presentation/home/data/models/hotel_model.dart';
import 'package:assignment_travaly/presentation/home/widgets/hotel_card.dart';
import 'package:flutter/material.dart';

class SearchResultsScreen extends StatelessWidget {
  final TextEditingController searchController;
  final List<Hotel> searchResults;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int rooms;
  final int adults;
  final int children;
  final bool isLoading;
  final bool hasMoreData;
  final ScrollController scrollController;
  final List<String> selectedAccommodationTypes;
  final double minPrice;
  final double maxPrice;
  final VoidCallback onBack;
  final Function({
    List<String>? accommodationTypes,
    double? minPrice,
    double? maxPrice,
  })
  onFiltersUpdate;
  final VoidCallback onApplyFilters;

  const SearchResultsScreen({
    super.key,
    required this.searchController,
    required this.searchResults,
    required this.checkInDate,
    required this.checkOutDate,
    required this.rooms,
    required this.adults,
    required this.children,
    required this.isLoading,
    required this.hasMoreData,
    required this.scrollController,
    required this.selectedAccommodationTypes,
    required this.minPrice,
    required this.maxPrice,
    required this.onBack,
    required this.onFiltersUpdate,
    required this.onApplyFilters,
  });

  // Accommodation type options
  static final List<Map<String, dynamic>> _accommodationTypes = [
    {'value': 'all', 'label': 'All', 'icon': Icons.hotel},
    {'value': 'hotel', 'label': 'Hotel', 'icon': Icons.apartment},
    {'value': 'resort', 'label': 'Resort', 'icon': Icons.pool},
    {'value': 'Boat House', 'label': 'Boat House', 'icon': Icons.sailing},
    {'value': 'bedAndBreakfast', 'label': 'B&B', 'icon': Icons.bed},
    {'value': 'guestHouse', 'label': 'Guest House', 'icon': Icons.house},
    {
      'value': 'Holidayhome',
      'label': 'Holiday Home',
      'icon': Icons.home_outlined,
    },
    {'value': 'cottage', 'label': 'Cottage', 'icon': Icons.cottage},
    {
      'value': 'apartment',
      'label': 'Apartment',
      'icon': Icons.apartment_outlined,
    },
    {'value': 'Home Stay', 'label': 'Home Stay', 'icon': Icons.home_work},
    {'value': 'hostel', 'label': 'Hostel', 'icon': Icons.groups},
    {'value': 'Villa', 'label': 'Villa', 'icon': Icons.villa},
    {'value': 'Motel', 'label': 'Motel', 'icon': Icons.local_hotel},
    {
      'value': 'Capsule Hotel',
      'label': 'Capsule Hotel',
      'icon': Icons.king_bed,
    },
    {'value': 'co_living', 'label': 'Co-living', 'icon': Icons.people},
  ];

  void _showFiltersModal(BuildContext context) {
    List<String> tempAccommodationTypes = List.from(selectedAccommodationTypes);
    double tempMinPrice = minPrice;
    double tempMaxPrice = maxPrice;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text(
                          'Filters',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2C2C2C),
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              tempAccommodationTypes = ['all'];
                              tempMinPrice = 0;
                              tempMaxPrice = 50000;
                            });
                          },
                          child: const Text(
                            'Reset',
                            style: TextStyle(
                              color: Color(0xFFFF6F61),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Price Range
                      const Text(
                        'Price Range (per night)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2C2C2C),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF6F61).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(
                                    0xFFFF6F61,
                                  ).withOpacity(0.3),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Min Price',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF6B6B6B),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '₹${tempMinPrice.toInt()}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFFFF6F61),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF6F61).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(
                                    0xFFFF6F61,
                                  ).withOpacity(0.3),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Max Price',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF6B6B6B),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '₹${tempMaxPrice.toInt()}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFFFF6F61),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      RangeSlider(
                        values: RangeValues(tempMinPrice, tempMaxPrice),
                        min: 0,
                        max: 50000,
                        divisions: 100,
                        activeColor: const Color(0xFFFF6F61),
                        inactiveColor: const Color(0xFFFF6F61).withOpacity(0.2),
                        onChanged: (values) {
                          setModalState(() {
                            tempMinPrice = values.start;
                            tempMaxPrice = values.end;
                          });
                        },
                      ),
                      const SizedBox(height: 32),
                      // Accommodation Types
                      const Text(
                        'Property Type',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2C2C2C),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Select the type of accommodation you prefer',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _accommodationTypes.map((type) {
                          final isSelected = tempAccommodationTypes.contains(
                            type['value'],
                          );
                          return InkWell(
                            onTap: () {
                              setModalState(() {
                                if (type['value'] == 'all') {
                                  tempAccommodationTypes = ['all'];
                                } else {
                                  tempAccommodationTypes.remove('all');
                                  if (isSelected) {
                                    tempAccommodationTypes.remove(
                                      type['value'],
                                    );
                                    if (tempAccommodationTypes.isEmpty) {
                                      tempAccommodationTypes = ['all'];
                                    }
                                  } else {
                                    tempAccommodationTypes.add(type['value']);
                                  }
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFFF6F61)
                                    : Colors.white,
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFFFF6F61)
                                      : const Color(0xFFE0E0E0),
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    type['icon'],
                                    size: 18,
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF6B6B6B),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    type['label'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? Colors.white
                                          : const Color(0xFF2C2C2C),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              // Footer
              Container(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 16,
                  bottom: MediaQuery.of(context).padding.bottom + 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      onFiltersUpdate(
                        accommodationTypes: tempAccommodationTypes,
                        minPrice: tempMinPrice,
                        maxPrice: tempMaxPrice,
                      );
                      Navigator.pop(context);
                      onApplyFilters();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6F61),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Apply Filters',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final nights = checkOutDate.difference(checkInDate).inDays;
    final totalGuests = adults + children;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        onBack();
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF5F4), Color(0xFFFFF0EE), Color(0xFFFFE8E5)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with back button
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
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
                          Icons.arrow_back_rounded,
                          color: Color(0xFFFF6F61),
                        ),
                        onPressed: onBack,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Search Results',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2C2C2C),
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            'for "${searchController.text}"',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B6B6B),
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
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
                        icon: Stack(
                          children: [
                            const Icon(
                              Icons.tune_rounded,
                              color: Color(0xFFFF6F61),
                            ),
                            if (selectedAccommodationTypes.first != 'all' ||
                                minPrice != 0 ||
                                maxPrice != 50000)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFF6F61),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        onPressed: () => _showFiltersModal(context),
                      ),
                    ),
                  ],
                ),
              ),

              // Search Summary Card
              if (searchResults.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF6F61).withOpacity(0.12),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF6F61).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.hotel_rounded,
                                color: Color(0xFFFF6F61),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${searchResults.length} ${searchResults.length == 1 ? 'hotel' : 'hotels'} found',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF2C2C2C),
                                    ),
                                  ),
                                  Text(
                                    'Matching your preferences',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF5F4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today_rounded,
                                      size: 14,
                                      color: Color(0xFF6B6B6B),
                                    ),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        '${checkInDate.day} ${_getMonthName(checkInDate.month)} - ${checkOutDate.day} ${_getMonthName(checkOutDate.month)}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF2C2C2C),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFFFF6F61,
                                  ).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '$nights ${nights == 1 ? 'night' : 'nights'}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFFF6F61),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.people_outline_rounded,
                                    size: 14,
                                    color: Color(0xFF6B6B6B),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '$totalGuests, $rooms ${rooms == 1 ? 'room' : 'rooms'}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2C2C2C),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              // Results list
              Expanded(
                child: searchResults.isEmpty && isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFFF6F61),
                          strokeWidth: 3,
                        ),
                      )
                    : searchResults.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(40),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(28),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFFFF6F61,
                                  ).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.search_off_rounded,
                                  size: 64,
                                  color: Color(0xFFFF6F61),
                                ),
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'No Hotels Found',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF2C2C2C),
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Try adjusting your search criteria\nor filters to find more results',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 28),
                              ElevatedButton.icon(
                                onPressed: onBack,
                                icon: const Icon(
                                  Icons.arrow_back_rounded,
                                  size: 18,
                                ),
                                label: const Text('Back to Search'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF6F61),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: searchResults.length + (hasMoreData ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == searchResults.length) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFFFF6F61,
                                        ).withOpacity(0.2),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Color(0xFFFF6F61),
                                      strokeWidth: 3,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }

                          final hotel = searchResults[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: HotelCard(hotel: hotel),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
