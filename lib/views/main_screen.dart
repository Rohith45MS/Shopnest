import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import '../controllers/cart_controller.dart';
import '../core/constants/app_colors.dart';
import 'home/home_screen.dart';
import 'products/product_list_screen.dart';
import 'cart/cart_screen.dart';
import 'profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _screens = const [
    HomeScreen(),
    ProductListScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartController>().itemCount;

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ShopnestNavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: 'Home',
                  isSelected: _currentIndex == 0,
                  onTap: () => setState(() => _currentIndex = 0),
                ),
                _ShopnestNavItem(
                  icon: Icons.favorite_border_rounded,
                  activeIcon: Icons.favorite_rounded,
                  label: 'Products',
                  isSelected: _currentIndex == 1,
                  onTap: () => setState(() => _currentIndex = 1),
                ),
                _ShopnestCartNavItem(
                  isSelected: _currentIndex == 2,
                  onTap: () => setState(() => _currentIndex = 2),
                  cartCount: cartCount,
                ),
                _ShopnestNavItem(
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: 'Profile',
                  isSelected: _currentIndex == 3,
                  onTap: () => setState(() => _currentIndex = 3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ShopnestNavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ShopnestNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding:
            isSelected
                ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                : const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.shopnestGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? Colors.black : Colors.white54,
              size: 22,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ShopnestCartNavItem extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final int cartCount;

  const _ShopnestCartNavItem({
    required this.isSelected,
    required this.onTap,
    required this.cartCount,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding:
            isSelected
                ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                : const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.shopnestGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            badges.Badge(
              showBadge: cartCount > 0,
              badgeContent: Text(
                cartCount > 99 ? '99+' : '$cartCount',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
              badgeStyle: const badges.BadgeStyle(
                badgeColor: Colors.red,
                padding: EdgeInsets.all(4),
              ),
              child: Icon(
                isSelected ? Icons.shopping_bag : Icons.shopping_bag_rounded,
                color: isSelected ? Colors.black : Colors.white54,
                size: 22,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                'Cart',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
