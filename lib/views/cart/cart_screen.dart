import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../controllers/cart_controller.dart';
import '../../core/constants/app_colors.dart';
import '../products/product_detail_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cartCtrl = context.watch<CartController>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            isDark ? AppColors.darkBackground : const Color(0xFFF7F7F7),
        elevation: 0,
        centerTitle: false,
        title: Text(
          'My Cart',
          style: GoogleFonts.outfit(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.darkText : Colors.black,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          if (!cartCtrl.isEmpty)
            TextButton.icon(
              onPressed: () => _showClearDialog(context),
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.error,
                size: 18,
              ),
              label: Text(
                'Clear',
                style: GoogleFonts.outfit(color: AppColors.error),
              ),
            ),
        ],
      ),
      body:
          cartCtrl.isEmpty
              ? _EmptyCartView()
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      itemCount: cartCtrl.items.length,
                      itemBuilder: (_, index) {
                        final item = cartCtrl.items[index];
                        return Dismissible(
                          key: Key('cart_${item.product.id}'),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          onDismissed: (_) {
                            cartCtrl.removeFromCart(item.product.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${item.product.title} removed'),
                                behavior: SnackBarBehavior.floating,
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          child: _CartItemTile(item: item, isDark: isDark),
                        );
                      },
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCardBg : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color:
                              isDark
                                  ? Colors.black.withOpacity(0.2)
                                  : AppColors.primary.withOpacity(0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _SummaryRow(
                          label: 'Items (${cartCtrl.itemCount})',
                          value: '₹${cartCtrl.totalPrice.toStringAsFixed(2)}',
                          isDark: isDark,
                        ),
                        const SizedBox(height: 8),
                        _SummaryRow(
                          label: 'Shipping',
                          value: cartCtrl.totalPrice >= 500 ? 'Free' : '₹49.00',
                          isDark: isDark,
                          valueColor:
                              cartCtrl.totalPrice >= 500
                                  ? AppColors.primary
                                  : null,
                        ),
                        const SizedBox(height: 12),
                        Divider(
                          color:
                              isDark
                                  ? AppColors.darkBorder
                                  : const Color(0xFFEAEAEC),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color:
                                    isDark
                                        ? AppColors.darkText
                                        : AppColors.lightText,
                              ),
                            ),
                            Text(
                              '₹${_calculateTotal(cartCtrl)}',
                              style: GoogleFonts.outfit(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _showCheckoutDialog(context),
                            icon: const Icon(Icons.payment_rounded),
                            label: Text(
                              'Proceed to Checkout',
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }

  String _calculateTotal(CartController ctrl) {
    double total = ctrl.totalPrice;
    if (total < 500) total += 49;
    return total.toStringAsFixed(2);
  }

  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'Clear Cart',
              style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
            ),
            content: Text(
              'Are you sure you want to remove all items?',
              style: GoogleFonts.outfit(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                ),
                onPressed: () {
                  context.read<CartController>().clearCart();
                  Navigator.pop(context);
                },
                child: const Text('Clear All'),
              ),
            ],
          ),
    );
  }

  void _showCheckoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primary,
                  size: 28,
                ),
                const SizedBox(width: 8),
                Text(
                  'Order Placed!',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            content: Text(
              'Your order has been placed successfully! Thank you for shopping with ShopZen.',
              style: GoogleFonts.outfit(height: 1.5),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  context.read<CartController>().clearCart();
                  Navigator.pop(context);
                },
                child: const Text('Done'),
              ),
            ],
          ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final dynamic item;
  final bool isDark;

  const _CartItemTile({required this.item, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailScreen(product: item.product),
            ),
          ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCardBg : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color:
                  isDark
                      ? Colors.black.withOpacity(0.2)
                      : AppColors.primary.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: item.product.validImageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorWidget:
                    (_, __, ___) => Container(
                      width: 80,
                      height: 80,
                      color:
                          isDark
                              ? AppColors.darkBorder
                              : const Color(0xFFF5F5F6),
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: AppColors.primary,
                      ),
                    ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.title,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.product.category.name,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color:
                          isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '₹${item.product.price.toStringAsFixed(2)}',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const Spacer(),
                      _QtyControl(
                        qty: item.quantity,
                        onDecrement:
                            () => context
                                .read<CartController>()
                                .decrementQuantity(item.product.id),
                        onIncrement:
                            () => context
                                .read<CartController>()
                                .incrementQuantity(item.product.id),
                        isDark: isDark,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QtyControl extends StatelessWidget {
  final int qty;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final bool isDark;

  const _QtyControl({
    required this.qty,
    required this.onDecrement,
    required this.onIncrement,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CircleBtn(
          icon: Icons.remove_rounded,
          onTap: onDecrement,
          isDark: isDark,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '$qty',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
          ),
        ),
        _CircleBtn(icon: Icons.add_rounded, onTap: onIncrement, isDark: isDark),
      ],
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;

  const _CircleBtn({
    required this.icon,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        ),
        child: Icon(icon, size: 14, color: AppColors.primary),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.isDark,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 14,
            color:
                isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color:
                valueColor ??
                (isDark ? AppColors.darkText : AppColors.lightText),
          ),
        ),
      ],
    );
  }
}

class _EmptyCartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              size: 72,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Your Cart is Empty',
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add some products to get started!',
            style: GoogleFonts.outfit(
              fontSize: 14,
              color:
                  isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
