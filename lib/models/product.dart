// ============================================================================
// MODELS
// ============================================================================

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

  // Helper getters for display
  String get displayPriceMrp => '₹${priceMrp.toStringAsFixed(0)}';
  String get displayOnlineSp => '₹${onlineSp.toStringAsFixed(0)}';
  double get discountPercentage => priceMrp > 0 ? ((priceMrp - onlineSp) / priceMrp * 100) : 0;
  bool get hasDiscount => discountPercentage > 0;
}