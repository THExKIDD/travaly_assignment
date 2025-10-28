import 'package:assignment_travaly/presentation/home/data/models/hotel_model.dart';
import 'package:assignment_travaly/presentation/home/screens/search_results.dart';
import 'package:assignment_travaly/presentation/home/widgets/hotel_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  // Sample hotel data
  final List<Hotel> _sampleHotels = [
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
    Hotel(
      name: 'Sunset Bay Hotel',
      city: 'Los Angeles',
      state: 'California',
      country: 'USA',
      rating: 4.9,
      pricePerNight: 329.99,
      imageUrl: 'https://picsum.photos/400/300?random=5',
    ),
    Hotel(
      name: 'Historic Downtown Hotel',
      city: 'Boston',
      state: 'Massachusetts',
      country: 'USA',
      rating: 4.4,
      pricePerNight: 219.99,
      imageUrl: 'https://picsum.photos/400/300?random=6',
    ),
  ];

  void _handleSearch() {
    String query = _searchController.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a search term')),
      );
      return;
    }

    // Navigate to search results page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsPage(searchQuery: query),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Hotels'),
        elevation: 0,
        actions: [IconButton(icon: const Icon(Icons.person), onPressed: () {})],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name, city, state, or country...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _searchController.clear(),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => _handleSearch(),
            ),
          ),

          // Hotel List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _sampleHotels.length,
              itemBuilder: (context, index) {
                final hotel = _sampleHotels[index];
                return HotelCard(hotel: hotel);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handleSearch,
        icon: const Icon(Icons.search),
        label: const Text('Search'),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
