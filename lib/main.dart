import 'package:assignment_travaly/core/services/dio/dio_client.dart';
import 'package:assignment_travaly/presentation/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DioClient().initialize();
  runApp(const HotelBookingApp());
}

class HotelBookingApp extends StatelessWidget {
  const HotelBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel Booking',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const GoogleSignInPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
