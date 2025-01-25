// Constants should be @immutable and only contain static members
import 'package:flutter/material.dart';

@immutable
class AppConstants {
  static const String appName = 'M-Pesa Mood Ring';
  static const double maxRingSize = 300.0;
  
  const AppConstants._();
}
