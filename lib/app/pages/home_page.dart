import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:private_tv/api/videos/bloc/videos_bloc.dart';
import 'package:private_tv/app/components/logo.dart';
import 'package:private_tv/app/pages/settings_pages/settings_page.dart';
import 'package:private_tv/app/pages/video_pages/video_list_page.dart';
import 'package:private_tv/app/themes/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSuperuser = false;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadSuperuser();
  }

  Future<void> _loadSuperuser() async {
    final prefs = await SharedPreferences.getInstance();
    final superuser = prefs.getBool("is_superuser") ?? false;
    setState(() => _isSuperuser = superuser);

    context.read<VideosBloc>().add(VideosInitEvent(onlyPrivate: false));
  }

  void _onTap(int index) {
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);

    final onlyPrivate = _isSuperuser && index == 1;
    context.read<VideosBloc>().add(VideosInitEvent(onlyPrivate: onlyPrivate));
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      VideoListPage(onlyPrivate: false),
      if (_isSuperuser) VideoListPage(onlyPrivate: true),
      SettingsPage(),
    ];

    return Scaffold(
      appBar: CustomAppBar(),
      extendBody: true,
      body: tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.containerColor,
        selectedItemColor: AppColors.whiteColor,
        unselectedItemColor: AppColors.whiteColor.withOpacity(0.3),
        currentIndex: _selectedIndex,
        onTap: _onTap,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          if (_isSuperuser)
            const BottomNavigationBarItem(
              icon: Icon(Icons.local_fire_department),
              label: 'Hot',
            ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size(double.infinity, 86);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool _showSearch = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.containerColor,
      padding: REdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            final offsetAnimation = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation);
            return SlideTransition(
              position: offsetAnimation,
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: _showSearch
              ? Row(
                  key: const ValueKey('search'),
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 16.sp,
                        ),
                        cursorColor: AppColors.whiteColor,
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          hintStyle: TextStyle(
                            color: AppColors.whiteColor.withOpacity(0.5),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: AppColors.whiteColor,
                        size: 25.sp,
                      ),
                      onPressed: () {
                        setState(() {
                          _showSearch = false;
                          _searchController.clear();
                        });
                      },
                    ),
                  ],
                )
              : Row(
                  key: const ValueKey('normal'),
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Logo(size: 30),
                    IconButton(
                      onPressed: () => setState(() => _showSearch = true),
                      icon: Icon(
                        Icons.search,
                        color: AppColors.whiteColor,
                        size: 25.sp,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
