// ============================================================================
// MOBILE COMPONENTS
// ============================================================================import 'package:flutter/material.dart';



import 'package:flutter/material.dart';

import '../models/product.dart';

class MobileSearchBar extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                border: Border.all(color: Colors.grey.shade300),
                color: Colors.grey.shade50,
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search products...',
                  hintText: 'Code or Name',
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey.shade600),
                    onPressed: () {
                      searchController.clear();
                      onSearchChanged();
                    },
                  )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
                onChanged: (_) => onSearchChanged(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: onFilterPressed,
              icon: Icon(
                Icons.tune_rounded,
                color: Theme.of(context).colorScheme.onPrimary,
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
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
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
              color: Colors.grey.shade300,
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
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Advanced Filters',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Done'),
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
                        border: Border.all(color: Colors.grey.shade300),
                        color: Colors.white,
                      ),
                      child: DropdownButtonFormField<String>(
                        value: selectedCategory,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        items: categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
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
                        RangeSlider(
                          values: priceMrpRange,
                          min: minPriceMrp,
                          max: maxPriceMrp,
                          divisions: 50,
                          activeColor: Colors.green.shade600,
                          labels: RangeLabels(
                            '₹${priceMrpRange.start.toStringAsFixed(0)}',
                            '₹${priceMrpRange.end.toStringAsFixed(0)}',
                          ),
                          onChanged: onPriceMrpChanged,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('₹${priceMrpRange.start.toStringAsFixed(0)}'),
                              const Text('to'),
                              Text('₹${priceMrpRange.end.toStringAsFixed(0)}'),
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
                        RangeSlider(
                          values: onlineSpRange,
                          min: minOnlineSp,
                          max: maxOnlineSp,
                          divisions: 50,
                          activeColor: Colors.orange.shade600,
                          labels: RangeLabels(
                            '₹${onlineSpRange.start.toStringAsFixed(0)}',
                            '₹${onlineSpRange.end.toStringAsFixed(0)}',
                          ),
                          onChanged: onOnlineSpChanged,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('₹${onlineSpRange.start.toStringAsFixed(0)}'),
                              const Text('to'),
                              Text('₹${onlineSpRange.end.toStringAsFixed(0)}'),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey.shade700),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
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
// PRODUCT DISPLAY COMPONENTS
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 64,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Products Found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search criteria or filters',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade500,
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
              shadowColor: Colors.black.withOpacity(0.1),
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
                      Colors.white,
                      Colors.grey.shade50,
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
                          ProductTitle(name: product.name),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            product.code,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        if (product.hasDiscount)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${product.discountPercentage.toStringAsFixed(0)}% OFF',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade700,
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
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.cable_rounded,
        size: 40,
        color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
      ),
    );
  }
}

class ProductTitle extends StatelessWidget {
  final String name;

  const ProductTitle({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        height: 1.2,
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
    return Text(
      shortDesc,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.2,
      ),
      maxLines: 5,
      overflow: TextOverflow.ellipsis,
    );
  }
}
class CategoryBadge extends StatelessWidget {
  final String category;

  const CategoryBadge({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        category,
        style: TextStyle(
          fontSize: 11,
          color: Colors.blue.shade700,
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
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
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    product.displayPriceMrp,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
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
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    product.displayOnlineSp,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade700,
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

