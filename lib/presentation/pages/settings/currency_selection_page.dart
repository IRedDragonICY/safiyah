import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/currency_service.dart';

class CurrencySelectionPage extends StatefulWidget {
  const CurrencySelectionPage({super.key});

  @override
  State<CurrencySelectionPage> createState() => _CurrencySelectionPageState();
}

class _CurrencySelectionPageState extends State<CurrencySelectionPage> {
  final _searchController = TextEditingController();
  final _currencyService = CurrencyService();
  List<Currency> _filteredCurrencies = CurrencyService.currencies;
  String _searchQuery = '';
  Currency? _currentCurrency;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _currentCurrency = _currencyService.selectedCurrency;
    _currencyService.addListener(_onCurrencyChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _currencyService.removeListener(_onCurrencyChanged);
    super.dispose();
  }

  void _onCurrencyChanged() {
    if (mounted) {
      setState(() {
        _currentCurrency = _currencyService.selectedCurrency;
      });
    }
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _filteredCurrencies = _currencyService.searchCurrencies(_searchQuery);
    });
  }

  void _selectCurrency(Currency currency) async {
    // Update local state immediately for instant UI feedback
    setState(() {
      _currentCurrency = currency;
    });
    
    // Update the service
    await _currencyService.setCurrency(currency);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Text(currency.flag, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Currency changed to ${currency.name}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 2),
        ),
      );
      
      // Navigate back to settings after a short delay to show the snackbar
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          context.pop();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainer,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
        title: const Text('Select Currency'),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 2,
      ),
      body: Column(
        children: [
          // Search Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.1),
                  offset: const Offset(0, 1),
                  blurRadius: 3,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find your preferred currency',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                SearchBar(
                  controller: _searchController,
                  hintText: 'Search currencies...',
                  leading: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
                  trailing: [
                    if (_searchQuery.isNotEmpty)
                      IconButton(
                        onPressed: () {
                          _searchController.clear();
                        },
                        icon: Icon(Icons.clear, color: colorScheme.onSurfaceVariant),
                      ),
                  ],
                  elevation: WidgetStateProperty.all(0),
                  backgroundColor: WidgetStateProperty.all(colorScheme.surfaceContainerHighest),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _searchQuery.isEmpty
                ? _buildDefaultView()
                : _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultView() {
    return CustomScrollView(
      slivers: [
        // Current Selection
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Currency',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildCurrentCurrencyCard(),
              ],
            ),
          ),
        ),

        // Popular Currencies
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Popular Currencies',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final currency = _currencyService.popularCurrencies[index];
                return _buildPopularCurrencyCard(currency);
              },
              childCount: _currencyService.popularCurrencies.length,
            ),
          ),
        ),

        // All Currencies
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'All Currencies',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final currency = CurrencyService.currencies[index];
              return _buildCurrencyListTile(currency);
            },
            childCount: CurrencyService.currencies.length,
          ),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: 16),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    if (_filteredCurrencies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No currencies found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try searching with a different term',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: _filteredCurrencies.length,
      itemBuilder: (context, index) {
        final currency = _filteredCurrencies[index];
        return _buildCurrencyListTile(currency);
      },
    );
  }

  Widget _buildCurrentCurrencyCard() {
    final current = _currentCurrency ?? _currencyService.selectedCurrency;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              current.flag,
              style: const TextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  current.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  '${current.code} • ${current.symbol}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.check_circle,
            color: Theme.of(context).colorScheme.primary,
            size: 28,
          ),
        ],
      ),
    );
  }

  Widget _buildPopularCurrencyCard(Currency currency) {
    final isSelected = currency == (_currentCurrency ?? _currencyService.selectedCurrency);
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => _selectCurrency(currency),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected 
              ? colorScheme.primaryContainer
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? colorScheme.primary
                : colorScheme.outline.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              currency.flag,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    currency.code,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? colorScheme.primary : null,
                    ),
                  ),
                  Text(
                    currency.symbol,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isSelected 
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: colorScheme.primary,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyListTile(Currency currency) {
    final isSelected = currency == (_currentCurrency ?? _currencyService.selectedCurrency);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? colorScheme.primaryContainer.withValues(alpha: 0.3) : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: () => _selectCurrency(currency),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected 
                ? colorScheme.primary.withValues(alpha: 0.2)
                : colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            currency.flag,
            style: const TextStyle(fontSize: 20),
          ),
        ),
        title: Text(
          currency.name,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? colorScheme.primary : null,
          ),
        ),
        subtitle: Text(
          '${currency.code} • ${currency.symbol}',
          style: TextStyle(
            color: isSelected 
                ? colorScheme.onPrimaryContainer
                : colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: isSelected
            ? Icon(
                Icons.check_circle,
                color: colorScheme.primary,
              )
            : Icon(
                Icons.chevron_right,
                color: colorScheme.onSurfaceVariant,
              ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
} 