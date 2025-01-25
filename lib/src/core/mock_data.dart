import 'package:mpesa_mood_ring/src/features/mood_ring/providers/mood_provider.dart';

class MockTransactionService {
  static List<Map<String, dynamic>> mockTransactions = [
    {
      'date': DateTime.now().subtract(const Duration(hours: 2)),
      'amount': 2300.0,
      'description': 'KPLC Electricity Bill',
      'type': 'bill',
    },
    {
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'amount': 5000.0,
      'description': 'M-Shwari Savings',
      'type': 'saving',
    },
    {
      'date': DateTime.now().subtract(const Duration(hours: 4)),
      'amount': 1500.0,
      'description': 'Naivas Supermarket',
      'type': 'splurge',
    },
    {
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'amount': 4500.0,
      'description': 'Nairobi Water Bill',
      'type': 'bill',
    },
    {
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'amount': 10000.0,
      'description': 'Fixed Deposit',
      'type': 'saving',
    },
  ];

  static FinancialState get mockFinancialState => const FinancialState(
        savingsRatio: 0.4,
        billsRatio: 0.35,
        splurgeRatio: 0.25,
        financialMood: 'Stable Flow 💧',
        achievementBadge: '🌱 Mwanzo Mzuri',
      );
}
