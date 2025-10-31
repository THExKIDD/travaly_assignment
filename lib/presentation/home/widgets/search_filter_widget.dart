import 'package:assignment_travaly/core/theme/app_theme_data.dart';
import 'package:assignment_travaly/presentation/home/bloc/hotel_search_bloc.dart';
import 'package:assignment_travaly/presentation/home/bloc/hotel_search_event.dart';
import 'package:assignment_travaly/presentation/home/bloc/hotel_search_state.dart';
import 'package:assignment_travaly/presentation/home/data/models/accomodation_type_model.dart';
import 'package:assignment_travaly/presentation/home/data/models/search_autocomplete_model.dart';
import 'package:assignment_travaly/presentation/home/widgets/autocomplete_overlay.dart';
import 'package:assignment_travaly/presentation/home/widgets/filter_bottomsheet.dart';
import 'package:assignment_travaly/presentation/home/widgets/guest_room_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchFilterWidget extends StatefulWidget {
  final TextEditingController searchController;

  const SearchFilterWidget({super.key, required this.searchController});

  // Accommodation type options - matched with API
  static final List<AccommodationTypeModel> accommodationTypes = [
    AccommodationTypeModel(value: 'all', label: 'All', icon: Icons.hotel),
    AccommodationTypeModel(
      value: 'hotel',
      label: 'Hotel',
      icon: Icons.apartment,
    ),
    AccommodationTypeModel(value: 'resort', label: 'Resort', icon: Icons.pool),
    AccommodationTypeModel(
      value: 'Boat House',
      label: 'Boat House',
      icon: Icons.sailing,
    ),
    AccommodationTypeModel(
      value: 'bedAndBreakfast',
      label: 'B&B',
      icon: Icons.bed,
    ),
    AccommodationTypeModel(
      value: 'guestHouse',
      label: 'Guest House',
      icon: Icons.house,
    ),
    AccommodationTypeModel(
      value: 'Holidayhome',
      label: 'Holiday Home',
      icon: Icons.home_outlined,
    ),
    AccommodationTypeModel(
      value: 'cottage',
      label: 'Cottage',
      icon: Icons.cottage,
    ),
    AccommodationTypeModel(
      value: 'apartment',
      label: 'Apartment',
      icon: Icons.apartment_outlined,
    ),
    AccommodationTypeModel(
      value: 'Home Stay',
      label: 'Home Stay',
      icon: Icons.home_work,
    ),
    AccommodationTypeModel(
      value: 'hostel',
      label: 'Hostel',
      icon: Icons.groups,
    ),
    AccommodationTypeModel(value: 'Villa', label: 'Villa', icon: Icons.villa),
    AccommodationTypeModel(
      value: 'Motel',
      label: 'Motel',
      icon: Icons.local_hotel,
    ),
    AccommodationTypeModel(
      value: 'Capsule Hotel',
      label: 'Capsule Hotel',
      icon: Icons.king_bed,
    ),
    AccommodationTypeModel(
      value: 'co_living',
      label: 'Co-living',
      icon: Icons.people,
    ),
  ];

  @override
  State<SearchFilterWidget> createState() => _SearchFilterWidgetState();
}

class _SearchFilterWidgetState extends State<SearchFilterWidget> {
  bool _hasText = false;
  final FocusNode _searchFocusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _searchFieldKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isAutocompleteVisible = false;

  @override
  void initState() {
    super.initState();
    widget.searchController.addListener(_onTextChanged);
    _searchFocusNode.addListener(_onFocusChanged);
    _hasText = widget.searchController.text.isNotEmpty;
  }

  @override
  void dispose() {
    if (mounted && !_searchFocusNode.hasFocus) {
      _removeOverlay();
    }
    widget.searchController.removeListener(_onTextChanged);
    _searchFocusNode.removeListener(_onFocusChanged);
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasTextNow = widget.searchController.text.isNotEmpty;
    if (hasTextNow != _hasText) {
      setState(() {
        _hasText = hasTextNow;
      });
    }
  }

