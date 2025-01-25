import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpesa_mood_ring/src/core/mock_data.dart';
import 'package:mpesa_mood_ring/src/features/mood_ring/providers/mood_provider.dart';
import 'package:mpesa_mood_ring/src/features/mood_ring/widgets/ring_painter.dart';

class FinancialMoodScreen extends ConsumerStatefulWidget {
  const FinancialMoodScreen({super.key});

  @override
  ConsumerState<FinancialMoodScreen> createState() =>
      _FinancialMoodScreenState();
}

class _FinancialMoodScreenState extends ConsumerState<FinancialMoodScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _particleController;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(financialProvider);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesa Pulse',
            style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: colors.primary),
            onPressed: () => ref.read(financialProvider.notifier).refreshData(),
            tooltip: 'Refresh insights',
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildPulseRing(state, context),
            _buildFinancialInsights(state, context),
            _buildTransactionHeader(),
            ...MockTransactionService.mockTransactions
                .map((t) => _buildTransactionTile(TransactionData.fromMap(t))),
          ],
        ),
      ),
    );
  }

  Widget _buildPulseRing(FinancialState state, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
            Theme.of(context).colorScheme.background,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulseController, _particleController]),
        builder: (context, _) => Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: Size(MediaQuery.of(context).size.width * 0.8, 300),
              painter: FinancialMoodPainter(
                savingsProgress: state.savingsRatio,
                billsProgress: state.billsRatio,
                splurgeProgress: state.splurgeRatio,
                pulseAnimation: _pulseController,
                particleAnimation: _particleController,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${(state.savingsRatio * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: [Colors.green.shade400, Colors.green.shade700],
                      ).createShader(
                        const Rect.fromLTWH(0, 0, 100, 50),
                      ),
                  ),
                ),
                Text(
                  'Savings Power',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialInsights(FinancialState state, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.rocket_launch_rounded,
                    color: Theme.of(context).colorScheme.primary, size: 32),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.achievementBadge,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        state.financialMood,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTransactionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.grey.shade800,
            ),
          ),
          Text(
            'View All',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionTile(TransactionData transaction) {
    final color = _getTransactionColor(transaction.type);
    final icon = _getTransactionIcon(transaction.type);
    final category = _getCategoryLabel(transaction.type);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.05), color.withOpacity(0.15)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          transaction.description,
          style: const TextStyle(fontWeight: FontWeight.w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          category,
          style: TextStyle(color: Colors.grey.shade600),
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'KES ${transaction.amount.toStringAsFixed(0)}',
              style: TextStyle(
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              _formatDate(transaction.date),
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12,
              ),
            ),
          ],
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Color _getTransactionColor(String type) {
    switch (type) {
      case 'bill':
        return Colors.blue;
      case 'saving':
        return Colors.green;
      case 'splurge':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getTransactionIcon(String type) {
    switch (type) {
      case 'bill':
        return Icons.receipt;
      case 'saving':
        return Icons.savings;
      case 'splurge':
        return Icons.shopping_cart;
      default:
        return Icons.attach_money;
    }
  }

  String _getCategoryLabel(String type) {
    switch (type) {
      case 'bill':
        return 'Bill Payment';
      case 'saving':
        return 'Savings';
      case 'splurge':
        return 'Shopping';
      default:
        return 'Transaction';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _particleController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class TransactionData {
  final DateTime date;
  final double amount;
  final String description;
  final String type;

  TransactionData({
    required this.date,
    required this.amount,
    required this.description,
    required this.type,
  });

  factory TransactionData.fromMap(Map<String, dynamic> map) {
    return TransactionData(
      date: map['date'] as DateTime,
      amount: (map['amount'] as num).toDouble(),
      description: map['description'] as String,
      type: map['type'] as String,
    );
  }
}
