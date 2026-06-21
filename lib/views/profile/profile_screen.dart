import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../controllers/user_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/error_state_widget.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserController>().fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeCtrl = context.watch<ThemeController>();
    final userCtrl = context.watch<UserController>();

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor:
            isDark ? AppColors.darkBackground : const Color(0xFFF7F7F7),
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Profile & Users',
          style: GoogleFonts.outfit(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.darkText : Colors.black,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: Builder(
        builder: (context) {
          if (userCtrl.isLoading) {
            return _buildShimmer(isDark);
          }
          if (userCtrl.hasError) {
            return ErrorStateWidget(
              message: userCtrl.errorMessage,
              onRetry: userCtrl.refresh,
            );
          }
          if (!userCtrl.hasData || userCtrl.users.isEmpty) {
            return Center(
              child: Text(
                'No user data found',
                style: GoogleFonts.outfit(fontSize: 16),
              ),
            );
          }

          final user = userCtrl.users.first;
          final username = '@${user.name.toLowerCase().replaceAll(' ', '')}';
          const phoneNumber = '+91 98765 43210';

          final cardColor = isDark ? AppColors.darkCardBg : Colors.white;
          final textColor = isDark ? AppColors.darkText : Colors.black;
          final subTextColor =
              isDark ? AppColors.darkTextSecondary : Colors.grey.shade600;
          final iconColor = isDark ? AppColors.primaryLight : AppColors.primary;

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.transparent,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: user.validAvatarUrl,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                                placeholder:
                                    (_, __) => Container(
                                      color:
                                          isDark
                                              ? AppColors.darkSurface
                                              : Colors.grey.shade200,
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                errorWidget:
                                    (_, __, ___) => CircleAvatar(
                                      radius: 60,
                                      backgroundColor: AppColors.primary
                                          .withOpacity(0.15),
                                      child: Text(
                                        user.name.isNotEmpty
                                            ? user.name[0].toUpperCase()
                                            : '?',
                                        style: GoogleFonts.outfit(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 36,
                                        ),
                                      ),
                                    ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user.name,
                          style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          username,
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.shopnestGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildDetailTile(
                          icon: Icons.email_outlined,
                          title: 'Email Address',
                          value: user.email,
                          textColor: textColor,
                          subTextColor: subTextColor,
                          iconColor: iconColor,
                        ),
                        Divider(
                          height: 1,
                          color:
                              isDark
                                  ? AppColors.darkBorder
                                  : Colors.grey.shade100,
                        ),
                        _buildDetailTile(
                          icon: Icons.phone_outlined,
                          title: 'Phone Number',
                          value: phoneNumber,
                          textColor: textColor,
                          subTextColor: subTextColor,
                          iconColor: iconColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    isDark
                                        ? Icons.dark_mode_outlined
                                        : Icons.light_mode_outlined,
                                    color: iconColor,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    'Dark Mode',
                                    style: GoogleFonts.outfit(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: textColor,
                                    ),
                                  ),
                                ],
                              ),
                              Switch.adaptive(
                                value: themeCtrl.isDarkMode,
                                activeColor: AppColors.shopnestGreen,
                                onChanged: (value) => themeCtrl.toggleTheme(),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 1,
                          color:
                              isDark
                                  ? AppColors.darkBorder
                                  : Colors.grey.shade100,
                        ),

                        _buildMenuTile(
                          icon: Icons.privacy_tip_outlined,
                          title: 'Privacy Policy',
                          textColor: textColor,
                          iconColor: iconColor,
                          onTap:
                              () => _showDialog(
                                context,
                                'Privacy Policy',
                                'This application values your privacy. We store your account details securely and process transactions via encrypted gateways. We do not sell or share your personal data with third parties.',
                              ),
                        ),
                        Divider(
                          height: 1,
                          color:
                              isDark
                                  ? AppColors.darkBorder
                                  : Colors.grey.shade100,
                        ),

                        _buildMenuTile(
                          icon: Icons.info_outline_rounded,
                          title: 'About Us',
                          textColor: textColor,
                          iconColor: iconColor,
                          onTap:
                              () => _showDialog(
                                context,
                                'About Us',
                                'Welcome to Shopnest, your ultimate e-commerce companion. We source the best quality products at highly competitive prices, with fast delivery and premium customer care services.',
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () => _showLogoutDialog(context),
                      icon: const Icon(Icons.logout_rounded),
                      label: Text(
                        'Logout',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailTile({
    required IconData icon,
    required String title,
    required String value,
    required Color textColor,
    required Color subTextColor,
    required Color iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: subTextColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required Color textColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Icon(icon, color: iconColor, size: 22),
      title: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: textColor.withOpacity(0.5),
      ),
      onTap: onTap,
    );
  }

  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              title,
              style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
            ),
            content: Text(content, style: GoogleFonts.outfit(height: 1.5)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Close',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'Logout',
              style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
            ),
            content: Text(
              'Are you sure you want to sign out from your account?',
              style: GoogleFonts.outfit(height: 1.5),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Logged out successfully'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: Text(
                  'Logout',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildShimmer(bool isDark) {
    return Shimmer.fromColors(
      baseColor:
          isDark ? AppColors.darkShimmerBase : AppColors.lightShimmerBase,
      highlightColor:
          isDark
              ? AppColors.darkShimmerHighlight
              : AppColors.lightShimmerHighlight,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const CircleAvatar(radius: 60, backgroundColor: Colors.white),
              const SizedBox(height: 16),
              Container(height: 20, width: 140, color: Colors.white),
              const SizedBox(height: 8),
              Container(height: 14, width: 80, color: Colors.white),
              const SizedBox(height: 40),
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                height: 52,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
