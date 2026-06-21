import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/category_controller.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/product_card.dart';
import '../widgets/product_card_shimmer.dart';
import '../widgets/error_state_widget.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctrl = context.read<ProductController>();
      if (!ctrl.hasData) ctrl.fetchProducts();
      context.read<CategoryController>().fetchCategories();
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ProductController>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder:
            (_, innerBoxIsScrolled) => [
              SliverAppBar(
                floating: true,
                snap: true,
                backgroundColor:
                    isDark ? AppColors.darkBackground : const Color(0xFFF7F7F7),
                elevation: 0,
                title: Text(
                  'All Products',
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.darkText : Colors.black,
                    letterSpacing: -0.5,
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(112),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged:
                              (val) => context
                                  .read<ProductController>()
                                  .searchProducts(val),
                          decoration: InputDecoration(
                            hintText: 'Search products...',
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              color: AppColors.primary,
                            ),
                            suffixIcon:
                                _searchController.text.isNotEmpty
                                    ? IconButton(
                                      icon: const Icon(Icons.clear_rounded),
                                      onPressed: () {
                                        _searchController.clear();
                                        context
                                            .read<ProductController>()
                                            .clearSearch();
                                      },
                                    )
                                    : null,
                          ),
                        ),
                      ),

                      Consumer<CategoryController>(
                        builder: (_, catCtrl, __) {
                          if (!catCtrl.hasData)
                            return const SizedBox(height: 8);
                          final categories = catCtrl.categories;
                          final selectedId =
                              context
                                  .watch<ProductController>()
                                  .selectedCategoryId;
                          return SizedBox(
                            height: 44,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemCount: categories.length + 1,
                              itemBuilder: (_, i) {
                                if (i == 0) {
                                  return _FilterChip(
                                    label: 'All',
                                    isSelected: selectedId == null,
                                    onTap:
                                        () => context
                                            .read<ProductController>()
                                            .filterByCategory(null),
                                  );
                                }
                                final cat = categories[i - 1];
                                return _FilterChip(
                                  label: cat.name,
                                  isSelected: selectedId == cat.id,
                                  onTap:
                                      () => context
                                          .read<ProductController>()
                                          .filterByCategory(cat.id),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
        body: Consumer<ProductController>(
          builder: (_, ctrl, __) {
            if (ctrl.isLoading && ctrl.products.isEmpty) {
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.72,
                ),
                itemCount: 8,
                itemBuilder: (_, __) => const ProductCardShimmer(),
              );
            }

            if (ctrl.hasError && ctrl.products.isEmpty) {
              return ErrorStateWidget(
                message: ctrl.errorMessage,
                onRetry: () => ctrl.fetchProducts(refresh: true),
              );
            }

            if (ctrl.products.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 64,
                      color:
                          isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No products found',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
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

            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () => ctrl.fetchProducts(refresh: true),
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.72,
                ),
                itemCount: ctrl.products.length + (ctrl.isLoadingMore ? 2 : 0),
                itemBuilder: (_, index) {
                  if (index >= ctrl.products.length) {
                    return const ProductCardShimmer();
                  }
                  return ProductCard(product: ctrl.products[index]);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8, bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFEAEAEC),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.lightTextSecondary,
          ),
        ),
      ),
    );
  }
}
