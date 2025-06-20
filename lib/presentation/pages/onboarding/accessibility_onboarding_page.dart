import 'package:flutter/material.dart';

class AccessibilityOnboardingPage extends StatefulWidget {
  final VoidCallback onNext;
  final Function(Map<String, dynamic>) onAccessibilitySet;

  const AccessibilityOnboardingPage({
    super.key,
    required this.onNext,
    required this.onAccessibilitySet,
  });

  @override
  State<AccessibilityOnboardingPage> createState() => _AccessibilityOnboardingPageState();
}

class _AccessibilityOnboardingPageState extends State<AccessibilityOnboardingPage> {
  // Accessibility preferences
  bool _hasDisability = false;
  bool _isVisuallyImpaired = false;
  bool _enableEyeControl = false;
  bool _hasColorBlindness = false;
  String _colorBlindnessType = 'none';
  bool _enableHighContrast = false;
  bool _enableScreenReader = false;
  bool _enableVoiceCommands = false;

  @override
  void initState() {
    super.initState();
    // Defer the initial update until after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateAccessibilityData();
    });
  }

  void _updateAccessibilityData() {
    final accessibilityData = {
      'hasDisability': _hasDisability,
      'isVisuallyImpaired': _isVisuallyImpaired,
      'enableEyeControl': _enableEyeControl,
      'hasColorBlindness': _hasColorBlindness,
      'colorBlindnessType': _colorBlindnessType,
      'enableHighContrast': _enableHighContrast,
      'enableScreenReader': _enableScreenReader,
      'enableVoiceCommands': _enableVoiceCommands,
    };
    
    widget.onAccessibilitySet(accessibilityData);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          // Header Section - Fixed at top
          Flexible(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.accessibility_new,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Accessibility Support',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Safiyah is designed for everyone. Let us know how we can make your experience better.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          // Content Section - Scrollable
          Flexible(
            flex: 4,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  
                  // Main Toggle Card
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.tune,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'I need accessibility features',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Enable customized assistance',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Transform.scale(
                                scale: 1.2,
                                child: Switch(
                                  value: _hasDisability,
                                  onChanged: (value) {
                                    setState(() {
                                      _hasDisability = value;
                                      if (!value) {
                                        // Reset all accessibility options
                                        _isVisuallyImpaired = false;
                                        _enableEyeControl = false;
                                        _hasColorBlindness = false;
                                        _colorBlindnessType = 'none';
                                        _enableHighContrast = false;
                                        _enableScreenReader = false;
                                        _enableVoiceCommands = false;
                                      }
                                    });
                                    _updateAccessibilityData();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Accessibility Options - Only show if enabled
                  if (_hasDisability) ...[
                    const SizedBox(height: 24),
                    
                    // Visual Assistance Section
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Visual Assistance',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            
                            // Visual Impairment Toggle
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'I have visual impairment',
                                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Enable AI-powered assistance',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Switch(
                                    value: _isVisuallyImpaired,
                                    onChanged: (value) {
                                      setState(() {
                                        _isVisuallyImpaired = value;
                                        if (!value) {
                                          _enableEyeControl = false;
                                          _enableScreenReader = false;
                                          _enableVoiceCommands = false;
                                        }
                                      });
                                      _updateAccessibilityData();
                                    },
                                  ),
                                ],
                              ),
                            ),
                            
                            // Visual Assistance Options
                            if (_isVisuallyImpaired) ...[
                              const SizedBox(height: 16),
                              _buildFeatureOption(
                                icon: Icons.visibility,
                                title: 'AI Eye Control',
                                subtitle: 'Navigate with eye movements',
                                value: _enableEyeControl,
                                onChanged: (value) {
                                  setState(() {
                                    _enableEyeControl = value;
                                  });
                                  _updateAccessibilityData();
                                },
                              ),
                              const SizedBox(height: 12),
                              _buildFeatureOption(
                                icon: Icons.record_voice_over,
                                title: 'Screen Reader',
                                subtitle: 'Voice descriptions of UI',
                                value: _enableScreenReader,
                                onChanged: (value) {
                                  setState(() {
                                    _enableScreenReader = value;
                                  });
                                  _updateAccessibilityData();
                                },
                              ),
                              const SizedBox(height: 12),
                              _buildFeatureOption(
                                icon: Icons.mic,
                                title: 'Voice Commands',
                                subtitle: 'Control app with voice',
                                value: _enableVoiceCommands,
                                onChanged: (value) {
                                  setState(() {
                                    _enableVoiceCommands = value;
                                  });
                                  _updateAccessibilityData();
                                },
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Color Vision Section
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.purple.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.palette,
                                    color: Colors.purple,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Color Vision',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.purple,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            
                            // Color Blindness Toggle
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'I have color blindness',
                                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Adjust colors for better visibility',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Switch(
                                    value: _hasColorBlindness,
                                    onChanged: (value) {
                                      setState(() {
                                        _hasColorBlindness = value;
                                        if (!value) {
                                          _colorBlindnessType = 'none';
                                          _enableHighContrast = false;
                                        }
                                      });
                                      _updateAccessibilityData();
                                    },
                                  ),
                                ],
                              ),
                            ),
                            
                            // Color Blindness Options
                            if (_hasColorBlindness) ...[
                              const SizedBox(height: 16),
                              Text(
                                'Select your type of color blindness:',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildColorBlindnessOption('deuteranopia', 'Deuteranopia', 'Difficulty seeing green'),
                              _buildColorBlindnessOption('protanopia', 'Protanopia', 'Difficulty seeing red'),
                              _buildColorBlindnessOption('tritanopia', 'Tritanopia', 'Difficulty seeing blue'),
                              const SizedBox(height: 16),
                              _buildFeatureOption(
                                icon: Icons.contrast,
                                title: 'High Contrast',
                                subtitle: 'Enhanced color contrast',
                                value: _enableHighContrast,
                                onChanged: (value) {
                                  setState(() {
                                    _enableHighContrast = value;
                                  });
                                  _updateAccessibilityData();
                                },
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                  ],
                ],
              ),
            ),
          ),
          
          // Bottom spacer
          const Flexible(
            flex: 1,
            child: SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: value,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorBlindnessOption(String value, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: _colorBlindnessType == value
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline.withOpacity(0.2),
          width: _colorBlindnessType == value ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: RadioListTile<String>(
        title: Text(title),
        subtitle: Text(
          description,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        value: value,
        groupValue: _colorBlindnessType,
        onChanged: (selectedValue) {
          setState(() {
            _colorBlindnessType = selectedValue!;
          });
          _updateAccessibilityData();
        },
        activeColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
} 