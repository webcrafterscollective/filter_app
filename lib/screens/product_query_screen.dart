// // ============================================================================
// // MAIN SCREEN - FIXED VERSION
// // ============================================================================
//
// import 'package:excel/excel.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// import '../data/product_data.dart';
// import '../models/product.dart';
// import '../widgets/custom_app_bar.dart';
// import '../widgets/error_dialog.dart';
// import '../widgets/filter_widgets.dart';
// import '../widgets/loading_screen.dart';
// import '../widgets/mobile_widgets.dart';
//
// class ProductQueryScreen extends StatefulWidget {
//   const ProductQueryScreen({super.key});
//
//   @override
//   State<ProductQueryScreen> createState() => _ProductQueryScreenState();
// }
//
// class _ProductQueryScreenState extends State<ProductQueryScreen> with TickerProviderStateMixin {
//   List<Product> _allProducts = [];
//   List<Product> _filteredProducts = [];
//   List<String> _categories = [];
//   bool _isLoading = true;
//
//   final TextEditingController _searchController = TextEditingController();
//   String _selectedCategory = 'All';
//   RangeValues _priceMrpRange = const RangeValues(0, 50000);
//   RangeValues _onlineSpRange = const RangeValues(0, 50000);
//   final double _minPriceMrp = 0;
//   final double _maxPriceMrp = 50000;
//   final double _minOnlineSp = 0;
//   final double _maxOnlineSp = 50000;
//
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//     _loadExcelData();
//
//     // Add listener to search controller for real-time filtering
//     _searchController.addListener(_applyFilters);
//   }
//
//   void _initializeAnimations() {
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//   }
//
//   Future<void> _loadExcelData() async {
//     try {
//       print('Loading Excel file...');
//
//       final ByteData data = await rootBundle.load('assets/products.xlsx');
//       final bytes = data.buffer.asUint8List();
//
//       final excel = Excel.decodeBytes(bytes);
//       final sheet = excel.tables[excel.tables.keys.first];
//
//       // final bytes = productBytes; // <-- USE THE IMPORTED BYTE ARRAY
//       //
//       // final excel = Excel.decodeBytes(bytes);
//       // final sheet = excel.tables[excel.tables.keys.first];
//
//       if (sheet != null) {
//         final products = <Product>[];
//         final categories = <String>{'All'};
//
//         for (int i = 2; i < sheet.maxRows; i++) {
//           final row = sheet.rows[i];
//           if (row.isNotEmpty) {
//             try {
//               final rowValues = row.map((cell) => cell?.value).toList();
//
//               if (_isValidRow(rowValues)) {
//                 final product = _parseProduct(rowValues);
//
//                 if (product.name.isNotEmpty && product.code.isNotEmpty) {
//                   products.add(product);
//                   if (product.category.isNotEmpty) {
//                     categories.add(product.category);
//                   }
//                 }
//               }
//             } catch (e) {
//               print('Error parsing row $i: $e');
//             }
//           }
//         }
//
//         _calculatePriceRanges(products);
//         _updateState(products, categories);
//
//         print('Successfully loaded ${products.length} products');
//         if (products.isNotEmpty) {
//           print('First product: ${products[0].name}');
//         }
//         _animationController.forward();
//       }
//     } catch (e) {
//       _handleLoadError(e);
//     }
//   }
//
//   bool _isValidRow(List<dynamic> rowValues) {
//     return rowValues.length >= 3 &&
//         rowValues[0] != null &&
//         rowValues[0].toString().trim().isNotEmpty;
//   }
//
//   Product _parseProduct(List<dynamic> rowValues) {
//     String code = rowValues[0]?.toString().trim() ?? '';
//     String name = rowValues.length > 1 ? (rowValues[1]?.toString().trim() ?? '') : '';
//     String shortDesc = rowValues.length > 2 ? (rowValues[2]?.toString().trim() ?? '') : '';
//     String category = rowValues.length > 3 ? (rowValues[3]?.toString().trim() ?? '') : 'UGREEN';
//
//     // For prices, look for numeric values in columns 4 and 5
//     double priceMrp = 0.0;
//     double onlineSp = 0.0;
//
//     if (rowValues.length > 5) {
//       priceMrp = double.parse(rowValues[5]?.toString() ?? '0.0');
//     }
//     if (rowValues.length > 6) {
//       onlineSp = double.parse(rowValues[6]?.toString() ?? '0.0');
//     }
//
//     return Product(
//       code: code,
//       name: name,
//       shortDescription: shortDesc,
//       category: category.isNotEmpty ? category : 'UGREEN',
//       priceMrp: priceMrp,
//       onlineSp: onlineSp,
//     );
//   }
//
//   static double _parseDouble(dynamic value) {
//     if (value == null) return 0.0;
//     if (value is double) return value;
//     if (value is int) return value.toDouble();
//     if (value is String) {
//       final cleanValue = value.replaceAll(RegExp(r'[^\d.]'), '');
//       return double.tryParse(cleanValue) ?? 0.0;
//     }
//     return 0.0;
//   }
//
//   void _calculatePriceRanges(List<Product> products) {
//     // if (products.isNotEmpty) {
//     //   final priceMrps = products.map((p) => p.priceMrp).where((p) => p > 0);
//     //   final onlinePrices = products.map((p) => p.onlineSp).where((p) => p > 0);
//     //
//     //   if (priceMrps.isNotEmpty) {
//     //     _minPriceMrp = priceMrps.reduce((a, b) => a < b ? a : b);
//     //     _maxPriceMrp = priceMrps.reduce((a, b) => a > b ? a : b);
//     //     _priceMrpRange = RangeValues(_minPriceMrp, _maxPriceMrp);
//     //   }
//     //
//     //   if (onlinePrices.isNotEmpty) {
//     //     _minOnlineSp = onlinePrices.reduce((a, b) => a < b ? a : b);
//     //     _maxOnlineSp = onlinePrices.reduce((a, b) => a > b ? a : b);
//     //     _onlineSpRange = RangeValues(_minOnlineSp, _maxOnlineSp);
//     //   }
//     // }
//   }
//
//   void _updateState(List<Product> products, Set<String> categories) {
//     setState(() {
//       _allProducts = products;
//       _filteredProducts = products;
//       _categories = categories.toList()..sort();
//       _isLoading = false;
//     });
//   }
//
//   void _handleLoadError(dynamic error) {
//     print('Error loading Excel file: $error');
//     setState(() {
//       _isLoading = false;
//     });
//
//     if (mounted) {
//       showDialog(
//         context: context,
//         builder: (context) => ErrorDialog(error: error.toString()),
//       );
//     }
//   }
//
//   void _applyFilters() {
//     setState(() {
//       _filteredProducts = _allProducts.where((product) {
//         return _matchesSearch(product) &&
//             _matchesCategory(product) &&
//             _matchesPriceMrp(product) &&
//             _matchesOnlineSp(product);
//       }).toList();
//     });
//   }
//
//   bool _matchesSearch(Product product) {
//     final searchTerm = _searchController.text.toLowerCase().trim();
//     if (searchTerm.isEmpty) return true;
//
//     return product.name.toLowerCase().contains(searchTerm) ||
//         product.code.toLowerCase().contains(searchTerm) ||
//         product.shortDescription.toLowerCase().contains(searchTerm);
//   }
//
//   bool _matchesCategory(Product product) {
//     return _selectedCategory == 'All' ||
//         product.category.toLowerCase() == _selectedCategory.toLowerCase();
//   }
//
//   bool _matchesPriceMrp(Product product) {
//     if (product.priceMrp <= 0) return true; // Include products with no MRP price
//     return product.priceMrp >= _priceMrpRange.start &&
//         product.priceMrp <= _priceMrpRange.end;
//   }
//
//   bool _matchesOnlineSp(Product product) {
//     if (product.onlineSp <= 0) return true; // Include products with no online price
//     return product.onlineSp >= _onlineSpRange.start &&
//         product.onlineSp <= _onlineSpRange.end;
//   }
//
//   void _clearAllFilters() {
//     setState(() {
//       _searchController.clear();
//       _selectedCategory = 'All';
//       _priceMrpRange = RangeValues(_minPriceMrp, _maxPriceMrp);
//       _onlineSpRange = RangeValues(_minOnlineSp, _maxOnlineSp);
//     });
//     _applyFilters();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isWideScreen = screenWidth > 900;
//
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       appBar: CustomAppBar(filteredProductsCount: _filteredProducts.length),
//       body: _isLoading
//           ? const LoadingScreen()
//           : isWideScreen
//           ? _buildWideLayout()
//           : _buildNarrowLayout(),
//     );
//   }
//
//   Widget _buildWideLayout() {
//     return Row(
//       children: [
//         SizedBox(
//           width: 320,
//           child: FilterPanel(
//             searchController: _searchController,
//             categories: _categories,
//             selectedCategory: _selectedCategory,
//             priceMrpRange: _priceMrpRange,
//             onlineSpRange: _onlineSpRange,
//             minPriceMrp: _minPriceMrp,
//             maxPriceMrp: _maxPriceMrp,
//             minOnlineSp: _minOnlineSp,
//             maxOnlineSp: _maxOnlineSp,
//             filteredProductsCount: _filteredProducts.length,
//             onSearchChanged: () {}, // Handled by controller listener
//             onCategoryChanged: (value) {
//               setState(() => _selectedCategory = value);
//               _applyFilters();
//             },
//             onPriceMrpChanged: (values) {
//               setState(() => _priceMrpRange = values);
//               _applyFilters();
//             },
//             onOnlineSpChanged: (values) {
//               setState(() => _onlineSpRange = values);
//               _applyFilters();
//             },
//             onClearFilters: _clearAllFilters,
//           ),
//         ),
//         VerticalDivider(
//           width: 1,
//           color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
//         ),
//         Expanded(
//           child: ProductGrid(
//             products: _filteredProducts,
//             fadeAnimation: _fadeAnimation,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildNarrowLayout() {
//     return Column(
//       children: [
//         MobileSearchBar(
//           searchController: _searchController,
//           onSearchChanged: () {}, // Handled by controller listener
//           onFilterPressed: () => _showMobileFilterDialog(),
//         ),
//         Expanded(
//           child: ProductGrid(
//             products: _filteredProducts,
//             fadeAnimation: _fadeAnimation,
//           ),
//         ),
//       ],
//     );
//   }
//
//   void _showMobileFilterDialog() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => MobileFilterDialog(
//         categories: _categories,
//         selectedCategory: _selectedCategory,
//         priceMrpRange: _priceMrpRange,
//         onlineSpRange: _onlineSpRange,
//         minPriceMrp: _minPriceMrp,
//         maxPriceMrp: _maxPriceMrp,
//         minOnlineSp: _minOnlineSp,
//         maxOnlineSp: _maxOnlineSp,
//         onCategoryChanged: (value) {
//           setState(() => _selectedCategory = value);
//           _applyFilters();
//         },
//         onPriceMrpChanged: (values) {
//           setState(() => _priceMrpRange = values);
//           _applyFilters();
//         },
//         onOnlineSpChanged: (values) {
//           setState(() => _onlineSpRange = values);
//           _applyFilters();
//         },
//         onClearFilters: _clearAllFilters,
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _searchController.removeListener(_applyFilters);
//     _searchController.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }
// }
// ============================================================================
// MAIN SCREEN - FIXED VERSION
// ============================================================================

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/product_data.dart';
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

  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  RangeValues _priceMrpRange = const RangeValues(0, 50000);
  RangeValues _onlineSpRange = const RangeValues(0, 50000);
  final double _minPriceMrp = 0;
  final double _maxPriceMrp = 50000;
  final double _minOnlineSp = 0;
  final double _maxOnlineSp = 50000;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadExcelData();

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

  Future<void> _loadExcelData() async {
    try {
      print('Loading Excel file...');

      // final ByteData data = await rootBundle.load('assets/products.xlsx');
      // final bytes = data.buffer.asUint8List();
      //
      // final excel = Excel.decodeBytes(bytes);
      // final sheet = excel.tables[excel.tables.keys.first];

      final bytes = productBytes; // <-- USE THE IMPORTED BYTE ARRAY

      final excel = Excel.decodeBytes(bytes);
      final sheet = excel.tables[excel.tables.keys.first];

      if (sheet != null) {
        final products = <Product>[];
        final categories = <String>{'All'};

        for (int i = 2; i < sheet.maxRows; i++) {
          final row = sheet.rows[i];
          if (row.isNotEmpty) {
            try {
              final rowValues = row.map((cell) => cell?.value).toList();

              if (_isValidRow(rowValues)) {
                final product = _parseProduct(rowValues);

                if (product.name.isNotEmpty && product.code.isNotEmpty) {
                  products.add(product);
                  if (product.category.isNotEmpty) {
                    categories.add(product.category);
                  }
                }
              }
            } catch (e) {
              print('Error parsing row $i: $e');
            }
          }
        }

        _calculatePriceRanges(products);
        _updateState(products, categories);

        print('Successfully loaded ${products.length} products');
        if (products.isNotEmpty) {
          print('First product: ${products[0].name}');
        }
        _animationController.forward();
      }
    } catch (e) {
      _handleLoadError(e);
    }
  }

  bool _isValidRow(List<dynamic> rowValues) {
    return rowValues.length >= 3 &&
        rowValues[0] != null &&
        rowValues[0].toString().trim().isNotEmpty;
  }

  Product _parseProduct(List<dynamic> rowValues) {
    String code = rowValues[0]?.toString().trim() ?? '';
    String name = rowValues.length > 1 ? (rowValues[1]?.toString().trim() ?? '') : '';
    String shortDesc = rowValues.length > 2 ? (rowValues[2]?.toString().trim() ?? '') : '';
    String category = rowValues.length > 3 ? (rowValues[3]?.toString().trim() ?? '') : 'UGREEN';

    // For prices, look for numeric values in columns 4 and 5
    double priceMrp = 0.0;
    double onlineSp = 0.0;

    if (rowValues.length > 5) {
      priceMrp = double.parse(rowValues[5]?.toString() ?? '0.0');
    }
    if (rowValues.length > 6) {
      onlineSp = double.parse(rowValues[6]?.toString() ?? '0.0');
    }

    return Product(
      code: code,
      name: name,
      shortDescription: shortDesc,
      category: category.isNotEmpty ? category : 'UGREEN',
      priceMrp: priceMrp,
      onlineSp: onlineSp,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      final cleanValue = value.replaceAll(RegExp(r'[^\d.]'), '');
      return double.tryParse(cleanValue) ?? 0.0;
    }
    return 0.0;
  }

  void _calculatePriceRanges(List<Product> products) {
    // if (products.isNotEmpty) {
    //   final priceMrps = products.map((p) => p.priceMrp).where((p) => p > 0);
    //   final onlinePrices = products.map((p) => p.onlineSp).where((p) => p > 0);
    //
    //   if (priceMrps.isNotEmpty) {
    //     _minPriceMrp = priceMrps.reduce((a, b) => a < b ? a : b);
    //     _maxPriceMrp = priceMrps.reduce((a, b) => a > b ? a : b);
    //     _priceMrpRange = RangeValues(_minPriceMrp, _maxPriceMrp);
    //   }
    //
    //   if (onlinePrices.isNotEmpty) {
    //     _minOnlineSp = onlinePrices.reduce((a, b) => a < b ? a : b);
    //     _maxOnlineSp = onlinePrices.reduce((a, b) => a > b ? a : b);
    //     _onlineSpRange = RangeValues(_minOnlineSp, _maxOnlineSp);
    //   }
    // }
  }

  // =========================================================================
  // MODIFICATION 1 of 2: Updated `_updateState` method
  // =========================================================================
  void _updateState(List<Product> products, Set<String> categories) {
    setState(() {
      _allProducts = products;
      // Products are not displayed until the user interacts with a filter.
      _filteredProducts = [];
      _categories = categories.toList()..sort();
      _isLoading = false;
    });
  }

  void _handleLoadError(dynamic error) {
    print('Error loading Excel file: $error');
    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => ErrorDialog(error: error.toString()),
      );
    }
  }

  // =========================================================================
  // MODIFICATION 2 of 2: Updated `_applyFilters` method
  // =========================================================================
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 900;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: CustomAppBar(filteredProductsCount: _filteredProducts.length),
      body: _isLoading
          ? const LoadingScreen()
          : isWideScreen
          ? _buildWideLayout()
          : _buildNarrowLayout(),
    );
  }

  // =========================================================================
  // MODIFICATION: Helper widget for the attribution text.
  // =========================================================================
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

  // Widget _buildWideLayout() {
  //   return Row(
  //     children: [
  //       SizedBox(
  //         width: 320,
  //         child: FilterPanel(
  //           searchController: _searchController,
  //           categories: _categories,
  //           selectedCategory: _selectedCategory,
  //           priceMrpRange: _priceMrpRange,
  //           onlineSpRange: _onlineSpRange,
  //           minPriceMrp: _minPriceMrp,
  //           maxPriceMrp: _maxPriceMrp,
  //           minOnlineSp: _minOnlineSp,
  //           maxOnlineSp: _maxOnlineSp,
  //           filteredProductsCount: _filteredProducts.length,
  //           onSearchChanged: () {}, // Handled by controller listener
  //           onCategoryChanged: (value) {
  //             setState(() => _selectedCategory = value);
  //             _applyFilters();
  //           },
  //           onPriceMrpChanged: (values) {
  //             setState(() => _priceMrpRange = values);
  //             _applyFilters();
  //           },
  //           onOnlineSpChanged: (values) {
  //             setState(() => _onlineSpRange = values);
  //             _applyFilters();
  //           },
  //           onClearFilters: _clearAllFilters,
  //         ),
  //
  //       ),
  //       VerticalDivider(
  //         width: 1,
  //         color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
  //       ),
  //       Expanded(
  //         child: ProductGrid(
  //           products: _filteredProducts,
  //           fadeAnimation: _fadeAnimation,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildWideLayout() {
    return Row(
      children: [
        SizedBox(
          width: 320,
          // Wrap the FilterPanel in a Column to add the text below it.
          child: Column(
            children: [
              // Use Expanded to make the FilterPanel fill the available space.
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
              // Add the attribution text at the bottom of the column.
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

  // Widget _buildNarrowLayout() {
  //   return Column(
  //     children: [
  //       MobileSearchBar(
  //         searchController: _searchController,
  //         onSearchChanged: () {}, // Handled by controller listener
  //         onFilterPressed: () => _showMobileFilterDialog(),
  //       ),
  //       Expanded(
  //         child: ProductGrid(
  //           products: _filteredProducts,
  //           fadeAnimation: _fadeAnimation,
  //         ),
  //       ),
  //     ],
  //   );
  // }

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
        // Add the attribution text at the bottom.
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