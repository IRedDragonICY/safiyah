import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:safiyah/routes/route_names.dart';

class MainNavigationWrapper extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainNavigationWrapper({
    super.key,
    required this.navigationShell,
  });

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> with TickerProviderStateMixin {
  bool _isNavigating = false;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index, BuildContext context) {
    if (_isNavigating) return;
    
    setState(() {
      _isNavigating = true;
    });

    // Add haptic feedback
    HapticFeedback.lightImpact();

    // Navigate using GoRouter directly for tap navigation
    widget.navigationShell.goBranch(
      index, 
      initialLocation: index == widget.navigationShell.currentIndex
    );
    
    // Reset navigation state
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _isNavigating = false;
        });
      }
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_isNavigating) return;
    
    const double swipeThreshold = 200.0;
    final currentIndex = widget.navigationShell.currentIndex;
    
    // Check swipe velocity for determining direction
    if (details.primaryVelocity != null && details.primaryVelocity!.abs() > swipeThreshold) {
      if (details.primaryVelocity! > 0) {
        // Swipe right - go to previous page
        if (currentIndex > 0) {
          _animateSwipe(currentIndex - 1, isSwipeRight: true);
        }
      } else {
        // Swipe left - go to next page  
        if (currentIndex < 4) {
          _animateSwipe(currentIndex + 1, isSwipeRight: false);
        }
      }
    }
  }

  void _animateSwipe(int targetIndex, {required bool isSwipeRight}) {
    if (_isNavigating) return;
    
    setState(() {
      _isNavigating = true;
    });

    // Add haptic feedback
    HapticFeedback.lightImpact();

    // Setup slide animation
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(isSwipeRight ? 1.0 : -1.0, 0),
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));

    // Start slide out animation
    _slideController.forward().then((_) {
      // Navigate to target page
      widget.navigationShell.goBranch(
        targetIndex, 
        initialLocation: targetIndex == widget.navigationShell.currentIndex
      );

      // Setup slide in animation
      _slideAnimation = Tween<Offset>(
        begin: Offset(isSwipeRight ? -1.0 : 1.0, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeInOut,
      ));

      // Reset and slide in
      _slideController.reset();
      _slideController.forward().then((_) {
        if (mounted) {
          setState(() {
            _isNavigating = false;
          });
        }
      });
    });
  }

  Widget _buildNavItem(BuildContext context, {required IconData icon, required int index}) {
    final isSelected = widget.navigationShell.currentIndex == index;
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
      body: GestureDetector(
        onHorizontalDragEnd: _onHorizontalDragEnd,
        child: SlideTransition(
          position: _slideAnimation,
          child: widget.navigationShell,
        ),
      ),
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
            _buildNavItem(context, icon: Icons.event_outlined, index: 4),
          ],
        ),
      ),
    );
  }
}
