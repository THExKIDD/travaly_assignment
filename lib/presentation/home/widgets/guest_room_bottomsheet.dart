import 'package:assignment_travaly/presentation/home/bloc/hotel_search_bloc.dart';
import 'package:assignment_travaly/presentation/home/bloc/hotel_search_event.dart';
import 'package:assignment_travaly/presentation/home/bloc/hotel_search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showGuestRoomModal(BuildContext context, HotelSearchState state) {
  int tempRooms = state.rooms;
  int tempAdults = state.adults;
  int tempChildren = state.children;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (modalContext) => StatefulBuilder(
      builder: (builderContext, setModalState) => Container(
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
                  context.read<HotelSearchBloc>().add(
                    GuestRoomDataUpdated(
                      rooms: tempRooms,
                      adults: tempAdults,
                      children: tempChildren,
                    ),
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
