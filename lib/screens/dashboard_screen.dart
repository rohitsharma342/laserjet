import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/custom_app_bar.dart';
import '../utils/constants.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final categories = context.read<ProductProvider>().categories;
    _tabController = TabController(length: categories.length, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FilterModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppConstants.appName,
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return badges.Badge(
                badgeContent: Text(
                  cart.itemCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                showBadge: cart.itemCount > 0,
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CartScreen()),
                    );
                  },
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchSection(),
          _buildCategoryTabs(),
          _buildTrendingSection(),
          Expanded(child: _buildProductGrid()),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search printers...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppConstants.backgroundColor,
              ),
              onChanged: (value) {
                context.read<ProductProvider>().searchProducts(value);
              },
            ),
          ),
          const SizedBox(width: AppConstants.paddingSmall),
          IconButton(
            onPressed: _showFilterModal,
            icon: const Icon(Icons.tune),
            style: IconButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        return Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: AppConstants.primaryColor,
            unselectedLabelColor: AppConstants.textSecondary,
            indicatorColor: AppConstants.primaryColor,
            tabs: provider.categories
                .map((category) => Tab(text: category))
                .toList(),
            onTap: (index) {
              final category = provider.categories[index];
              provider.filterByCategory(category);
            },
          ),
        );
      },
    );
  }

  Widget _buildTrendingSection() {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        final trendingProducts = provider.trendingProducts;
        if (trendingProducts.isEmpty) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.symmetric(vertical: AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
                child: Text(
                  'Trending Products',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.paddingSmall),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
                  itemCount: trendingProducts.length,
                  itemBuilder: (context, index) {
                    final product = trendingProducts[index];
                    return Container(
                      width: 160,
                      margin: const EdgeInsets.only(right: AppConstants.paddingSmall),
                      child: ProductCard(
                        product: product,
                        onTap: () => _navigateToProductDetail(product.id),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductGrid() {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (provider.products.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'No printers found matching your criteria.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: AppConstants.paddingMedium,
            mainAxisSpacing: AppConstants.paddingMedium,
          ),
          itemCount: provider.products.length,
          itemBuilder: (context, index) {
            final product = provider.products[index];
            return ProductCard(
              product: product,
              onTap: () => _navigateToProductDetail(product.id),
            );
          },
        );
      },
    );
  }

  void _navigateToProductDetail(String productId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(productId: productId),
      ),
    );
  }
}

class _FilterModal extends StatefulWidget {
  @override
  State<_FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<_FilterModal> {
  late String selectedBrand;
  late RangeValues priceRange;

  @override
  void initState() {
    super.initState();
    final provider = context.read<ProductProvider>();
    selectedBrand = provider.selectedBrand;
    priceRange = RangeValues(provider.minPrice, provider.maxPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter Products',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.paddingLarge),
          const Text(
            'Brand',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Consumer<ProductProvider>(
            builder: (context, provider, child) {
              return Wrap(
                spacing: AppConstants.paddingSmall,
                children: provider.brands.map((brand) {
                  return FilterChip(
                    label: Text(brand),
                    selected: selectedBrand == brand,
                    onSelected: (selected) {
                      setState(() {
                        selectedBrand = brand;
                      });
                    },
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: AppConstants.paddingLarge),
          const Text(
            'Price Range',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          RangeSlider(
            values: priceRange,
            min: 0,
            max: 1000,
            divisions: 20,
            labels: RangeLabels(
              '\$${priceRange.start.round()}',
              '\$${priceRange.end.round()}',
            ),
            onChanged: (values) {
              setState(() {
                priceRange = values;
              });
            },
          ),
          const SizedBox(height: AppConstants.paddingLarge),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    context.read<ProductProvider>().clearFilters();
                    Navigator.pop(context);
                  },
                  child: const Text('Clear All'),
                ),
              ),
              const SizedBox(width: AppConstants.paddingMedium),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final provider = context.read<ProductProvider>();
                    provider.filterByBrand(selectedBrand);
                    provider.filterByPriceRange(priceRange.start, priceRange.end);
                    Navigator.pop(context);
                  },
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}