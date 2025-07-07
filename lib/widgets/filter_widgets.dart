import 'package:flutter/material.dart';

class FilterPanel extends StatelessWidget {
  final TextEditingController searchController;
  final List<String> categories;
  final String selectedCategory;
  final RangeValues priceMrpRange;
  final RangeValues onlineSpRange;
  final double minPriceMrp;
  final double maxPriceMrp;
  final double minOnlineSp;
  final double maxOnlineSp;
  final int filteredProductsCount;
  final VoidCallback onSearchChanged;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<RangeValues> onPriceMrpChanged;
  final ValueChanged<RangeValues> onOnlineSpChanged;
  final VoidCallback onClearFilters;

  const FilterPanel({
    super.key,
    required this.searchController,
    required this.categories,
    required this.selectedCategory,
    required this.priceMrpRange,
    required this.onlineSpRange,
    required this.minPriceMrp,
    required this.maxPriceMrp,
    required this.minOnlineSp,
    required this.maxOnlineSp,
    required this.filteredProductsCount,
    required this.onSearchChanged,
    required this.onCategoryChanged,
    required this.onPriceMrpChanged,
    required this.onOnlineSpChanged,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FilterHeader(),
            const SizedBox(height: 24),
            SearchField(
              controller: searchController,
              onChanged: onSearchChanged,
            ),
            const SizedBox(height: 24),
            CategoryFilter(
              categories: categories,
              selectedCategory: selectedCategory,
              onChanged: onCategoryChanged,
            ),
            const SizedBox(height: 24),
            PriceRangeFilter(
              title: 'Price MRP Range',
              icon: Icons.currency_rupee_rounded,
              range: priceMrpRange,
              min: minPriceMrp,
              max: maxPriceMrp,
              colorType: PriceRangeColorType.primary,
              onChanged: onPriceMrpChanged,
            ),
            const SizedBox(height: 24),
            PriceRangeFilter(
              title: 'Online Price Range',
              icon: Icons.shopping_cart_rounded,
              range: onlineSpRange,
              min: minOnlineSp,
              max: maxOnlineSp,
              colorType: PriceRangeColorType.secondary,
              onChanged: onOnlineSpChanged,
            ),
            const SizedBox(height: 32),
            ResultsSummary(count: filteredProductsCount),
            const SizedBox(height: 16),
            ClearFiltersButton(onPressed: onClearFilters),
          ],
        ),
      ),
    );
  }
}

class FilterHeader extends StatelessWidget {
  const FilterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          Icons.filter_list_rounded,
          color: theme.colorScheme.primary,
          size: 24,
        ),
        const SizedBox(width: 8),
        Text(
          'Filters',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

class SearchField extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const SearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
      ),
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: 'Search by Code or Name',
          hintText: 'e.g., SUG001 or 10314',
          hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          prefixIcon: Icon(
            Icons.search,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(
            icon: Icon(
              Icons.clear,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            onPressed: () {
              widget.controller.clear();
              setState(() {});
            },
          )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
        onChanged: (value) {
          setState(() {});
          widget.onChanged();
        },
      ),
    );
  }
}

class CategoryFilter extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onChanged;

  const CategoryFilter({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FilterSection(
      title: 'Category',
      icon: Icons.category_rounded,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
          color: theme.colorScheme.surface,
        ),
        child: DropdownButtonFormField<String>(
          value: selectedCategory,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          dropdownColor: theme.colorScheme.surface,
          items: categories.map((category) {
            return DropdownMenuItem(
              value: category,
              child: Text(
                category,
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
            );
          }).toList(),
          onChanged: (value) => onChanged(value ?? 'All'),
        ),
      ),
    );
  }
}

enum PriceRangeColorType { primary, secondary }

class PriceRangeFilter extends StatelessWidget {
  final String title;
  final IconData icon;
  final RangeValues range;
  final double min;
  final double max;
  final PriceRangeColorType colorType;
  final ValueChanged<RangeValues> onChanged;

  const PriceRangeFilter({
    super.key,
    required this.title,
    required this.icon,
    required this.range,
    required this.min,
    required this.max,
    required this.colorType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Get colors based on type and theme
    final Color activeColor;
    final Color containerColor;
    final Color textColor;

    switch (colorType) {
      case PriceRangeColorType.primary:
        activeColor = theme.colorScheme.primary;
        containerColor = theme.colorScheme.primaryContainer;
        textColor = theme.colorScheme.onPrimaryContainer;
        break;
      case PriceRangeColorType.secondary:
        activeColor = theme.colorScheme.secondary;
        containerColor = theme.colorScheme.secondaryContainer;
        textColor = theme.colorScheme.onSecondaryContainer;
        break;
    }

    return FilterSection(
      title: title,
      icon: icon,
      child: Column(
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: activeColor,
              inactiveTrackColor: theme.colorScheme.outline.withOpacity(0.2),
              thumbColor: activeColor,
              overlayColor: activeColor.withOpacity(0.1),
              valueIndicatorColor: activeColor,
              valueIndicatorTextStyle: TextStyle(
                color: theme.colorScheme.onPrimary,
              ),
            ),
            child: RangeSlider(
              values: range,
              min: min,
              max: max,
              divisions: 50,
              labels: RangeLabels(
                '₹${range.start.toStringAsFixed(0)}',
                '₹${range.end.toStringAsFixed(0)}',
              ),
              onChanged: onChanged,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹${range.start.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                Text(
                  'to',
                  style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                ),
                Text(
                  '₹${range.end.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FilterSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const FilterSection({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: theme.colorScheme.onSurface,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

class ResultsSummary extends StatelessWidget {
  final int count;

  const ResultsSummary({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.primaryContainer.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.analytics_rounded,
            color: theme.colorScheme.primary,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            '$count',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          Text(
            'Products Found',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class ClearFiltersButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ClearFiltersButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.clear_all_rounded),
        label: const Text('Clear All Filters'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}