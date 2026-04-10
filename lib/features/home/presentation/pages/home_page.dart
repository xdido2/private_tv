import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:private_tv/features/videos/presentation/bloc/videos_bloc.dart';
import 'package:private_tv/features/settings/presentation/pages/settings_page.dart';
import 'package:private_tv/features/videos/presentation/pages/video_list_page.dart';
import 'package:private_tv/core/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSuperuser = false;
  int _selectedIndex = 0;
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final superuser = prefs.getBool("is_superuser") ?? false;
    final avatarUrl = prefs.getString("avatar");
    setState(() {
      _isSuperuser = superuser;
      _avatarUrl = avatarUrl;
    });

    if (mounted) context.read<VideosBloc>().add(VideosInitEvent(onlyPrivate: false));
  }

  void _onTap(int index) {
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);

    if (index == 0) {
      if (mounted) context.read<VideosBloc>().add(VideosInitEvent(onlyPrivate: false));
    } else if (index == 1 && _isSuperuser) {
      context.read<VideosBloc>().add(VideosInitEvent(onlyPrivate: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dynamically build tabs based on superuser status
    final List<Widget> tabs = [];
    tabs.add(const VideoListPage(onlyPrivate: false));
    if (_isSuperuser) {
      tabs.add(const VideoListPage(onlyPrivate: true));
    }
    tabs.add(const SettingsPage());

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: CustomAppBar(avatarUrl: _avatarUrl),
      body: tabs[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onTap,
        isSuperuser: _isSuperuser,
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? avatarUrl;

  const CustomAppBar({super.key, this.avatarUrl});

  @override
  Size get preferredSize => Size.fromHeight(72.h);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          height: preferredSize.height + MediaQuery.of(context).padding.top,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            left: 24.w,
            right: 24.w,
            bottom: 16.h,
          ),
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Logo section
              Row(
                children: [
                  Icon(
                    Icons.lock,
                    color: AppColors.primary,
                    size: 24.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'PrivateTV',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                          letterSpacing: -1,
                        ),
                  ),
                ],
              ),
              // Actions section
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      color: AppColors.onSurfaceVariant,
                      size: 24.sp,
                    ),
                    onPressed: () {},
                    splashRadius: 24.r,
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surfaceContainerHighest,
                      image: avatarUrl != null && avatarUrl!.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(avatarUrl!),
                              fit: BoxFit.cover,
                            )
                          : const DecorationImage(
                              image: AssetImage("assets/default_avatar.jpg"),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;
  final bool isSuperuser;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    required this.isSuperuser,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(999.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9 > 400
                  ? 400
                  : MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.background.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(999.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavBarItem(
                    icon: Icons.home,
                    label: 'Home',
                    isSelected: selectedIndex == 0,
                    onTap: () => onTap(0),
                  ),
                  if (isSuperuser)
                    _NavBarItem(
                      icon: Icons.local_fire_department,
                      label: 'Hot',
                      isSelected: selectedIndex == 1,
                      onTap: () => onTap(1),
                    ),
                  _NavBarItem(
                    icon: Icons.settings,
                    label: 'Settings',
                    isSelected: selectedIndex == (isSuperuser ? 2 : 1),
                    onTap: () => onTap(isSuperuser ? 2 : 1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
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
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(999.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : Colors.grey[500],
              size: 24.sp,
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isSelected ? AppColors.primary : Colors.grey[500],
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
