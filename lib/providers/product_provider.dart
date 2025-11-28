import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/data_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _selectedBrand = 'All';
  double _minPrice = 0;
  double _maxPrice = 1000;
  bool _isLoading = false;

  List<Product> get products => _filteredProducts;
  List<Product> get allProducts => _products;
  List<Product> get trendingProducts => _products.where((product) => product.isTrending).toList();
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  String get selectedBrand => _selectedBrand;
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;
  bool get isLoading => _isLoading;
  List<String> get categories => DataService.getCategories();
  List<String> get brands => DataService.getBrands();

  ProductProvider() {
    loadProducts();
  }

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    _products = DataService.getProducts();
    _filteredProducts = List.from(_products);
    
    _isLoading = false;
    notifyListeners();
  }

  void searchProducts(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void filterByBrand(String brand) {
    _selectedBrand = brand;
    _applyFilters();
  }

  void filterByPriceRange(double min, double max) {
    _minPrice = min;
    _maxPrice = max;
    _applyFilters();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = 'All';
    _selectedBrand = 'All';
    _minPrice = 0;
    _maxPrice = 1000;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredProducts = _products.where((product) {
      bool matchesSearch = _searchQuery.isEmpty ||
          product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.brand.toLowerCase().contains(_searchQuery.toLowerCase());

      bool matchesCategory = _selectedCategory == 'All' || product.category == _selectedCategory;
      bool matchesBrand = _selectedBrand == 'All' || product.brand == _selectedBrand;
      bool matchesPrice = product.price >= _minPrice && product.price <= _maxPrice;

      return matchesSearch && matchesCategory && matchesBrand && matchesPrice;
    }).toList();

    notifyListeners();
  }

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }
}