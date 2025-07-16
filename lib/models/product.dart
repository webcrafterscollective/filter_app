// ============================================================================
// MODELS - Complete JSON support with multiple structure handling
// ============================================================================

import 'dart:convert';

class Product {
  final String code;
  final String name;
  final String shortDescription;
  final String category;
  final double priceMrp;
  final double onlineSp;
  final double? gstSp;

  Product({
    required this.code,
    required this.name,
    required this.shortDescription,
    required this.category,
    required this.priceMrp,
    required this.onlineSp,
    this.gstSp,
  });

  // Factory constructor for JSON data
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      code: _parseString(json['CODE #']),
      name: _parseString(json['NAME']),
      shortDescription: _parseString(json['SHORT DESCRIPTION']),
      category: _parseString(json['CATEGORY']),
      priceMrp: _parsePrice(json['MRP']),
      onlineSp: _parsePrice(json['ONLINE SP']),
      gstSp: _parsePrice(json['GST SP']),
    );
  }

  // Factory constructor for Excel row data (backward compatibility)
  factory Product.fromRow(List<dynamic> row) {
    // Ensure we have enough columns, pad with empty values if needed
    while (row.length < 6) {
      row.add('');
    }

    return Product(
        code: _parseString(row[0]),           // CODE #
        name: _parseString(row[2]),           // NAME (skipping column 1 which seems to be a number)
        shortDescription: _parseString(row[3]), // Use category as description for now
        category: _parseString(row[3]),       // CATEGORY
        priceMrp: _parseDouble(row[4]),       // PRICE MRP (single column)
        onlineSp: _parseDouble(row[5]),       // ONLINE SP
        gstSp: _parseDouble(row[6])
    );
  }

  static String _parseString(dynamic value) {
    if (value == null) return '';
    return value.toString().trim();
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

  // Enhanced price parsing for JSON with currency symbols
  static double _parsePrice(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      // Remove currency symbols (₹, $, etc.), commas, and spaces
      final cleanValue = value
          .replaceAll(RegExp(r'[₹$€£¥,\s]'), '')
          .replaceAll(RegExp(r'[^\d.]'), '');
      return double.tryParse(cleanValue) ?? 0.0;
    }
    return 0.0;
  }

  // Helper getters for display
  String get displayPriceMrp => '₹${priceMrp.toStringAsFixed(0)}';
  String get displayOnlineSp => '₹${onlineSp.toStringAsFixed(0)}';
  String get displayGstSp => gstSp != null ? '₹${gstSp!.toStringAsFixed(0)}' : '';
  double get discountPercentage => priceMrp > 0 ? ((priceMrp - onlineSp) / priceMrp * 100) : 0;
  bool get hasDiscount => discountPercentage > 0;
}

// ============================================================================
// JSON LOADER SERVICE
// ============================================================================

class ProductDataLoader {
  static Future<List<Product>> loadFromJson(String jsonString) async {
    try {
      final dynamic jsonData = json.decode(jsonString);
      final List<Product> products = [];

      if (jsonData is List) {
        for (final item in jsonData) {
          if (item is Map<String, dynamic>) {
            try {
              final product = Product.fromJson(item);
              // Only add products with valid code and name
              if (product.code.isNotEmpty && product.name.isNotEmpty) {
                products.add(product);
              }
            } catch (e) {
              print('Error parsing product: $e');
              // Continue with other products
            }
          }
        }
      }

      return products;
    } catch (e) {
      print('Error loading JSON: $e');
      return [];
    }
  }

  // Method to detect and load different JSON structures
  static Future<List<Product>> loadFromJsonWithAutoDetection(String jsonString) async {
    try {
      final dynamic jsonData = json.decode(jsonString);
      final List<Product> products = [];

      if (jsonData is List) {
        for (final item in jsonData) {
          if (item is Map<String, dynamic>) {
            try {
              final product = _parseProductFromAnyStructure(item);
              if (product != null) {
                products.add(product);
              }
            } catch (e) {
              print('Error parsing product: $e');
              // Continue with other products
            }
          }
        }
      }

      return products;
    } catch (e) {
      print('Error loading JSON: $e');
      return [];
    }
  }

  // Helper method to parse product from different JSON structures
  static Product? _parseProductFromAnyStructure(Map<String, dynamic> item) {
    // Current structure (Honeywell)
    if (item.containsKey('CODE #') && item.containsKey('NAME')) {
      return Product.fromJson(item);
    }

    // Alternative structure 1 (if code is in 'code' field)
    if (item.containsKey('code') && item.containsKey('name')) {
      return Product(
        code: Product._parseString(item['code']),
        name: Product._parseString(item['name']),
        shortDescription: Product._parseString(item['description'] ?? item['short_description'] ?? ''),
        category: Product._parseString(item['category'] ?? 'GENERAL'),
        priceMrp: Product._parsePrice(item['mrp'] ?? item['price_mrp'] ?? item['price']),
        onlineSp: Product._parsePrice(item['online_price'] ?? item['selling_price'] ?? item['sp']),
        gstSp: Product._parsePrice(item['gst_price'] ?? item['gst_sp']),
      );
    }

    // Alternative structure 2 (if using different field names)
    if (item.containsKey('product_code') && item.containsKey('product_name')) {
      return Product(
        code: Product._parseString(item['product_code']),
        name: Product._parseString(item['product_name']),
        shortDescription: Product._parseString(item['product_description'] ?? ''),
        category: Product._parseString(item['product_category'] ?? 'GENERAL'),
        priceMrp: Product._parsePrice(item['mrp_price'] ?? item['maximum_price']),
        onlineSp: Product._parsePrice(item['online_price'] ?? item['selling_price']),
        gstSp: Product._parsePrice(item['gst_inclusive_price']),
      );
    }

    return null;
  }
}