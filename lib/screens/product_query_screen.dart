// ============================================================================
// MAIN SCREEN - Complete JSON support with multiple data sources
// ============================================================================

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/product.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/error_dialog.dart';
import '../widgets/filter_widgets.dart';
import '../widgets/loading_screen.dart';
import '../widgets/mobile_widgets.dart';

class ProductQueryScreen extends StatefulWidget {
  const ProductQueryScreen({super.key});

  @override
  State<ProductQueryScreen> createState() => _ProductQueryScreenState();
}

class _ProductQueryScreenState extends State<ProductQueryScreen> with TickerProviderStateMixin {
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<String> _categories = [];
  bool _isLoading = true;
  String _currentDataSource = '';

  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  RangeValues _priceMrpRange = const RangeValues(0, 50000);
  RangeValues _onlineSpRange = const RangeValues(0, 50000);
  double _minPriceMrp = 0;
  double _maxPriceMrp = 50000;
  double _minOnlineSp = 0;
  double _maxOnlineSp = 50000;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // List of available JSON files
  final List<String> _availableDataSources = [
    'trial.honey.json',
    'trial.airpurifier.json',
    'trial.audio.json',
    'trial.belkin.json'
    // Add more JSON files as needed
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadJsonData();

    // Add listener to search controller for real-time filtering
    _searchController.addListener(_applyFilters);
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  Future<void> _loadJsonData([String? fileName]) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final String jsonFileName = fileName ?? _availableDataSources.first;
      _currentDataSource = jsonFileName;

      print('Loading JSON file: $jsonFileName');

      final String jsonString = await rootBundle.loadString('assets/$jsonFileName');
      final List<Product> products = await ProductDataLoader.loadFromJsonWithAutoDetection(jsonString);

      if (products.isNotEmpty) {
        _calculatePriceRanges(products);
        _extractCategories(products);
        _updateState(products);

        print('Successfully loaded ${products.length} products from $jsonFileName');
        if (products.isNotEmpty) {
          print('First product: ${products[0].name}');
        }
        _animationController.forward();
      } else {
        throw Exception('No valid products found in JSON file');
      }
    } catch (e) {
      _handleLoadError(e);
    }
  }

  void _calculatePriceRanges(List<Product> products) {
    if (products.isNotEmpty) {
      final priceMrps = products.map((p) => p.priceMrp).where((p) => p > 0);
      final onlinePrices = products.map((p) => p.onlineSp).where((p) => p > 0);

      if (priceMrps.isNotEmpty) {
        _minPriceMrp = priceMrps.reduce((a, b) => a < b ? a : b);
        _maxPriceMrp = priceMrps.reduce((a, b) => a > b ? a : b);
        _priceMrpRange = RangeValues(_minPriceMrp, _maxPriceMrp);
      }

      if (onlinePrices.isNotEmpty) {
        _minOnlineSp = onlinePrices.reduce((a, b) => a < b ? a : b);
        _maxOnlineSp = onlinePrices.reduce((a, b) => a > b ? a : b);
        _onlineSpRange = RangeValues(_minOnlineSp, _maxOnlineSp);
      }
    }
  }

  void _extractCategories(List<Product> products) {
    final categories = <String>{'All'};
    for (final product in products) {
      if (product.category.isNotEmpty) {
        categories.add(product.category);
      }
    }
    _categories = categories.toList()..sort();
  }

  void _updateState(List<Product> products) {
    setState(() {
      _allProducts = products;
      // Products are not displayed until the user interacts with a filter.
      _filteredProducts = [];
      _isLoading = false;
    });
  }

  void _handleLoadError(dynamic error) {
    print('Error loading JSON file: $error');
    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => ErrorDialog(
          error: error.toString(),
          isJsonError: true,
        ),
      );
    }
  }

  void _applyFilters() {
    // Determine if the user has changed any filter from its default state.
    final bool hasSearchQuery = _searchController.text.trim().isNotEmpty;
    final bool hasCategoryFilter = _selectedCategory != 'All';
    final bool hasPriceMrpFilter = _priceMrpRange != RangeValues(_minPriceMrp, _maxPriceMrp);
    final bool hasOnlineSpFilter = _onlineSpRange != RangeValues(_minOnlineSp, _maxOnlineSp);

    // Products are shown only if the user has activated at least one filter.
    final bool userHasFiltered = hasSearchQuery || hasCategoryFilter || hasPriceMrpFilter || hasOnlineSpFilter;

    setState(() {
      if (userHasFiltered) {
        _filteredProducts = _allProducts.where((product) {
          return _matchesSearch(product) &&
              _matchesCategory(product) &&
              _matchesPriceMrp(product) &&
              _matchesOnlineSp(product);
        }).toList();
      } else {
        // If all filters are in the default state, the product list is cleared.
        _filteredProducts = [];
      }
    });
  }

  bool _matchesSearch(Product product) {
    final searchTerm = _searchController.text.toLowerCase().trim();
    if (searchTerm.isEmpty) return true;

    return product.name.toLowerCase().contains(searchTerm) ||
        product.code.toLowerCase().contains(searchTerm) ||
        product.shortDescription.toLowerCase().contains(searchTerm);
  }

  bool _matchesCategory(Product product) {
    return _selectedCategory == 'All' ||
        product.category.toLowerCase() == _selectedCategory.toLowerCase();
  }

  bool _matchesPriceMrp(Product product) {
    if (product.priceMrp <= 0) return true; // Include products with no MRP price
    return product.priceMrp >= _priceMrpRange.start &&
        product.priceMrp <= _priceMrpRange.end;
  }

  bool _matchesOnlineSp(Product product) {
    if (product.onlineSp <= 0) return true; // Include products with no online price
    return product.onlineSp >= _onlineSpRange.start &&
        product.onlineSp <= _onlineSpRange.end;
  }

  void _clearAllFilters() {
    setState(() {
      _searchController.clear();
      _selectedCategory = 'All';
      _priceMrpRange = RangeValues(_minPriceMrp, _maxPriceMrp);
      _onlineSpRange = RangeValues(_minOnlineSp, _maxOnlineSp);
    });
    _applyFilters();
  }

  void _showDataSourceSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => DataSourceSelector(
        availableDataSources: _availableDataSources,
        currentDataSource: _currentDataSource,
        onDataSourceSelected: (fileName) {
          Navigator.pop(context);
          _loadJsonData(fileName);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 900;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: CustomAppBar(
        filteredProductsCount: _filteredProducts.length,
        currentDataSource: _currentDataSource,
        onDataSourcePressed: _showDataSourceSelector,
      ),
      body: _isLoading
          ? const LoadingScreen()
          : isWideScreen
          ? _buildWideLayout()
          : _buildNarrowLayout(),
    );
  }

  Widget _buildPoweredBy() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'Powered by Anhad Technocrafts and BuildBerry.io',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
    );
  }

  Widget _buildWideLayout() {
    return Row(
      children: [
        SizedBox(
          width: 320,
          child: Column(
            children: [
              Expanded(
                child: FilterPanel(
                  searchController: _searchController,
                  categories: _categories,
                  selectedCategory: _selectedCategory,
                  priceMrpRange: _priceMrpRange,
                  onlineSpRange: _onlineSpRange,
                  minPriceMrp: _minPriceMrp,
                  maxPriceMrp: _maxPriceMrp,
                  minOnlineSp: _minOnlineSp,
                  maxOnlineSp: _maxOnlineSp,
                  filteredProductsCount: _filteredProducts.length,
                  onSearchChanged: () {}, // Handled by controller listener
                  onCategoryChanged: (value) {
                    setState(() => _selectedCategory = value);
                    _applyFilters();
                  },
                  onPriceMrpChanged: (values) {
                    setState(() => _priceMrpRange = values);
                    _applyFilters();
                  },
                  onOnlineSpChanged: (values) {
                    setState(() => _onlineSpRange = values);
                    _applyFilters();
                  },
                  onClearFilters: _clearAllFilters,
                ),
              ),
              _buildPoweredBy(),
            ],
          ),
        ),
        VerticalDivider(
          width: 1,
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
        Expanded(
          child: ProductGrid(
            products: _filteredProducts,
            fadeAnimation: _fadeAnimation,
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout() {
    return Column(
      children: [
        MobileSearchBar(
          searchController: _searchController,
          onSearchChanged: () {}, // Handled by controller listener
          onFilterPressed: () => _showMobileFilterDialog(),
        ),
        Expanded(
          child: ProductGrid(
            products: _filteredProducts,
            fadeAnimation: _fadeAnimation,
          ),
        ),
        _buildPoweredBy(),
      ],
    );
  }

  void _showMobileFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MobileFilterDialog(
        categories: _categories,
        selectedCategory: _selectedCategory,
        priceMrpRange: _priceMrpRange,
        onlineSpRange: _onlineSpRange,
        minPriceMrp: _minPriceMrp,
        maxPriceMrp: _maxPriceMrp,
        minOnlineSp: _minOnlineSp,
        maxOnlineSp: _maxOnlineSp,
        onCategoryChanged: (value) {
          setState(() => _selectedCategory = value);
          _applyFilters();
        },
        onPriceMrpChanged: (values) {
          setState(() => _priceMrpRange = values);
          _applyFilters();
        },
        onOnlineSpChanged: (values) {
          setState(() => _onlineSpRange = values);
          _applyFilters();
        },
        onClearFilters: _clearAllFilters,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_applyFilters);
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}

// ============================================================================
// DATA SOURCE SELECTOR WIDGET
// ============================================================================

class DataSourceSelector extends StatelessWidget {
  final List<String> availableDataSources;
  final String currentDataSource;
  final Function(String) onDataSourceSelected;

  const DataSourceSelector({
    super.key,
    required this.availableDataSources,
    required this.currentDataSource,
    required this.onDataSourceSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outline.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Select Data Source',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...availableDataSources.map((source) => ListTile(
            title: Text(source),
            leading: Icon(
              source == currentDataSource ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: theme.colorScheme.primary,
            ),
            onTap: () => onDataSourceSelected(source),
          )),
        ],
      ),
    );
  }
}