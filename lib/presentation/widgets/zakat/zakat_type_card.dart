import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../data/models/zakat_model.dart';

class ZakatTypeCard extends StatelessWidget {
  final ZakatTypeInfo zakatTypeInfo;
  final VoidCallback onTap;

  const ZakatTypeCard({
    super.key,
    required this.zakatTypeInfo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _getZakatTypeColor(zakatTypeInfo.type).withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _getZakatTypeColor(zakatTypeInfo.type).withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getZakatTypeColor(zakatTypeInfo.type).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getZakatTypeIcon(zakatTypeInfo.type),
                      color: _getZakatTypeColor(zakatTypeInfo.type),
                      size: 20,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Title
              Text(
                zakatTypeInfo.nameIndonesian,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              
              // English name
              Text(
                zakatTypeInfo.name,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              
              // Rate or special info
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: _getZakatTypeColor(zakatTypeInfo.type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _getZakatRateText(zakatTypeInfo),
                  style: TextStyle(
                    color: _getZakatTypeColor(zakatTypeInfo.type),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              
              // Description
              Text(
                zakatTypeInfo.descriptionIndonesian,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                  height: 1.3,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getZakatTypeColor(ZakatType type) {
    switch (type) {
      case ZakatType.wealth:
        return AppColors.primary;
      case ZakatType.fitrah:
        return AppColors.secondary;
      case ZakatType.goldSilver:
        return const Color(0xFFFFD700); // Gold color
      case ZakatType.trade:
        return AppColors.info;
      case ZakatType.agriculture:
        return AppColors.success;
      case ZakatType.livestock:
        return const Color(0xFF8BC34A); // Light green
      case ZakatType.investment:
        return const Color(0xFF9C27B0); // Purple
      case ZakatType.profession:
        return const Color(0xFF607D8B); // Blue grey
      case ZakatType.savings:
        return const Color(0xFF00BCD4); // Cyan
    }
  }

  IconData _getZakatTypeIcon(ZakatType type) {
    switch (type) {
      case ZakatType.wealth:
        return Icons.account_balance_wallet;
      case ZakatType.fitrah:
        return Icons.rice_bowl;
      case ZakatType.goldSilver:
        return Icons.diamond;
      case ZakatType.trade:
        return Icons.store;
      case ZakatType.agriculture:
        return Icons.agriculture;
      case ZakatType.livestock:
        return Icons.pets;
      case ZakatType.investment:
        return Icons.trending_up;
      case ZakatType.profession:
        return Icons.work;
      case ZakatType.savings:
        return Icons.savings;
    }
  }

  String _getZakatRateText(ZakatTypeInfo zakatInfo) {
    switch (zakatInfo.type) {
      case ZakatType.fitrah:
        return '2.5kg Beras';
      case ZakatType.agriculture:
        return '5-10%';
      case ZakatType.livestock:
        return 'Per Ekor';
      default:
        return '${(zakatInfo.zakatRate * 100).toStringAsFixed(1)}%';
    }
  }
} 