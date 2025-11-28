import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import '../services/cart_service.dart';
import '../screens/cart_screen.dart';
import '../screens/profile_screen.dart';
import '../utils/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showCartIcon;
  final bool showProfileIcon;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.showCartIcon = true,
    this.showProfileIcon = true,
    this.showBackButton = false,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackPressed ?? () => Navigator.pop(context),
            )
          : null,
      actions: [
        if (showCartIcon) _buildCartIcon(context),
        if (showProfileIcon) _buildProfileIcon(context),
      ],
    );
  }

  Widget _buildCartIcon(BuildContext context) {
    return Consumer<CartService>(
      builder: (context, cartService, child) {
        return badges.Badge(
          badgeContent: Text(
            '${cartService.itemCount}',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          showBadge: cartService.itemCount > 0,
          badgeStyle: const badges.BadgeStyle(
            badgeColor: AppConstants.primaryColor,
          ),
          child: IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildProfileIcon(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.person_outline),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}