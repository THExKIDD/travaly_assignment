import 'package:assignment_travaly/presentation/home/data/models/search_results_model.dart';
import 'package:flutter/material.dart';

class HotelCard extends StatelessWidget {
  final Hotel hotel;

  const HotelCard({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    final hasReview = hotel.googleReview?.reviewPresent ?? false;
    final rating = hotel.googleReview?.data?.overallRating ?? 0.0;
    final reviewCount = hotel.googleReview?.data?.totalUserRating ?? 0;
    final displayPrice = hotel.propertyMinPrice?.displayAmount ?? '₹0';
    final imageUrl = hotel.propertyImage?.fullUrl ?? '';
    final hasFreeWifi =
        hotel.propertyPoliciesAndAmmenities?.data?.freeWifi ?? false;
    final hasFreeCancellation =
        hotel.propertyPoliciesAndAmmenities?.data?.freeCancellation ?? false;
    final isCoupleFriendly =
        hotel.propertyPoliciesAndAmmenities?.data?.coupleFriendly ?? false;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          // Hotel Image with Overlay
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 220,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFFFF6F61).withOpacity(0.3),
                                  const Color(0xFFFF8F84).withOpacity(0.3),
                                ],
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.hotel_rounded,
                                size: 64,
                                color: Color(0xFFFF6F61),
                              ),
                            ),
                          );
                        },
                      )
                    : Container(
                        height: 220,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFFFF6F61).withOpacity(0.3),
                              const Color(0xFFFF8F84).withOpacity(0.3),
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.hotel_rounded,
                            size: 64,
                            color: Color(0xFFFF6F61),
                          ),
                        ),
                      ),
              ),

              // Rating Badge (Google Review)
              if (hasReview && rating > 0)
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFFFB800),
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2C2C2C),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Favorite Icon
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    hotel.isFavorite == true
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: const Color(0xFFFF6F61),
                    size: 18,
                  ),
                ),
              ),

              // Property Type and Star Badge
              Positioned(
                bottom: 16,
                left: 16,
                child: Row(
                  children: [
                    if (hotel.propertyType != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6F61),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          hotel.propertyType!,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    if (hotel.propertyType != null &&
                        hotel.propertyStar != null &&
                        hotel.propertyStar! > 0)
                      const SizedBox(width: 8),
                    if (hotel.propertyStar != null && hotel.propertyStar! > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              size: 12,
                              color: Color(0xFFFFB800),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${hotel.propertyStar}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2C2C2C),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          // Hotel Details
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hotel Name
                Text(
                  hotel.propertyName ?? 'Property',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2C2C2C),
                    letterSpacing: -0.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),

                // Location
                if (hotel.propertyAddress != null)
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6F61).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.location_on_rounded,
                          size: 14,
                          color: Color(0xFFFF6F61),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          [
                            hotel.propertyAddress!.city,
                            hotel.propertyAddress!.state,
                            hotel.propertyAddress!.country,
                          ].where((e) => e != null && e.isNotEmpty).join(', '),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B6B6B),
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                // Reviews Count
                if (hasReview && reviewCount > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '($reviewCount ${reviewCount == 1 ? 'review' : 'reviews'})',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B6B6B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                // Amenities
                if (hasFreeWifi || hasFreeCancellation || isCoupleFriendly)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        if (hasFreeWifi)
                          _buildAmenityChip(Icons.wifi_rounded, 'Free WiFi'),
                        if (hasFreeCancellation)
                          _buildAmenityChip(
                            Icons.cancel_outlined,
                            'Free Cancellation',
                          ),
                        if (isCoupleFriendly)
                          _buildAmenityChip(
                            Icons.favorite_border,
                            'Couple Friendly',
                          ),
                      ],
                    ),
                  ),

                const SizedBox(height: 16),

                // Divider
                Container(height: 1, color: const Color(0xFFE0E0E0)),
                const SizedBox(height: 16),

                // Price and Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Price
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Starting from',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF6B6B6B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Flexible(
                                child: Text(
                                  displayPrice,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFFFF6F61),
                                    letterSpacing: -0.5,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Text(
                                '/night',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF6B6B6B),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),

                    // View Details Button
                    ElevatedButton(
                      onPressed: () {
                        // Handle navigation to hotel details
                      },
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
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'View Details',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.arrow_forward_rounded, size: 16),
                        ],
                      ),
                    ),
                  ],
                ),

                // Available Deals Indicator
                if (hotel.availableDeals != null &&
                    hotel.availableDeals!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF5F4),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFFF6F61).withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.local_offer_outlined,
                            size: 14,
                            color: Color(0xFFFF6F61),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${hotel.availableDeals!.length} ${hotel.availableDeals!.length == 1 ? 'deal' : 'deals'} available',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFF6F61),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFF6B6B6B)),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B6B6B),
            ),
          ),
        ],
      ),
    );
  }
}
