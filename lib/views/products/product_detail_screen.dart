import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../models/product_model.dart';
import '../../controllers/cart_controller.dart';
import '../../core/constants/app_colors.dart';
import '../main_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final PageController _imageController = PageController();

  List<String> get _validImages {
    final imgs =
        widget.product.images.where((url) {
          final cleaned = url.trim();
          return cleaned.isNotEmpty && cleaned.startsWith('http');
        }).toList();
    return imgs.isEmpty
        ? ['https://placehold.co/600x400/6C63FF/FFFFFF?text=Product']
        : imgs;
  }

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cartCtrl = context.watch<CartController>();
    final isInCart = cartCtrl.isInCart(widget.product.id);
    final cartQty = cartCtrl.quantityInCart(widget.product.id);

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : const Color(0xFFF5F5F6),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 340,
            pinned: true,
            backgroundColor:
                isDark ? AppColors.darkBackground : const Color(0xFFF7F7F7),
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.darkCardBg : Colors.white)
                      .withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  PageView.builder(
                    controller: _imageController,
                    itemCount: _validImages.length,
                    itemBuilder: (_, index) {
                      return CachedNetworkImage(
                        imageUrl: _validImages[index],
                        fit: BoxFit.cover,
                        placeholder:
                            (_, __) => Container(
                              color:
                                  isDark
                                      ? AppColors.darkCardBg
                                      : const Color(0xFFF5F5F6),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                        errorWidget:
                            (_, __, ___) => Container(
                              color:
                                  isDark
                                      ? AppColors.darkCardBg
                                      : const Color(0xFFF5F5F6),
                              child: const Icon(
                                Icons.image_not_supported_outlined,
                                size: 60,
                                color: AppColors.primary,
                              ),
                            ),
                      );
                    },
                  ),

                  if (_validImages.length > 1)
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: SmoothPageIndicator(
                          controller: _imageController,
                          count: _validImages.length,
                          effect: ExpandingDotsEffect(
                            activeDotColor: AppColors.primary,
                            dotColor: Colors.white.withOpacity(0.5),
                            dotHeight: 6,
                            dotWidth: 6,
                          ),
                        ),
                      ),
                    ),

                  Positioned(
                    top: 60,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Text(
                        widget.product.category.name,
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.title,
                          style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color:
                                isDark
                                    ? AppColors.darkText
                                    : AppColors.lightText,
                            height: 1.3,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '₹${widget.product.price.toStringAsFixed(2)}',
                            style: GoogleFonts.outfit(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '● In Stock',
                              style: GoogleFonts.outfit(
                                color: AppColors.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Divider(
                    color:
                        isDark ? AppColors.darkBorder : const Color(0xFFEAEAEC),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Description',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color:
                          isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 24),

                  if (isInCart) ...[
                    Text(
                      'Quantity in Cart',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color:
                            isDark ? AppColors.darkText : AppColors.lightText,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _QtyButton(
                          icon: Icons.remove_rounded,
                          onTap:
                              () => context
                                  .read<CartController>()
                                  .decrementQuantity(widget.product.id),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '$cartQty',
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color:
                                isDark
                                    ? AppColors.darkText
                                    : AppColors.lightText,
                          ),
                        ),
                        const SizedBox(width: 16),
                        _QtyButton(
                          icon: Icons.add_rounded,
                          onTap:
                              () => context
                                  .read<CartController>()
                                  .incrementQuantity(widget.product.id),
                        ),
                        const Spacer(),
                        Text(
                          'Total: ₹${(widget.product.price * cartQty).toStringAsFixed(2)}',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            if (isInCart) ...[
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    context.read<CartController>().removeFromCart(
                      widget.product.id,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Removed from cart'),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.remove_shopping_cart_outlined,
                    color: AppColors.error,
                  ),
                  label: Text(
                    'Remove',
                    style: GoogleFonts.outfit(
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.error),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (isInCart) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MainScreen(initialIndex: 2),
                      ),
                      (route) => false,
                    );
                  } else {
                    context.read<CartController>().addToCart(widget.product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${widget.product.title} added to cart!'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: AppColors.primary,
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }
                },
                icon: Icon(
                  isInCart
                      ? Icons.shopping_cart_checkout_rounded
                      : Icons.add_shopping_cart_rounded,
                ),
                label: Text(
                  isInCart ? 'View Cart' : 'Add to Cart',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        ),
        child: Icon(icon, color: AppColors.primary, size: 18),
      ),
    );
  }
}
