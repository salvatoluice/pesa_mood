import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final navIndexProvider = StateProvider<int>((ref) => 0);

class ModernNavBar extends ConsumerWidget {
  const ModernNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navIndexProvider);
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: colors.surface.withOpacity(0.9), // Use theme surface color
          boxShadow: [
            BoxShadow(
              color: colors.shadow.withOpacity(0.1), // Use theme shadow color
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: BackdropFilter(
          filter: const ColorFilter.mode(Colors.white, BlendMode.overlay),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                index: 0,
                icon: Icons.analytics_rounded,
                label: 'Insights',
                currentIndex: currentIndex,
                onTap: () => ref.read(navIndexProvider.notifier).state = 0,
              ),
              _NavItem(
                index: 1,
                icon: Icons.account_balance_wallet_rounded,
                label: 'Accounts',
                currentIndex: currentIndex,
                onTap: () => ref.read(navIndexProvider.notifier).state = 1,
              ),
              _NavItem(
                index: 2,
                icon: Icons.swap_horiz_rounded,
                label: 'Transfer',
                currentIndex: currentIndex,
                onTap: () => ref.read(navIndexProvider.notifier).state = 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class _NavItem extends StatelessWidget {
  final int index;
  final IconData icon;
  final String label;
  final int currentIndex;
  final VoidCallback onTap;

  const _NavItem({
    required this.index,
    required this.icon,
    required this.label,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == currentIndex;
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color:
              isActive ? colors.primary.withOpacity(0.1) : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              ),
              child: isActive
                  ? Icon(
                      icon,
                      key: ValueKey('active-$index'),
                      color: colors.primary, // Use theme primary color
                      size: 28,
                    )
                  : Icon(
                      icon,
                      key: ValueKey('inactive-$index'),
                      color: colors.onSurface
                          .withOpacity(0.6), // Use theme onSurface color
                      size: 26,
                    ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              child: SizedBox(
                height: isActive ? 20 : 0,
                child: Text(
                  label,
                  style: TextStyle(
                    color: colors.primary, // Use theme primary color
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
