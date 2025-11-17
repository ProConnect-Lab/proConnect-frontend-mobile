import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/company_provider.dart';
import '../../providers/post_provider.dart';
import 'tabs/companies_tab.dart';
import 'tabs/posts_tab.dart';
import 'tabs/profile_tab.dart';

class HomeModule extends StatefulWidget {
  const HomeModule({super.key});

  @override
  State<HomeModule> createState() => _HomeModuleState();
}

class _HomeModuleState extends State<HomeModule>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AuthController>().fetchProfile();
      Get.find<CompanyController>().fetchCompanies();
      Get.find<PostController>().fetchPosts();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final companyController = Get.find<CompanyController>();
    final postController = Get.find<PostController>();

    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: const [ProfileTab(), CompaniesTab(), PostsTab()],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: 'Profil',
                  index: 0,
                ),
                _buildNavItem(
                  icon: Icons.business_outlined,
                  activeIcon: Icons.business,
                  label: 'Entreprises',
                  index: 1,
                ),
                _buildNavItem(
                  icon: Icons.article_outlined,
                  activeIcon: Icons.article,
                  label: 'Publications',
                  index: 2,
                ),
                _buildLogoutButton(
                  authController,
                  companyController,
                  postController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isActive = _currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          _tabController.animateTo(index);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                    isActive ? activeIcon : icon,
                    color: isActive
                        ? AppTheme.primaryColor
                        : AppTheme.textSecondaryColor,
                    size: 26,
                  )
                  .animate(target: isActive ? 1 : 0)
                  .scale(
                    duration: 200.ms,
                    begin: const Offset(1, 1),
                    end: const Offset(1.1, 1.1),
                  ),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: isActive
                      ? AppTheme.primaryColor
                      : AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(
    AuthController authController,
    CompanyController companyController,
    PostController postController,
  ) {
    return InkWell(
      onTap: () async {
        await authController.logout();
        companyController.reset();
        postController.reset();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.logout, color: AppTheme.errorColor, size: 26),
            const SizedBox(height: 4),
            Text(
              'Quitter',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppTheme.errorColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
