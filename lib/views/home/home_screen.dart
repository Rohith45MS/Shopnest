import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/category_controller.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/product_card.dart';
import '../widgets/product_card_shimmer.dart';
import '../widgets/error_state_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryController>().fetchCategories();
      context.read<ProductController>().fetchProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : const Color(0xFFF7F7F7);
    final surfaceColor = isDark ? AppColors.darkSurface : Colors.white;
    final textColor = isDark ? AppColors.darkText : Colors.black;
    final subTextColor =
        isDark ? AppColors.darkTextSecondary : Colors.grey.shade500;
    final borderColor = isDark ? AppColors.darkBorder : Colors.grey.shade300;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.shopnestGreen,
          onRefresh: () async {
            await Future.wait([
              context.read<CategoryController>().refresh(),
              context.read<ProductController>().fetchProducts(refresh: true),
            ]);
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: textColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.shopping_bag_rounded,
                          color: bgColor,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Shopnest',
                        style: GoogleFonts.outfit(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: TextField(
                    controller: _searchController,
                    style: GoogleFonts.outfit(fontSize: 14, color: textColor),
                    onChanged:
                        (val) => context
                            .read<ProductController>()
                            .searchProducts(val),
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: AppColors.shopnestGreen,
                      ),
                      suffixIcon:
                          _searchController.text.isNotEmpty
                              ? IconButton(
                                icon: Icon(
                                  Icons.clear_rounded,
                                  color: subTextColor,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  context
                                      .read<ProductController>()
                                      .clearSearch();
                                  setState(() {});
                                },
                              )
                              : null,
                      filled: true,
                      fillColor: surfaceColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.shopnestGreen,
                          width: 1.5,
                        ),
                      ),
                      hintStyle: GoogleFonts.outfit(
                        color: subTextColor,
                        fontSize: 14,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    onTap: () => setState(() {}),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Container(
                    height: 160,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1A1A1A) : Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Stack(
                      children: [
                        Positioned(
                          right: -30,
                          top: -30,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.04),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 20,
                          bottom: -40,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.04),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          top: 0,
                          child: SizedBox(
                            width: 130,
                            child: Image.network(
                              'https://images.unsplash.com/photo-1617922001439-4a2e6562f328?w=300&q=80',
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (_, __, ___) => Container(
                                    color: Colors.grey.shade900,
                                    child: const Icon(
                                      Icons.person_outline,
                                      color: Colors.white30,
                                      size: 60,
                                    ),
                                  ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 80,
                          top: 0,
                          bottom: 0,
                          width: 60,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  isDark
                                      ? const Color(0xFF1A1A1A)
                                      : Colors.black,
                                  Colors.transparent,
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(22),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Get your special\nsale up to 50%',
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w800,
                                  height: 1.25,
                                ),
                              ),
                              const SizedBox(height: 14),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 9,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.shopnestGreen,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Shop Now',
                                        style: GoogleFonts.outfit(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: const BoxDecoration(
                                          color: Colors.black,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.arrow_outward_rounded,
                                          color: Colors.white,
                                          size: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Consumer<CategoryController>(
                    builder: (_, ctrl, __) {
                      if (ctrl.isLoading) {
                        return SizedBox(
                          height: 38,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: 5,
                            itemBuilder:
                                (_, i) => Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  width: 70,
                                  decoration: BoxDecoration(
                                    color:
                                        isDark
                                            ? AppColors.darkBorder
                                            : Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                          ),
                        );
                      }
                      if (ctrl.hasData) {
                        final categories = ctrl.categories;
                        final selectedId =
                            context
                                .watch<ProductController>()
                                .selectedCategoryId;
                        return SizedBox(
                          height: 38,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: categories.length + 1,
                            itemBuilder: (_, i) {
                              if (i == 0) {
                                return _ShopnestChip(
                                  label: 'All',
                                  isSelected: selectedId == null,
                                  isDark: isDark,
                                  onTap:
                                      () => context
                                          .read<ProductController>()
                                          .filterByCategory(null),
                                );
                              }
                              final cat = categories[i - 1];
                              return _ShopnestChip(
                                label: cat.name,
                                isSelected: selectedId == cat.id,
                                isDark: isDark,
                                onTap:
                                    () => context
                                        .read<ProductController>()
                                        .filterByCategory(cat.id),
                              );
                            },
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),

              Consumer<ProductController>(
                builder: (_, ctrl, __) {
                  // Loading state
                  if (ctrl.isLoading && ctrl.products.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionHeader(
                            title: 'Popular Products',
                            isDark: isDark,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                              childAspectRatio: 0.65,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: List.generate(
                                4,
                                (_) => const ProductCardShimmer(),
                              ),
                            ),
                          ),
                          _SectionHeader(title: 'Best Selling', isDark: isDark),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                              childAspectRatio: 0.65,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: List.generate(
                                4,
                                (_) => const ProductCardShimmer(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    );
                  }

                  if (ctrl.hasError && ctrl.products.isEmpty) {
                    return SliverToBoxAdapter(
                      child: ErrorStateWidget(
                        message: ctrl.errorMessage,
                        onRetry: () => ctrl.fetchProducts(refresh: true),
                      ),
                    );
                  }

                  final all = ctrl.products;
                  final popular = all.length > 4 ? all.sublist(0, 4) : all;
                  final bestSelling =
                      all.length > 4
                          ? all.sublist(4, all.length >= 8 ? 8 : all.length)
                          : <dynamic>[];

                  return SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionHeader(
                          title: 'Popular Products',
                          isDark: isDark,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            childAspectRatio: 0.65,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children:
                                popular
                                    .map((p) => ProductCard(product: p))
                                    .toList(),
                          ),
                        ),

                        if (bestSelling.isNotEmpty) ...[
                          _SectionHeader(title: 'Best Selling', isDark: isDark),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                              childAspectRatio: 0.65,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children:
                                  bestSelling
                                      .map((p) => ProductCard(product: p))
                                      .toList(),
                            ),
                          ),
                        ],

                        const SizedBox(height: 100),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final bool isDark;

  const _SectionHeader({required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: isDark ? AppColors.darkText : Colors.black,
        ),
      ),
    );
  }
}

class _NavIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color surfaceColor;
  final Color iconColor;

  const _NavIconButton({
    required this.icon,
    required this.onTap,
    required this.surfaceColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: surfaceColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 20, color: iconColor),
      ),
    );
  }
}

class _ShopnestChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _ShopnestChip({
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selectedBg = isDark ? AppColors.shopnestGreen : Colors.black;
    final unselectedBg = isDark ? AppColors.darkCardBg : Colors.white;
    final unselectedBorder =
        isDark ? AppColors.darkBorder : Colors.grey.shade300;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? selectedBg : unselectedBg,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? selectedBg : unselectedBorder,
            width: 1.2,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : [],
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color:
                isSelected
                    ? (isDark ? Colors.black : Colors.white)
                    : (isDark
                        ? AppColors.darkTextSecondary
                        : Colors.grey.shade600),
          ),
        ),
      ),
    );
  }
}
