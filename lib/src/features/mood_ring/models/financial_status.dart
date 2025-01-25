import 'package:flutter/material.dart';

@immutable
class FinancialStatus {
  final double savingsRate;
  final double billPercentage;
  final double discretionarySpending;

  const FinancialStatus({
    required this.savingsRate,
    required this.billPercentage,
    required this.discretionarySpending,
  });
}
