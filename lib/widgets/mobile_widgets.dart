// ============================================================================
// MOBILE COMPONENTS - Complete with overflow fixes and GST pricing
// ============================================================================

import 'package:flutter/material.dart';
import '../models/product.dart';

class MobileSearchBar extends StatefulWidget {
  final TextEditingController searchController;
  final VoidCallback onSearchChanged;
  final VoidCallback onFilterPressed;

  const MobileSearchBar({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.onFilterPressed,
  });

  @override
  State<MobileSearchBar> createState() => _MobileSearchBarState();
}

class _MobileSearchBarState extends State<MobileSearchBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
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
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
                color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
              ),
              child: TextField(
                controller: widget.searchController,
                decoration: InputDecoration(
                  labelText: 'Search products...',
                  hintText: 'Code or Name',
                  hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                  prefixIcon: Icon(
                    Icons.search,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  suffixIcon: widget.searchController.text.isNotEmpty
                      ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () {
                      widget.searchController.clear();
                      setState(() {});
                      widget.onSearchChanged();
                    },
                  )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
                onChanged: (value) {
                  setState(() {});
                  widget.onSearchChanged();
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: widget.onFilterPressed,
              icon: Icon(
                Icons.tune_rounded,
                color: theme.colorScheme.onPrimary,
              ),
              tooltip: 'Advanced Filters',
            ),
          ),
        ],
      ),
    );
  }
}

class MobileFilterDialog extends StatefulWidget {
  final List<String> categories;
  final String selectedCategory;
  final RangeValues priceMrpRange;
  final RangeValues onlineSpRange;
  final double minPriceMrp;
  final double maxPriceMrp;
  final double minOnlineSp;
  final double maxOnlineSp;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<RangeValues> onPriceMrpChanged;
  final ValueChanged<RangeValues> onOnlineSpChanged;
  final VoidCallback onClearFilters;

  const MobileFilterDialog({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.priceMrpRange,
    required this.onlineSpRange,
    required this.minPriceMrp,
    required this.maxPriceMrp,
    required this.minOnlineSp,
    required this.maxOnlineSp,
    required this.onCategoryChanged,
    required this.onPriceMrpChanged,
    required this.onOnlineSpChanged,
    required this.onClearFilters,
  });

  @override
  State<MobileFilterDialog> createState() => _MobileFilterDialogState();
}

