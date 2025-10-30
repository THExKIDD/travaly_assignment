import 'package:assignment_travaly/presentation/home/data/models/hotel_model.dart';
import 'package:assignment_travaly/presentation/home/screens/home_screen.dart';
import 'package:assignment_travaly/presentation/home/screens/search_results.dart';
import 'package:flutter/material.dart';

class UnifiedHomePage extends StatefulWidget {
  const UnifiedHomePage({super.key});

  @override
  State<UnifiedHomePage> createState() => _UnifiedHomePageState();
}

class _UnifiedHomePageState extends State<UnifiedHomePage> {
  final PageController _pageController = PageController();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  int _currentPage = 0;
  bool _isSearchMode = false;

  // Search-related state
  List<Hotel> _searchResults = [];
  int _searchPage = 1;
  final int _itemsPerPage = 10;
  bool _isLoading = false;
  bool _hasMoreData = true;

  // API Search Parameters - NULLABLE DATES
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  int _rooms = 1;
  int _adults = 1;
  int _children = 0;
  String _searchType = 'city';
  List<String> _selectedAccommodationTypes = ['all'];
  List<String> _excludedSearchTypes = [];
  double _minPrice = 0;
  double _maxPrice = 50000;
  String _currency = 'INR';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_isSearchMode) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      if (!_isLoading && _hasMoreData) {
        _loadMoreResults();
      }
    }
  }

  void _handleSearch() {
    FocusScope.of(context).unfocus();
    String query = _searchController.text.trim();

    // Validation
    if (query.isEmpty) {
      _showSnackBar('Please enter a destination');
      return;
    }

    if (_checkInDate == null || _checkOutDate == null) {
      _showSnackBar('Please select check-in and check-out dates');
      return;
    }

    setState(() {
      _isSearchMode = true;
      _searchPage = 1;
      _hasMoreData = true;
      _searchResults = [];
    });

    _loadInitialResults(query);
    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFFF6F61),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Map<String, dynamic> _buildSearchPayload(String query) {
    // Only build payload if dates are selected
    if (_checkInDate == null || _checkOutDate == null) {
      return {};
    }

    return {
      "searchCriteria": {
        "checkIn":
            "${_checkInDate!.year}-${_checkInDate!.month.toString().padLeft(2, '0')}-${_checkInDate!.day.toString().padLeft(2, '0')}",
        "checkOut":
            "${_checkOutDate!.year}-${_checkOutDate!.month.toString().padLeft(2, '0')}-${_checkOutDate!.day.toString().padLeft(2, '0')}",
        "rooms": _rooms,
        "adults": _adults,
        "children": _children,
        "searchType": _searchType,
        "searchQuery": [query],
        "accommodation": _selectedAccommodationTypes,
        "arrayOfExcludedSearchType": _excludedSearchTypes,
        "highPrice": _maxPrice.toString(),
        "lowPrice": _minPrice.toString(),
        "limit": _itemsPerPage,
        "preloaderList": [],
        "currency": _currency,
        "rid": _searchPage - 1,
      },
    };
  }

  void _loadInitialResults(String query) {
    setState(() {
      _isLoading = true;
    });

    // Here you would call your actual API with _buildSearchPayload(query)
    // For now, using mock data
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _searchResults = _generateMockResults(_searchPage, query);
          _isLoading = false;
        });
      }
    });
  }

  void _loadMoreResults() {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;

      _searchPage++;
      final newResults = _generateMockResults(
        _searchPage,
        _searchController.text,
      );

      setState(() {
        if (newResults.isEmpty) {
          _hasMoreData = false;
        } else {
          _searchResults.addAll(newResults);
        }
        _isLoading = false;
      });
    });
  }

  List<Hotel> _generateMockResults(int page, String query) {
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

    return List.generate(_itemsPerPage, (index) {
      final globalIndex = (page - 1) * _itemsPerPage + index;
      final cityIndex = globalIndex % cities.length;

      return Hotel(
        name: 'Hotel $query ${globalIndex + 1}',
        city: cities[cityIndex],
        state: states[cityIndex],
        country: 'USA',
        rating: 4.0 + (globalIndex % 10) / 10,
        pricePerNight: 150.0 + (globalIndex * 20),
        imageUrl: 'https://picsum.photos/400/300?random=${globalIndex + 10}',
      );
    });
  }

  void _goBackToHome() {
    _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _updateCheckInDate(DateTime date) {
    setState(() {
      _checkInDate = date;
      // Auto-adjust checkout if it's before new check-in
      if (_checkOutDate != null &&
          _checkOutDate!.isBefore(_checkInDate!.add(const Duration(days: 1)))) {
        _checkOutDate = _checkInDate!.add(const Duration(days: 1));
      }
    });
  }

  void _updateCheckOutDate(DateTime date) {
    setState(() {
      _checkOutDate = date;
    });
  }

  void _updateGuestRoomData({int? rooms, int? adults, int? children}) {
    setState(() {
      if (rooms != null) _rooms = rooms;
      if (adults != null) _adults = adults;
      if (children != null) _children = children;
    });
  }

  void _updateFilters({
    List<String>? accommodationTypes,
    double? minPrice,
    double? maxPrice,
  }) {
    setState(() {
      if (accommodationTypes != null) {
        _selectedAccommodationTypes = accommodationTypes;
      }
      if (minPrice != null) _minPrice = minPrice;
      if (maxPrice != null) _maxPrice = maxPrice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (page) {
          setState(() {
            _currentPage = page;
            if (page == 0) {
              _isSearchMode = false;
            }
          });
        },
        children: [
          HomeScreen(
            searchController: _searchController,
            checkInDate: _checkInDate,
            checkOutDate: _checkOutDate,
            rooms: _rooms,
            adults: _adults,
            children: _children,
            selectedAccommodationTypes: _selectedAccommodationTypes,
            minPrice: _minPrice,
            maxPrice: _maxPrice,
            onSearch: _handleSearch,
            onCheckInDateSelected: _updateCheckInDate,
            onCheckOutDateSelected: _updateCheckOutDate,
            onGuestRoomUpdate: _updateGuestRoomData,
            onFiltersUpdate: _updateFilters,
          ),
          SearchResultsScreen(
            searchController: _searchController,
            searchResults: _searchResults,
            checkInDate: _checkInDate ?? DateTime.now(),
            checkOutDate:
                _checkOutDate ?? DateTime.now().add(const Duration(days: 1)),
            rooms: _rooms,
            adults: _adults,
            children: _children,
            isLoading: _isLoading,
            hasMoreData: _hasMoreData,
            scrollController: _scrollController,
            selectedAccommodationTypes: _selectedAccommodationTypes,
            minPrice: _minPrice,
            maxPrice: _maxPrice,
            onBack: _goBackToHome,
            onFiltersUpdate: _updateFilters,
            onApplyFilters: _handleSearch,
          ),
        ],
      ),
    );
  }
}
