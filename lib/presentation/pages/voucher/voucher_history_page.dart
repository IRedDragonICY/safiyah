import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/models/voucher_model.dart';
import '../../../data/services/voucher_history_service.dart';

class VoucherHistoryPage extends StatefulWidget {
  const VoucherHistoryPage({super.key});

  @override
  State<VoucherHistoryPage> createState() => _VoucherHistoryPageState();
}

class _VoucherHistoryPageState extends State<VoucherHistoryPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<VoucherModel> _usedVouchers = [];
  List<VoucherModel> _expiredVouchers = [];
  VoucherHistoryStats? _stats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadHistory();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    
    try {
      final service = VoucherHistoryService.instance;
      final usedVouchers = await service.getUsedVouchers();
      final expiredVouchers = await service.getExpiredVouchers();
      final stats = await service.getStatistics();
      
      setState(() {
        _usedVouchers = usedVouchers;
        _expiredVouchers = expiredVouchers;
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading history: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Voucher History',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'clear_history':
                  _showClearHistoryDialog();
                  break;
                case 'export_history':
                  _exportHistory();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'export_history',
                child: Row(
                  children: [
                    Icon(Icons.download, size: 20, color: colorScheme.onSurface),
                    const SizedBox(width: 12),
                    const Text('Export History'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'clear_history',
                child: Row(
                  children: [
                    Icon(Icons.clear_all, size: 20, color: colorScheme.error),
                    const SizedBox(width: 12),
                    const Text('Clear History'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle_outline),
                  const SizedBox(width: 8),
                  Text('Used (${_usedVouchers.length})'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.access_time),
                  const SizedBox(width: 8),
                  Text('Expired (${_expiredVouchers.length})'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (_stats != null) _buildStatsSection(theme, colorScheme),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildUsedVouchersTab(theme, colorScheme),
                      _buildExpiredVouchersTab(theme, colorScheme),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatsSection(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics, color: colorScheme.primary),
              const SizedBox(width: 12),
              Text(
                'Your Savings Summary',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Saved',
                  '\$${_stats!.totalSaved.toStringAsFixed(2)}',
                  Icons.savings,
                  colorScheme.primary,
                  theme,
                  colorScheme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'This Month',
                  '\$${_stats!.thisMonthSaved.toStringAsFixed(2)}',
                  Icons.calendar_month,
                  colorScheme.secondary,
                  theme,
                  colorScheme,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Used Vouchers',
                  '${_stats!.totalUsed}',
                  Icons.check_circle,
                  colorScheme.tertiary,
                  theme,
                  colorScheme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Expired',
                  '${_stats!.totalExpired}',
                  Icons.access_time,
                  colorScheme.error,
                  theme,
                  colorScheme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const Spacer(),
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsedVouchersTab(ThemeData theme, ColorScheme colorScheme) {
    if (_usedVouchers.isEmpty) {
      return _buildEmptyState(
        icon: Icons.check_circle_outline,
        title: 'No Used Vouchers',
        subtitle: 'Vouchers you use will appear here',
        theme: theme,
        colorScheme: colorScheme,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadHistory,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _usedVouchers.length,
        itemBuilder: (context, index) {
          final voucher = _usedVouchers[index];
          return _buildHistoryVoucherCard(voucher, theme, colorScheme);
        },
      ),
    );
  }

  Widget _buildExpiredVouchersTab(ThemeData theme, ColorScheme colorScheme) {
    if (_expiredVouchers.isEmpty) {
      return _buildEmptyState(
        icon: Icons.access_time,
        title: 'No Expired Vouchers',
        subtitle: 'Expired vouchers will appear here',
        theme: theme,
        colorScheme: colorScheme,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadHistory,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _expiredVouchers.length,
        itemBuilder: (context, index) {
          final voucher = _expiredVouchers[index];
          return _buildHistoryVoucherCard(voucher, theme, colorScheme);
        },
      ),
    );
  }

  Widget _buildHistoryVoucherCard(VoucherModel voucher, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          // Header with brand info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: voucher.brandColor.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    voucher.brandLogoUrl,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 40,
                      height: 40,
                      color: colorScheme.surfaceContainer,
                      child: Icon(
                        Icons.local_offer,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        voucher.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        voucher.brandName,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: voucher.statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        voucher.discountText,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: voucher.statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (voucher.savedAmount != null && voucher.savedAmount! > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'Saved \$${voucher.savedAmount!.toStringAsFixed(2)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status and time
                Row(
                  children: [
                    Icon(
                      voucher.status == VoucherStatus.used 
                          ? Icons.check_circle 
                          : Icons.access_time,
                      size: 16,
                      color: voucher.statusColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      voucher.status == VoucherStatus.used ? 'Used' : 'Expired',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: voucher.statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      voucher.timeSinceAction,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => _removeFromHistory(voucher),
                      icon: Icon(
                        Icons.delete_outline,
                        size: 20,
                        color: colorScheme.error,
                      ),
                      tooltip: 'Remove from history',
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Usage details
                if (voucher.usageDetails != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            voucher.usageDetails!,
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                
                // Code
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: voucher.code));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Code copied to clipboard!'),
                        backgroundColor: colorScheme.primary,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: colorScheme.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.confirmation_number,
                          size: 16,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Code: ${voucher.code}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.copy,
                          size: 16,
                          color: colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showClearHistoryDialog() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: colorScheme.error),
            const SizedBox(width: 8),
            const Text('Clear History'),
          ],
        ),
        content: const Text(
          'Are you sure you want to clear all voucher history? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              final primaryColor = colorScheme.primary;
              Navigator.pop(context);
              await VoucherHistoryService.instance.clearHistory();
              await _loadHistory();
              if (mounted) {
                messenger.showSnackBar(
                  SnackBar(
                    content: const Text('History cleared successfully'),
                    backgroundColor: primaryColor,
                  ),
                );
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _removeFromHistory(VoucherModel voucher) async {
    await VoucherHistoryService.instance.removeFromHistory(voucher.id);
    await _loadHistory();
    
    if (mounted) {
      final colorScheme = Theme.of(context).colorScheme;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Voucher removed from history'),
          backgroundColor: colorScheme.primary,
        ),
      );
    }
  }

  void _exportHistory() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Exporting voucher history...'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
} 
