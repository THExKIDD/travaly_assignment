import 'package:assignment_travaly/presentation/home/data/models/search_autocomplete_model.dart';
import 'package:flutter/material.dart';

class AutocompleteOverlay extends StatelessWidget {
  final List<AutocompleteItem> suggestions;
  final Function(AutocompleteResult) onSuggestionTap;

  const AutocompleteOverlay({
    super.key,
    required this.suggestions,
    required this.onSuggestionTap,
  });

  IconData _getIconForSearchType(String type) {
    switch (type) {
      case 'hotelIdSearch':
        return Icons.hotel_rounded;
      case 'citySearch':
        return Icons.location_city_rounded;
      case 'stateSearch':
        return Icons.map_rounded;
      case 'countrySearch':
        return Icons.public_rounded;
      case 'streetSearch':
        return Icons.signpost_rounded;
      default:
        return Icons.search_rounded;
    }
  }

  String _formatAddress(Address address) {
    final parts = <String>[];
    if (address.city != null) parts.add(address.city!);
    if (address.state != null) parts.add(address.state!);
    if (address.country != null) parts.add(address.country!);
    return parts.join(', ');
  }

  Widget _buildHeaderItem(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF6B6B6B),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSuggestionItem(AutocompleteResult result) {
    return InkWell(
      onTap: () => onSuggestionTap(result),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6F61).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getIconForSearchType(result.searchArray.type),
                color: const Color(0xFFFF6F61),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.valueToDisplay,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C2C2C),
                    ),
                  ),
                  if (result.address != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      _formatAddress(result.address!),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: (_) {},
      onVerticalDragUpdate: (_) {},
      onVerticalDragEnd: (_) {},
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 400),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: suggestions.length,
              separatorBuilder: (context, index) {
                // Don't show separator after headers
                if (suggestions[index].isHeader) {
                  return const SizedBox.shrink();
                }
                return const Divider(height: 1, indent: 56, endIndent: 16);
              },
              itemBuilder: (context, index) {
                final item = suggestions[index];

                if (item.isHeader) {
                  return _buildHeaderItem(item.headerText!);
                }

                return _buildSuggestionItem(item.result!);
              },
            ),
          ),
        ),
      ),
    );
  }
}