  void _onFocusChanged() {
    if (!_searchFocusNode.hasFocus) {
      // Delay removal to allow tap on suggestions
      Future.delayed(const Duration(milliseconds: 200), () {
        if (!_searchFocusNode.hasFocus) {
          _removeOverlay();
        }
      });
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    /*    if (mounted) {
      setState(() {
        _isAutocompleteVisible = false;
      });
    }*/
  }

  void _showAutocompleteOverlay(List<AutocompleteItem> suggestions) {
    _removeOverlay();

    if (suggestions.isEmpty || !_searchFocusNode.hasFocus) return;

    _overlayEntry = _createOverlayEntry(suggestions);
    Overlay.of(context).insert(_overlayEntry!);
    if (mounted) {
      setState(() {
        _isAutocompleteVisible = false;
      });
    }
  }

  OverlayEntry _createOverlayEntry(List<AutocompleteItem> suggestions) {
    RenderBox? renderBox =
        _searchFieldKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox == null) {
      return OverlayEntry(builder: (context) => const SizedBox.shrink());
    }

    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Invisible barrier to detect taps outside
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                // Tap outside to close
                _searchFocusNode.unfocus();
                _removeOverlay();
              },
              child: Container(color: Colors.transparent),
            ),
          ),
          // Main overlay content
          Positioned(
            left: offset.dx + 16,
            top: offset.dy + size.height + 4,
            width: size.width - 32,
            child: AutocompleteOverlay(
              suggestions: suggestions,
              onSuggestionTap: (result) {
                widget.searchController.text = result.valueToDisplay;
                _searchFocusNode.unfocus();

                context.read<HotelSearchBloc>().add(
                  AutocompleteResultSelected(
                    query: result.valueToDisplay,
                    searchType: result.searchArray.type,
                    searchQueries: result.searchArray.query,
                  ),
                );

                _removeOverlay();
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDateRange(
    BuildContext context,
    HotelSearchState state,
  ) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: state.checkInDate != null && state.checkOutDate != null
          ? DateTimeRange(start: state.checkInDate!, end: state.checkOutDate!)
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

    if (picked != null && mounted) {
      context.read<HotelSearchBloc>().add(
        DateRangeSelected(checkIn: picked.start, checkOut: picked.end),
      );
    }
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
    return BlocConsumer<HotelSearchBloc, HotelSearchState>(
      listener: (context, state) {
        // Update autocomplete overlay based on state
        if (state.autocompleteStatus == AutocompleteStatus.success &&
            state.autocompleteResults.isNotEmpty &&
            _searchFocusNode.hasFocus) {
          _showAutocompleteOverlay(state.autocompleteResults);
        } else if (state.autocompleteResults.isEmpty ||
            state.autocompleteStatus == AutocompleteStatus.initial) {
          _removeOverlay();
        }
      },
      builder: (context, state) {
        final nights = state.numberOfNights;
        final totalGuests = state.totalGuests;

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
                key: _searchFieldKey,
                padding: const EdgeInsets.all(16),
                child: TextField(
                  focusNode: _searchFocusNode,
                  onChanged: (value) {
                    context.read<HotelSearchBloc>().add(
                      SearchQueryChanged(value),
                    );
                    context.read<HotelSearchBloc>().add(
                      FetchAutocomplete(value),
                    );
                  },
                  // onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  controller: widget.searchController,
                  decoration: InputDecoration(
                    hintText: 'Where do you want to go?',
                    hintStyle: TextStyle(
                      color: const Color(0xFF6B6B6B).withOpacity(0.6),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon:
                        state.autocompleteStatus == AutocompleteStatus.loading
                        ? Padding(
                            padding: const EdgeInsets.all(12),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  const Color(0xFFFF6F61),
                                ),
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.search_rounded,
                            color: Color(0xFFFF6F61),
                            size: 24,
                          ),
                    suffixIcon: _hasText
                        ? IconButton(
                            onPressed: () {
                              widget.searchController.clear();
                              context.read<HotelSearchBloc>().add(
                                const SearchQueryCleared(),
                              );
                              _removeOverlay();
                            },
                            icon: Icon(
                              Icons.close,
                              color: AppTheme.primaryCoral,
                            ),
                          )
                        : null,
                    filled: true,
                    fillColor: const Color(0xFFFFF5F4),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Color(0xFFFF6F61),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  onSubmitted: (_) {
                    _removeOverlay();
                    context.read<HotelSearchBloc>().add(
                      const SearchSubmitted(),
                    );
                  },
                ),
              ),

              const Divider(height: 1, color: Color(0xFFE0E0E0)),

              // Date Range Selector
              InkWell(
                onTap: () => _selectDateRange(context, state),
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
                                    color: const Color(
                                      0xFFFF6F61,
                                    ).withOpacity(0.1),
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
                              state.checkInDate != null
                                  ? _formatDate(state.checkInDate!)
                                  : 'Select date',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: state.checkInDate != null
                                    ? const Color(0xFF2C2C2C)
                                    : const Color(0xFF6B6B6B).withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (state.checkInDate != null &&
                          state.checkOutDate != null)
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
                                    color: const Color(
                                      0xFFFF6F61,
                                    ).withOpacity(0.1),
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
                              state.checkOutDate != null
                                  ? _formatDate(state.checkOutDate!)
                                  : 'Select date',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: state.checkOutDate != null
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
                        onTap: () => showGuestRoomModal(context, state),
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
                                '$totalGuests Guest${totalGuests > 1 ? 's' : ''} • ${state.rooms} Room${state.rooms > 1 ? 's' : ''}',
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
                        onTap: () => showFilterModal(context, state),
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
                                        if (state.hasActiveFilters)
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
                                state.selectedAccommodationTypes.first == 'all'
                                    ? 'All Properties'
                                    : '${state.selectedAccommodationTypes.length} Type${state.selectedAccommodationTypes.length > 1 ? 's' : ''}',
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
                    onPressed: () {
                      _removeOverlay();
                      context.read<HotelSearchBloc>().add(
                        const SearchSubmitted(),
                      );
                    },
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
      },
    );
  }
}
