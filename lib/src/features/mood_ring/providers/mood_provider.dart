import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpesa_mood_ring/src/core/mock_data.dart';

@immutable
class FinancialState {
  final double savingsRatio;
  final double billsRatio;
  final double splurgeRatio;
  final String financialMood;
  final String achievementBadge;

  const FinancialState({
    required this.savingsRatio,
    required this.billsRatio,
    required this.splurgeRatio,
    required this.financialMood,
    required this.achievementBadge,
  });
}

class FinancialNotifier extends StateNotifier<FinancialState> {
  FinancialNotifier() : super(MockTransactionService.mockFinancialState);

  void refreshData() {
    final mockStates = [
      FinancialState(
        savingsRatio: 0.5,
        billsRatio: 0.3,
        splurgeRatio: 0.2,
        financialMood: 'Savings Champion! 🏆',
        achievementBadge: '💰 Akiba Master',
      ),
      FinancialState(
        savingsRatio: 0.3,
        billsRatio: 0.4,
        splurgeRatio: 0.3,
        financialMood: 'Balance Mzuri ⚖️',
        achievementBadge: '🎯 On Target',
      ),
      MockTransactionService.mockFinancialState,
    ];

    state = mockStates[DateTime.now().second % mockStates.length];
  }
}

final financialProvider =
    StateNotifierProvider<FinancialNotifier, FinancialState>(
  (ref) => FinancialNotifier(),
);
