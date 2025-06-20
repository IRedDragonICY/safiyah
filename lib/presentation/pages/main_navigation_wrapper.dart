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
        if (currentIndex < 3) {
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

  Widget _buildNavItem(BuildContext context, {
    required IconData icon, 
    required IconData selectedIcon,
    required int index, 
    required String label
  }) {
    final isSelected = widget.navigationShell.currentIndex == index;
    final theme = Theme.of(context);
    
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _onItemTapped(index, context),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: isSelected ? BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ) : null,
                child: Icon(
                  isSelected ? selectedIcon : icon,
                  color: isSelected
                      ? theme.colorScheme.onPrimaryContainer
                      : theme.colorScheme.onSurfaceVariant,
                  size: 18,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isSelected
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 10,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
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
      floatingActionButton: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(32),
            onTap: () => context.push(RouteNames.chatbot),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 12.0,
        elevation: 8,
        shadowColor: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.2),
        child: Container(
          height: 65,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildNavItem(context, icon: Icons.home_outlined, selectedIcon: Icons.home, index: 0, label: 'Home'),
              _buildNavItem(context, icon: Icons.schedule_outlined, selectedIcon: Icons.schedule, index: 1, label: 'Prayer'),
              const SizedBox(width: 64), // Space for floating action button
              _buildNavItem(context, icon: Icons.list_alt_outlined, selectedIcon: Icons.list_alt, index: 2, label: 'Itinerary'),
              _buildNavItem(context, icon: Icons.map_outlined, selectedIcon: Icons.map, index: 3, label: 'Places'),
            ],
          ),
        ),
      ),
    );
  }
}
