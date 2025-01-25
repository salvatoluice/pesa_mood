class Transaction {
  final DateTime date;
  final double amount;
  final String description;
  final TransactionType type;
  final String referenceNumber;

  const Transaction({
    required this.date,
    required this.amount,
    required this.description,
    required this.type,
    required this.referenceNumber,
  });

  bool get isBill => type == TransactionType.bill;
  bool get isSaving => type == TransactionType.saving;
  bool get isSplurge => type == TransactionType.splurge;
}

enum TransactionType { bill, saving, splurge }
