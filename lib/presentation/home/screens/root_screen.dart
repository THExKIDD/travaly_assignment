import 'package:assignment_travaly/presentation/home/bloc/hotel_search_bloc.dart';
import 'package:assignment_travaly/presentation/home/bloc/hotel_search_event.dart';
import 'package:assignment_travaly/presentation/home/bloc/hotel_search_state.dart';
import 'package:assignment_travaly/presentation/home/screens/home_screen.dart';
import 'package:assignment_travaly/presentation/home/screens/search_results.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnifiedHomePage extends StatefulWidget {
  const UnifiedHomePage({super.key});

  @override
  State<UnifiedHomePage> createState() => _UnifiedHomePageState();
}

class _UnifiedHomePageState extends State<UnifiedHomePage> {
  final PageController _pageController = PageController();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

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
    final bloc = context.read<HotelSearchBloc>();
    final state = bloc.state;

    if (!state.isSearchMode) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      if (!state.isLoadingMore && state.hasMoreData) {
        bloc.add(const LoadMoreResults());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HotelSearchBloc(),
      child: BlocConsumer<HotelSearchBloc, HotelSearchState>(
        listener: (context, state) {
          // Handle error messages
          if (state.hasError && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: const Color(0xFFFF6F61),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.all(16),
              ),
            );
          }

          // Navigate to search results when search mode is enabled
          if (state.isSearchMode && _pageController.page != 1) {
            _pageController.animateToPage(
              1,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          }

          // Navigate back to home when search mode is disabled
          if (!state.isSearchMode && _pageController.page != 0) {
            _pageController.animateToPage(
              0,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (page) {
                if (page == 0 && state.isSearchMode) {
                  context.read<HotelSearchBloc>().add(const NavigateToHome());
                }
              },
              children: [
                HomeScreen(searchController: _searchController),
                SearchResultsScreen(searchController: _searchController),
              ],
            ),
          );
        },
      ),
    );
  }
}
