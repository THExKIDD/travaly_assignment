import 'package:flutter/material.dart';

class SearchFilterWidget extends StatelessWidget {
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

  const SearchFilterWidget({
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

  // Accommodation type options - matched with API
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

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: checkInDate != null && checkOutDate != null
          ? DateTimeRange(start: checkInDate!, end: checkOutDate!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFF6F61),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF2C2C2C),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFFF6F61),
              ),
            ),
          ),
          child: child!,
        );
      },
      helpText: 'Select Your Stay Duration',
      confirmText: 'Done',
      cancelText: 'Cancel',
      saveText: 'Select',
    );

    if (picked != null) {
      onCheckInDateSelected(picked.start);
      onCheckOutDateSelected(picked.end);
    }
  }

  void _showGuestRoomSelector(BuildContext context) {
    int tempRooms = rooms;
    int tempAdults = adults;
    int tempChildren = children;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 20),
              const Text(
                'Guests & Rooms',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2C2C2C),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select the number of guests and rooms',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 24),
              _buildCounterRow(
                'Rooms',
                tempRooms,
                Icons.meeting_room_outlined,
                (val) => setModalState(() => tempRooms = val),
              ),
              const Divider(height: 32),
              _buildCounterRow(
                'Adults',
                tempAdults,
                Icons.person_outline,
                (val) => setModalState(() => tempAdults = val),
                subtitle: 'Age 13+',
              ),
              const Divider(height: 32),
              _buildCounterRow(
                'Children',
                tempChildren,
                Icons.child_care_outlined,
                (val) => setModalState(() => tempChildren = val),
                subtitle: 'Age 0-12',
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    onGuestRoomUpdate(
                      rooms: tempRooms,
                      adults: tempAdults,
                      children: tempChildren,
                    );
                    Navigator.pop(context);
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
                    'Done',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCounterRow(
    String label,
    int value,
    IconData icon,
    Function(int) onChanged, {
    String? subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFFF6F61).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFFFF6F61), size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C2C2C),
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFFF6F61).withOpacity(0.3)),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove, size: 20),
                color: const Color(0xFFFF6F61),
                onPressed: value > (label == 'Adults' ? 1 : 0)
                    ? () => onChanged(value - 1)
                    : null,
              ),
              Container(
                width: 32,
                alignment: Alignment.center,
                child: Text(
                  '$value',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, size: 20),
                color: const Color(0xFFFF6F61),
                onPressed: value < 10 ? () => onChanged(value + 1) : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

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
                      onSearch();
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

  String _formatDate(DateTime date) {
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
    return '${date.day} ${months[date.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final nights = checkInDate != null && checkOutDate != null
        ? checkOutDate!.difference(checkInDate!).inDays
        : 0;
    final totalGuests = adults + children;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6F61).withOpacity(0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search Input
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Where do you want to go?',
                hintStyle: TextStyle(
                  color: const Color(0xFF6B6B6B).withOpacity(0.6),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Color(0xFFFF6F61),
                  size: 24,
                ),
                filled: true,
                fillColor: const Color(0xFFFFF5F4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              onSubmitted: (_) => onSearch(),
            ),
          ),

          const Divider(height: 1, color: Color(0xFFE0E0E0)),

          // Date Range Selector
          InkWell(
            onTap: () => _selectDateRange(context),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF6F61).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.calendar_month_outlined,
                                color: Color(0xFFFF6F61),
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Check-in',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF6B6B6B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          checkInDate != null
                              ? _formatDate(checkInDate!)
                              : 'Select date',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: checkInDate != null
                                ? const Color(0xFF2C2C2C)
                                : const Color(0xFF6B6B6B).withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (checkInDate != null && checkOutDate != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6F61).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.nights_stay_outlined,
                            size: 14,
                            color: Color(0xFFFF6F61),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$nights night${nights > 1 ? 's' : ''}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFF6F61),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF6F61).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.event_available_outlined,
                                color: Color(0xFFFF6F61),
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Check-out',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF6B6B6B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          checkOutDate != null
                              ? _formatDate(checkOutDate!)
                              : 'Select date',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: checkOutDate != null
                                ? const Color(0xFF2C2C2C)
                                : const Color(0xFF6B6B6B).withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Divider(height: 1, color: Color(0xFFE0E0E0)),

          // Guests & Filters Row
          IntrinsicHeight(
            child: Row(
              children: [
                // Guests & Rooms
                Expanded(
                  child: InkWell(
                    onTap: () => _showGuestRoomSelector(context),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFFFF6F61,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.people_outline_rounded,
                                  color: Color(0xFFFF6F61),
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Guests & Rooms',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF6B6B6B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$totalGuests Guest${totalGuests > 1 ? 's' : ''} • $rooms Room${rooms > 1 ? 's' : ''}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2C2C2C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(width: 1, color: const Color(0xFFE0E0E0)),
                // Filters
                Expanded(
                  child: InkWell(
                    onTap: () => _showFiltersModal(context),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFFFF6F61,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Stack(
                                  children: [
                                    const Icon(
                                      Icons.tune_rounded,
                                      color: Color(0xFFFF6F61),
                                      size: 16,
                                    ),
                                    if (selectedAccommodationTypes.first !=
                                            'all' ||
                                        minPrice != 0 ||
                                        maxPrice != 50000)
                                      Positioned(
                                        right: -2,
                                        top: -2,
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
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Filters',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF6B6B6B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            selectedAccommodationTypes.first == 'all'
                                ? 'All Properties'
                                : '${selectedAccommodationTypes.length} Type${selectedAccommodationTypes.length > 1 ? 's' : ''}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2C2C2C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFE0E0E0)),

          // Search Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onSearch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6F61),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_rounded, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Search Hotels',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