class _MobileFilterDialogState extends State<MobileFilterDialog> {
  late String _selectedCategory;
  late RangeValues _priceMrpRange;
  late RangeValues _onlineSpRange;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.selectedCategory;
    _priceMrpRange = widget.priceMrpRange;
    _onlineSpRange = widget.onlineSpRange;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outline.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.filter_list_rounded,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Advanced Filters',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Done',
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                ),
              ],
            ),
          ),

          // Filter content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Category filter
                  MobileFilterSection(
                    title: 'Category',
                    icon: Icons.category_rounded,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
                        color: theme.colorScheme.surface,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCategory,
                          isExpanded: true,
                          dropdownColor: theme.colorScheme.surface,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          items: widget.categories.map((category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Container(
                                constraints: const BoxConstraints(maxWidth: 250),
                                child: Text(
                                  category,
                                  style: TextStyle(color: theme.colorScheme.onSurface),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedCategory = value;
                              });
                              widget.onCategoryChanged(value);
                            }
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Price MRP range
                  MobileFilterSection(
                    title: 'Price MRP Range',
                    icon: Icons.currency_rupee_rounded,
                    child: Column(
                      children: [
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: theme.colorScheme.primary,
                            inactiveTrackColor: theme.colorScheme.outline.withOpacity(0.2),
                            thumbColor: theme.colorScheme.primary,
                            overlayColor: theme.colorScheme.primary.withOpacity(0.1),
                            valueIndicatorColor: theme.colorScheme.primary,
                            valueIndicatorTextStyle: TextStyle(
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                          child: RangeSlider(
                            values: _priceMrpRange,
                            min: widget.minPriceMrp,
                            max: widget.maxPriceMrp,
                            divisions: 50,
                            labels: RangeLabels(
                              '₹${_priceMrpRange.start.toStringAsFixed(0)}',
                              '₹${_priceMrpRange.end.toStringAsFixed(0)}',
                            ),
                            onChanged: (values) {
                              setState(() {
                                _priceMrpRange = values;
                              });
                              widget.onPriceMrpChanged(values);
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '₹${_priceMrpRange.start.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onPrimaryContainer,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  'to',
                                  style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '₹${_priceMrpRange.end.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onPrimaryContainer,
                                  ),
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Online SP range
                  MobileFilterSection(
                    title: 'Online Price Range',
                    icon: Icons.shopping_cart_rounded,
                    child: Column(
                      children: [
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: theme.colorScheme.secondary,
                            inactiveTrackColor: theme.colorScheme.outline.withOpacity(0.2),
                            thumbColor: theme.colorScheme.secondary,
                            overlayColor: theme.colorScheme.secondary.withOpacity(0.1),
                            valueIndicatorColor: theme.colorScheme.secondary,
                            valueIndicatorTextStyle: TextStyle(
                              color: theme.colorScheme.onSecondary,
                            ),
                          ),
                          child: RangeSlider(
                            values: _onlineSpRange,
                            min: widget.minOnlineSp,
                            max: widget.maxOnlineSp,
                            divisions: 50,
                            labels: RangeLabels(
                              '₹${_onlineSpRange.start.toStringAsFixed(0)}',
                              '₹${_onlineSpRange.end.toStringAsFixed(0)}',
                            ),
                            onChanged: (values) {
                              setState(() {
                                _onlineSpRange = values;
                              });
                              widget.onOnlineSpChanged(values);
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '₹${_onlineSpRange.start.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onSecondaryContainer,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  'to',
                                  style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '₹${_onlineSpRange.end.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onSecondaryContainer,
                                  ),
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Clear filters button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        widget.onClearFilters();
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.clear_all_rounded),
                      label: const Text('Clear All Filters'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MobileFilterSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const MobileFilterSection({
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
            Icon(icon, size: 20, color: theme.colorScheme.onSurface),
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

// ============================================================================
// PRODUCT DISPLAY COMPONENTS - Complete with overflow fixes
// ============================================================================

class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final Animation<double> fadeAnimation;

  const ProductGrid({
    super.key,
    required this.products,
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const EmptyProductsState();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 1400
        ? 4
        : screenWidth > 1000
        ? 3
        : screenWidth > 600
        ? 2
        : 1;

    // For mobile view, use a ListView for better appearance
    if (crossAxisCount == 1) {
      return FadeTransition(
        opacity: fadeAnimation,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: MobileProductCard(product: product, index: index),
            );
          },
        ),
      );
    }

    // For desktop view, keep the GridView
    return FadeTransition(
      opacity: fadeAnimation,
      child: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 0.75, // Adjusted for fixed height cards
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCard(product: product, index: index);
        },
      ),
    );
  }
}

class EmptyProductsState extends StatelessWidget {
  const EmptyProductsState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Products Found',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search criteria or filters',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final int index;

  const ProductCard({
    super.key,
    required this.product,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Card(
              elevation: 6,
              shadowColor: theme.colorScheme.shadow.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                height: 340, // Fixed height to prevent overflow
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.surface,
                      theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12), // Reduced padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProductCardHeader(product: product),
                      const SizedBox(height: 8), // Reduced spacing
                      const Flexible(
                        flex: 2,
                        child: ProductIcon(),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: ProductTitle(name: product.name),
                          ),
                          const SizedBox(width: 6), // Reduced spacing
                          CategoryBadge(category: product.category),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Flexible(
                        flex: 2,
                        child: ProductDesc(shortDesc: product.shortDescription),
                      ),
                      const SizedBox(height: 8),
                      ProductPricing(product: product),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ProductCardHeader extends StatelessWidget {
  final Product product;

  const ProductCardHeader({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            product.code,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        if (product.hasDiscount)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${product.discountPercentage.toStringAsFixed(0)}% OFF',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
      ],
    );
  }
}

class ProductIcon extends StatelessWidget {
  const ProductIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: 60, // Reduced height
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.cable_rounded,
        size: 30, // Reduced icon size
        color: theme.colorScheme.primary.withOpacity(0.7),
      ),
    );
  }
}

class ProductTitle extends StatelessWidget {
  final String name;

  const ProductTitle({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      name,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        height: 1.2,
        color: theme.colorScheme.onSurface,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class ProductDesc extends StatelessWidget {
  final String shortDesc;

  const ProductDesc({super.key, required this.shortDesc});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      shortDesc,
      style: TextStyle(
        fontSize: 11, // Reduced font size
        fontWeight: FontWeight.w400,
        height: 1.2,
        color: theme.colorScheme.onSurfaceVariant,
      ),
      maxLines: 2, // Reduced max lines
      overflow: TextOverflow.ellipsis,
    );
  }
}

class CategoryBadge extends StatelessWidget {
  final String category;

  const CategoryBadge({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3), // Reduced padding
        decoration: BoxDecoration(
          color: theme.colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          category,
          style: TextStyle(
            fontSize: 10, // Reduced font size
            color: theme.colorScheme.onTertiaryContainer,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }
}

class ProductPricing extends StatelessWidget {
  final Product product;

  const ProductPricing({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8), // Reduced padding
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MRP',
                      style: TextStyle(
                        fontSize: 9, // Reduced font size
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      product.displayPriceMrp,
                      style: TextStyle(
                        fontSize: 12, // Reduced font size
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4), // Reduced spacing
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Online',
                      style: TextStyle(
                        fontSize: 9, // Reduced font size
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      product.displayOnlineSp,
                      style: TextStyle(
                        fontSize: 12, // Reduced font size
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.secondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (product.gstSp != null && product.gstSp! > 0) ...[
            const SizedBox(height: 4), // Reduced spacing
            // Changed to Column layout to prevent horizontal overflow
            Column(
              children: [
                Text(
                  'GST Inclusive:',
                  style: TextStyle(
                    fontSize: 8, // Reduced font size
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  product.displayGstSp,
                  style: TextStyle(
                    fontSize: 10, // Reduced font size
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.tertiary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// Mobile version of ProductPricing for the MobileProductCard
class MobileProductPricing extends StatelessWidget {
  final Product product;

  const MobileProductPricing({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MRP',
                      style: TextStyle(
                        fontSize: 10,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      product.displayPriceMrp,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Online',
                      style: TextStyle(
                        fontSize: 10,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      product.displayOnlineSp,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.secondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (product.gstSp != null && product.gstSp! > 0) ...[
            const SizedBox(height: 6),
            Center(
              child: Column(
                children: [
                  Text(
                    'GST Inclusive:',
                    style: TextStyle(
                      fontSize: 9,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.displayGstSp,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.tertiary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class MobileProductCard extends StatelessWidget {
  final Product product;
  final int index;

  const MobileProductCard({
    super.key,
    required this.product,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Card(
              elevation: 4,
              clipBehavior: Clip.antiAlias,
              shadowColor: theme.colorScheme.shadow.withOpacity(0.05),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Icon on the left
                    Container(
                      width: 90,
                      color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                      child: Icon(
                        Icons.cable_rounded,
                        size: 32,
                        color: theme.colorScheme.primary.withOpacity(0.7),
                      ),
                    ),
                    // Details on the right
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ProductCardHeader(product: product),
                            const SizedBox(height: 12),
                            ProductTitle(name: product.name),
                            const SizedBox(height: 8),
                            ProductDesc(shortDesc: product.shortDescription),
                            const SizedBox(height: 12),
                            MobileProductPricing(product: product), // Use the new mobile pricing widget
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}