import 'package:flutter/material.dart';
import 'package:load_control/presentation/views/onboarding/onboarding_view.dart';
import 'package:provider/provider.dart';
import 'presentation/viewmodels/flight_record_viewmodel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FlightRecordViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TGS-Turkish Ground Service',
        home: const OnboardingView(),
      ),
    );
  }
}
