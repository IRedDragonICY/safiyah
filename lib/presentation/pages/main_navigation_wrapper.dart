import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safiyah/routes/route_names.dart';

class MainNavigationWrapper extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainNavigationWrapper({
    super.key,
    required this.navigationShell,
  });

  void _onItemTapped(int index, BuildContext context) {
    navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
  }

  Widget _buildNavItem(BuildContext context, {required IconData icon, required int index}) {
    final isSelected = navigationShell.currentIndex == index;
    return IconButton(
      icon: Icon(
        icon,
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      onPressed: () => _onItemTapped(index, context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(RouteNames.chatbot),
        child: const Icon(Icons.auto_awesome),
        elevation: 2,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildNavItem(context, icon: Icons.home_outlined, index: 0),
            _buildNavItem(context, icon: Icons.schedule_outlined, index: 1),
            const SizedBox(width: 40),
            _buildNavItem(context, icon: Icons.list_alt_outlined, index: 2),
            _buildNavItem(context, icon: Icons.map_outlined, index: 3),
          ],
        ),
      ),
    );
  }
}