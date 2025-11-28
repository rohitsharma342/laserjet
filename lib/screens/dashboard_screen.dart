import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import '../models/printer.dart';
import '../services/data_service.dart';
import '../services/cart_service.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/printer_card.dart';
import '../widgets/category_tab.dart';
import '../utils/constants.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Printer> _allPrinters = [];
  List<Printer> _filteredPrinters = [];
  List<Printer> _trendingPrinters = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadPrinters();
  }

  void _loadPrinters() {
    _allPrinters = DataService.samplePrinters;
    _trendingPrinters = DataService.getTrendingPrinters();
    _filterPrinters();
  }

  void _filterPrinters() {
    setState(() {
      _filteredPrinters = DataService.searchPrinters(
        _searchQuery,
        category: _selectedCategory,
      );
    });
  }

  void _onSearchChanged(String query) {
    _searchQuery = query;
    _filterPrinters();
  }

  void _onCategorySelected(String category) {
    _selectedCategory = category;
    _filterPrinters();
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildFilterModal(),
    );
  }

  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildNotificationsModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Laserjet',
        showBackButton: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadPrinters();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchAndFilter(),
              const SizedBox(height: 16),
              _buildCategoryTabs(),
              const SizedBox(height: 24),
              _buildTrendingSection(),
              const SizedBox(height: 24),
              _buildProductsSection(),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildNotificationButton(),
    );
  }

  Widget _buildSearchAndFilter() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: const InputDecoration(
              hintText: 'Search printers...',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            color: AppConstants.primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: _showFilterModal,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryTabs() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: AppConstants.categories.length,
        itemBuilder: (context, index) {
          final category = AppConstants.categories[index];
          return CategoryTab(
            category: category,
            isSelected: _selectedCategory == category,
            onTap: () => _onCategorySelected(category),
          );
        },
      ),
    );
  }

  Widget _buildTrendingSection() {
    if (_trendingPrinters.isEmpty) return const SizedBox();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Trending Printers',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppConstants.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        CarouselSlider.builder(
          itemCount: _trendingPrinters.length,
          itemBuilder: (context, index, realIndex) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 200,
              child: PrinterCard(
                printer: _trendingPrinters[index],
                isCompact: true,
              ),
            );
          },
          options: CarouselOptions(
            height: 280,
            enableInfiniteScroll: false,
            enlargeCenterPage: false,
            viewportFraction: 0.55,
          ),
        ),
      ],
    );
  }

  Widget _buildProductsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _selectedCategory == 'All' 
              ? 'All Printers'
              : '$_selectedCategory Printers',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppConstants.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        _filteredPrinters.isEmpty
            ? _buildEmptyState()
            : MasonryGridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                itemCount: _filteredPrinters.length,
                itemBuilder: (context, index) {
                  return PrinterCard(printer: _filteredPrinters[index]);
                },
              ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No printers found matching your criteria.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationButton() {
    return Consumer<CartService>(
      builder: (context, cartService, child) {
        return badges.Badge(
          badgeContent: Text(
            '${cartService.notificationCount}',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          showBadge: cartService.notificationCount > 0,
          badgeStyle: const badges.BadgeStyle(
            badgeColor: Colors.red,
          ),
          child: FloatingActionButton(
            onPressed: _showNotifications,
            child: const Icon(Icons.notifications_outlined),
          ),
        );
      },
    );
  }

  Widget _buildFilterModal() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter Options',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text('Coming soon: Price range, brand filters, and more!'),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsModal() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  context.read<CartService>().markNotificationsAsRead();
                  Navigator.pop(context);
                },
                child: const Text('Mark all as read'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildNotificationItem('New printers added to your wishlist category'),
          _buildNotificationItem('Special discount: 20% off on HP printers'),
          _buildNotificationItem('Your cart has items waiting for checkout'),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppConstants.cardBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.notifications,
            color: AppConstants.primaryColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: AppConstants.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}