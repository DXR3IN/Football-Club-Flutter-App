import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ionicons/ionicons.dart';
import 'package:premiere_league_v2/components/config/app_style.dart';
import 'package:premiere_league_v2/navigation/controller/navigation_controller.dart';
import 'package:premiere_league_v2/screens/home/presentation/home_screen.dart';
import 'package:premiere_league_v2/screens/settings/presentation/settings_screen.dart';

class NavigationWidget extends StatefulWidget {
  const NavigationWidget({super.key});

  @override
  State<NavigationWidget> createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
  late NavigationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = NavigationController();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = const [
      HomeScreen(),
      SettingsScreen(),
    ];

    return Scaffold(
      body: Observer(
        builder: (_) => IndexedStack(
          index: _controller.currentIndex.value,
          children: _screens,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        shadowColor: Colors.black,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavIcon(
              icon: Ionicons.book,
              index: 0,
            ),
            _buildNavIcon(
              icon: Ionicons.settings,
              index: 1,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: _controller.onTapFavScreen,
        backgroundColor: AppStyle.primaryColor,
        child: const Icon(
          Ionicons.heart,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  Widget _buildNavIcon({required IconData icon, required int index}) {
    return Observer(
      builder: (_) => IconButton(
        onPressed: () {
          _controller.setIndex(index);
        },
        icon: Icon(
          icon,
          color: _controller.currentIndex.value == index
              ? AppStyle.primaryColor
              : Colors.grey,
        ),
      ),
    );
  }

  Widget _toFavoritePageButton() {
    return FloatingActionButton(
      onPressed: () => _controller.onTapFavScreen(),
      child: const Icon(
        Ionicons.heart,
        color: Colors.white,
        size: 35,
      ),
    );
  }
}
