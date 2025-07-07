// ============================================================================
// MOBILE COMPONENTS - FIXED VERSION
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

class MobileFilterDialog extends StatelessWidget {
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
                        onChanged: (value) => onCategoryChanged(value ?? 'All'),
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
                            values: priceMrpRange,
                            min: minPriceMrp,
                            max: maxPriceMrp,
                            divisions: 50,
                            labels: RangeLabels(
                              '₹${priceMrpRange.start.toStringAsFixed(0)}',
                              '₹${priceMrpRange.end.toStringAsFixed(0)}',
                            ),
                            onChanged: onPriceMrpChanged,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '₹${priceMrpRange.start.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                              ),
                              Text(
                                'to',
                                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                              ),
                              Text(
                                '₹${priceMrpRange.end.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.onPrimaryContainer,
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
                            values: onlineSpRange,
                            min: minOnlineSp,
                            max: maxOnlineSp,
                            divisions: 50,
                            labels: RangeLabels(
                              '₹${onlineSpRange.start.toStringAsFixed(0)}',
                              '₹${onlineSpRange.end.toStringAsFixed(0)}',
                            ),
                            onChanged: onOnlineSpChanged,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '₹${onlineSpRange.start.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.onSecondaryContainer,
                                ),
                              ),
                              Text(
                                'to',
                                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                              ),
                              Text(
                                '₹${onlineSpRange.end.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.onSecondaryContainer,
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
                        onClearFilters();
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
// PRODUCT DISPLAY COMPONENTS - FIXED VERSION
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
    final crossAxisCount = screenWidth > 1400 ? 4 : screenWidth > 1000 ? 3 : screenWidth > 600 ? 2 : 1;

    return FadeTransition(
      opacity: fadeAnimation,
      child: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 0.85,
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
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProductCardHeader(product: product),
                      const SizedBox(height: 12),
                      const ProductIcon(),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: ProductTitle(name: product.name)),
                          CategoryBadge(category: product.category),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ProductDesc(shortDesc: product.shortDescription),
                      const Spacer(),
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
      height: 80,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.cable_rounded,
        size: 40,
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
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.2,
        color: theme.colorScheme.onSurfaceVariant,
      ),
      maxLines: 3,
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        category,
        style: TextStyle(
          fontSize: 11,
          color: theme.colorScheme.onTertiaryContainer,
          fontWeight: FontWeight.w600,
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
      padding: const EdgeInsets.all(12),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Price MRP',
                    style: TextStyle(
                      fontSize: 10,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    product.displayPriceMrp,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              Column(
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
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}