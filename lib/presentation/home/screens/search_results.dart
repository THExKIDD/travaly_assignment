import 'package:assignment_travaly/presentation/home/data/models/hotel_model.dart';
import 'package:assignment_travaly/presentation/home/widgets/hotel_card.dart';
import 'package:flutter/material.dart';

class SearchResultsPage extends StatefulWidget {
  final String searchQuery;

  const SearchResultsPage({super.key, required this.searchQuery});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final ScrollController _scrollController = ScrollController();
  List<Hotel> _searchResults = [];
  int _currentPage = 1;
  final int _itemsPerPage = 10;
  bool _isLoading = false;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadInitialResults();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      if (!_isLoading && _hasMoreData) {
        _loadMoreResults();
      }
    }
  }

  void _loadInitialResults() {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call with mock data
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _searchResults = _generateMockResults(_currentPage);
        _isLoading = false;
      });
    });
  }

  void _loadMoreResults() {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call for pagination
    Future.delayed(const Duration(seconds: 1), () {
      _currentPage++;
      final newResults = _generateMockResults(_currentPage);

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

  List<Hotel> _generateMockResults(int page) {
    // Simulate API response with pagination
    // After 3 pages, return empty list to simulate no more data
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
        name: 'Hotel ${widget.searchQuery} ${globalIndex + 1}',
        city: cities[cityIndex],
        state: states[cityIndex],
        country: 'USA',
        rating: 4.0 + (globalIndex % 10) / 10,
        pricePerNight: 150.0 + (globalIndex * 20),
        imageUrl: 'https://picsum.photos/400/300?random=${globalIndex + 10}',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results for "${widget.searchQuery}"'),
        elevation: 0,
      ),
      body: _searchResults.isEmpty && _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _searchResults.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No results found',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Results count
                Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  color: Colors.grey.shade100,
                  child: Text(
                    '${_searchResults.length} hotels found',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // Results list
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _searchResults.length + (_hasMoreData ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _searchResults.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final hotel = _searchResults[index];
                      return HotelCard(hotel: hotel);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
