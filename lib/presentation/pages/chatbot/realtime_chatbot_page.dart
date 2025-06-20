import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibration/vibration.dart';
import 'camera_stabilizer.dart';
import 'path_guide_detector.dart';

class RealtimeChatbotPage extends StatefulWidget {
  const RealtimeChatbotPage({super.key});

  @override
  State<RealtimeChatbotPage> createState() => _RealtimeChatbotPageState();
}

class _RealtimeChatbotPageState extends State<RealtimeChatbotPage> with TickerProviderStateMixin {
  // Voice & AI State
  bool _isListening = false;
  bool _isSpeaking = false;
  bool _isCameraEnabled = true;
  bool _isArEnabled = true;
  bool _useSpeaker = true;
  bool _tapToPush = true; // New: tap to push vs click to toggle
  String _selectedVoice = 'Female - Safiyah';
  
  // Accessibility Features
  bool _isDisabilityModeEnabled = false;
  bool _isCameraStabilizationEnabled = false;
  bool _isPathGuideEnabled = false;
  late CameraStabilizer _cameraStabilizer;
  late PathGuideDetector _pathGuideDetector;
  PathGuideInfo? _currentPathInfo;
  
  // Camera Controller
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isLoading = false;
  String? _cameraError;
  
  // Animation Controllers
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late AnimationController _orbController;
  late Animation<double> _orbPulse;
  late Animation<Color?> _orbColorTween;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeAccessibilityFeatures();
    if (_isCameraEnabled) {
      _initializeCamera();
    }
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _orbController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    
    _orbPulse = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _orbController, curve: Curves.easeInOut),
    );
    
    _orbColorTween = ColorTween(
      begin: Colors.blue.shade400,
      end: Colors.purple.shade400,
    ).animate(_orbController);
  }

  void _initializeAccessibilityFeatures() {
    _cameraStabilizer = CameraStabilizer(
      onOrientationChanged: (pitch, roll) {
        if (mounted) {
          setState(() {
            // Update UI if needed based on orientation
          });
        }
      },
    );
    _cameraStabilizer.init();
    
    _pathGuideDetector = PathGuideDetector(
      onPathDetected: (pathInfo) {
        if (mounted) {
          setState(() {
            _currentPathInfo = pathInfo;
          });
          
          // Announce path changes for visually impaired
          if (_isDisabilityModeEnabled && _isPathGuideEnabled) {
            _announcePathGuidance(pathInfo);
          }
        }
      },
    );
  }

  void _announcePathGuidance(PathGuideInfo pathInfo) {
    // In real implementation, use TTS to announce
    final message = pathInfo.directionText;
    if (pathInfo.hasCrosswalk) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Crosswalk detected ahead. $message'),
          backgroundColor: Theme.of(context).colorScheme.tertiary,
        ),
      );
    } else if (pathInfo.hasObstacles) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Obstacle detected! $message'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      // Extra vibration for obstacles
      Vibration.vibrate(pattern: [0, 100, 50, 100, 50, 100]);
    }
  }

  Future<void> _initializeCamera() async {
    setState(() {
      _isLoading = true;
      _cameraError = null;
    });

    try {
      final cameraPermission = await Permission.camera.request();
      if (cameraPermission != PermissionStatus.granted) {
        setState(() {
          _cameraError = 'Camera permission is required';
          _isLoading = false;
        });
        return;
      }

      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() {
          _cameraError = 'No cameras available';
          _isLoading = false;
        });
        return;
      }

      _cameraController = CameraController(
        cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();

      // Start accessibility features if enabled
      if (_isDisabilityModeEnabled) {
        if (_isCameraStabilizationEnabled) {
          _cameraStabilizer.enable();
        }
        if (_isPathGuideEnabled) {
          _pathGuideDetector.startDetection();
          
          // Set up camera image stream for path detection
          await _cameraController!.startImageStream((CameraImage image) {
            _pathGuideDetector.processImage(image);
          });
        }
      }

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _cameraError = 'Failed to initialize camera: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    _orbController.dispose();
    _cameraController?.dispose();
    _cameraStabilizer.dispose();
    _pathGuideDetector.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Smart AI Companion',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isArEnabled ? Icons.view_in_ar : Icons.view_in_ar_outlined),
            onPressed: () => setState(() => _isArEnabled = !_isArEnabled),
            tooltip: 'Toggle AR',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettingsDialog,
            tooltip: 'Settings',
          ),
        ],
      ),
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          // Camera/AR view or Voice Orb
          _buildMainView(),
          // Path guide overlay for accessibility
          if (_isDisabilityModeEnabled && _isPathGuideEnabled && _isCameraEnabled)
            Positioned.fill(
              child: CustomPaint(
                painter: PathGuidePainter(
                  pathInfo: _currentPathInfo,
                  showGuides: true,
                ),
              ),
            ),
          // Overlay controls
          _buildOverlayControls(),
          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomControls(),
          ),
        ],
      ),
    );
  }

  Widget _buildMainView() {
    if (!_isCameraEnabled) {
      return _buildVoiceOrbView();
    }

    if (_isLoading) {
      return _buildLoadingView();
    }

    if (_cameraError != null) {
      return _buildCameraErrorView();
    }

    if (!_isCameraInitialized || _cameraController == null) {
      return _buildVoiceOrbView();
    }

    return Stack(
      children: [
        // Real camera preview
        Positioned.fill(
          child: CameraPreview(_cameraController!),
        ),
        // AR overlay
        if (_isArEnabled) Positioned.fill(child: _buildArOverlay()),
        // AR frame overlay
        if (_isArEnabled) Positioned.fill(child: _buildArFrameOverlay()),
      ],
    );
  }

  Widget _buildVoiceOrbView() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorScheme.surface,
            colorScheme.surfaceContainerLow,
            colorScheme.surfaceContainerLowest,
            colorScheme.surfaceContainer,
          ],
        ),
      ),
      child: Center(
        child: AnimatedBuilder(
          animation: _orbController,
          builder: (context, child) {
            return Transform.scale(
              scale: _isListening ? 1.0 + (_orbPulse.value - 1.0) * 0.3 : _orbPulse.value,
              child: Container(
                width: _isListening ? 200 : 150,
                height: _isListening ? 200 : 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: _isListening 
                      ? [
                          colorScheme.error.withValues(alpha: 0.8),
                          colorScheme.error.withValues(alpha: 0.4),
                          colorScheme.error.withValues(alpha: 0.1),
                        ]
                      : [
                          _orbColorTween.value!.withValues(alpha: 0.8),
                          _orbColorTween.value!.withValues(alpha: 0.4),
                          _orbColorTween.value!.withValues(alpha: 0.1),
                        ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _isListening 
                        ? colorScheme.error.withValues(alpha: 0.5)
                        : _orbColorTween.value!.withValues(alpha: 0.3),
                      blurRadius: 50,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: _isListening 
                  ? _buildVoiceVisualizer()
                  : Icon(
                      Icons.mic_none,
                      color: colorScheme.onPrimaryContainer.withValues(alpha: 0.9),
                      size: 60,
                    ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      color: colorScheme.surface,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'Initializing Camera...',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraErrorView() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      color: colorScheme.surface,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Camera Error',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _cameraError!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _initializeCamera,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArOverlay() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Stack(
      children: [
        // AR compass
        Positioned(
          top: 50,
          right: 20,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: colorScheme.surface.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: colorScheme.primary, width: 2),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    Icons.navigation,
                    color: colorScheme.error,
                    size: 32,
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      'N',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // AR waypoints
        Positioned(
          top: 200,
          left: 100,
          child: _buildArWaypoint('Masjid Al-Haram', '500m', Icons.mosque, colorScheme.primary),
        ),
        Positioned(
          top: 300,
          right: 80,
          child: _buildArWaypoint('Halal Restaurant', '200m', Icons.restaurant, colorScheme.tertiary),
        ),
        // AR info panel
        Positioned(
          top: 100,
          left: 20,
          child: _buildInfoPanel(),
        ),
      ],
    );
  }

  Widget _buildArFrameOverlay() {
    return CustomPaint(
      painter: ARFramePainter(),
      size: Size.infinite,
    );
  }

  Widget _buildArWaypoint(String name, String distance, IconData icon, Color color) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: colorScheme.surface, width: 2),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: colorScheme.onPrimary, size: 24),
        ),
        Container(
          width: 2,
          height: 20,
          color: color.withValues(alpha: 0.7),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: colorScheme.surface.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: color, width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                distance,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 8,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoPanel() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.primary, width: 1),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on, color: colorScheme.primary, size: 14),
              const SizedBox(width: 4),
              Text(
                'Current Location',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Mecca, Saudi Arabia',
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.visibility, color: colorScheme.primary, size: 14),
              const SizedBox(width: 4),
              Text(
                '${_isArEnabled ? '2' : '0'} places nearby',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          // Add camera stabilization indicator if enabled
          if (_isDisabilityModeEnabled && _isCameraStabilizationEnabled) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _cameraStabilizer.isWithinRange ? Icons.check_circle : Icons.adjust,
                  color: _cameraStabilizer.isWithinRange ? colorScheme.primary : colorScheme.error,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  _cameraStabilizer.isWithinRange ? 'Camera Stable' : 'Adjust Camera',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: _cameraStabilizer.isWithinRange 
                        ? colorScheme.primary 
                        : colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOverlayControls() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Positioned(
      top: 100,
      left: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status indicators
          _buildStatusIndicator('AI Status', _isListening ? 'Listening...' : 'Ready', _isListening),
          const SizedBox(height: 12),
          if (_isSpeaking)
            _buildStatusIndicator('AI Response', 'Speaking...', true),
          // Path guidance status for accessibility
          if (_isDisabilityModeEnabled && _isPathGuideEnabled && _currentPathInfo != null) ...[
            const SizedBox(height: 12),
            _buildStatusIndicator(
              'Path Guidance',
              _currentPathInfo!.directionText,
              _currentPathInfo!.hasPath,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(String label, String status, bool isActive) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? colorScheme.primary : colorScheme.outline,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive ? colorScheme.primary : colorScheme.outline,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                status,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isActive ? colorScheme.primary : colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceVisualizer() {
    return Center(
      child: AnimatedBuilder(
        animation: _waveController,
        builder: (context, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(5, (index) {
              final height = 20 + (40 * (0.5 + 0.5 * _waveController.value));
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: 4,
                height: height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  Widget _buildBottomControls() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            colorScheme.surface.withValues(alpha: 0.95),
            colorScheme.surface.withValues(alpha: 0.7),
            colorScheme.surface.withValues(alpha: 0),
          ],
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Camera toggle
            _buildControlButton(
              icon: _isCameraEnabled ? Icons.videocam : Icons.videocam_off,
              label: 'Camera',
              isActive: _isCameraEnabled,
              onPressed: () => _toggleCamera(),
            ),
            // Main microphone button
            _buildMainMicButton(),
            // Speaker toggle
            _buildControlButton(
              icon: _useSpeaker ? Icons.volume_up : Icons.hearing,
              label: _useSpeaker ? 'Speaker' : 'Earphone',
              isActive: _useSpeaker,
              onPressed: () => setState(() => _useSpeaker = !_useSpeaker),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isActive 
                  ? colorScheme.primaryContainer.withValues(alpha: 0.5)
                  : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              shape: BoxShape.circle,
              border: Border.all(
                color: isActive ? colorScheme.primary : colorScheme.outline,
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              color: isActive ? colorScheme.primary : colorScheme.onSurfaceVariant,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: isActive ? colorScheme.primary : colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainMicButton() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return GestureDetector(
      onTapDown: _tapToPush ? (_) => _startListening() : null,
      onTapUp: _tapToPush ? (_) => _stopListening() : null,
      onTapCancel: _tapToPush ? () => _stopListening() : null,
      onTap: !_tapToPush ? _toggleListening : null,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: _isListening 
                  ? colorScheme.errorContainer.withValues(alpha: 0.5)
                  : colorScheme.primaryContainer.withValues(alpha: 0.5),
              shape: BoxShape.circle,
              border: Border.all(
                color: _isListening ? colorScheme.error : colorScheme.primary,
                width: 3,
              ),
              boxShadow: _isListening ? [
                BoxShadow(
                  color: colorScheme.error.withValues(alpha: 0.5),
                  blurRadius: 20 * _pulseController.value,
                  spreadRadius: 5 * _pulseController.value,
                ),
              ] : null,
            ),
            child: Icon(
              _isListening ? Icons.mic : Icons.mic_none,
              color: _isListening ? colorScheme.error : colorScheme.primary,
              size: 32,
            ),
          );
        },
      ),
    );
  }

  void _toggleCamera() async {
    setState(() => _isCameraEnabled = !_isCameraEnabled);
    
    if (_isCameraEnabled) {
      await _initializeCamera();
    } else {
      // Stop accessibility features when camera is disabled
      if (_cameraController?.value.isStreamingImages ?? false) {
        await _cameraController!.stopImageStream();
      }
      _cameraStabilizer.disable();
      _pathGuideDetector.stopDetection();
      
      _cameraController?.dispose();
      _cameraController = null;
      setState(() {
        _isCameraInitialized = false;
        _currentPathInfo = null;
      });
    }
  }

  void _toggleListening() {
    if (_isListening) {
      _stopListening();
    } else {
      _startListening();
    }
  }

  void _startListening() {
    setState(() => _isListening = true);
    _pulseController.repeat();
    _waveController.repeat();
    
    // Mock listening
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _isListening && _tapToPush) {
        // Don't auto-stop for tap-to-push mode
      } else if (mounted && _isListening) {
        _stopListening();
        _simulateAiResponse();
      }
    });
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _pulseController.stop();
    _waveController.stop();
    
    if (!_tapToPush) {
      _simulateAiResponse();
    }
  }

  void _simulateAiResponse() {
    setState(() => _isSpeaking = true);
    
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() => _isSpeaking = false);
      }
    });
    
    final responses = [
      'I can see the Kaaba is 500 meters ahead. Would you like me to guide you there?',
      'There\'s a halal restaurant to your right, about 200 meters away.',
      'The Qibla direction is 24 degrees northeast from your current position.',
      'I notice you\'re near the Grand Mosque. Would you like prayer time information?',
    ];
    
    final randomResponse = responses[DateTime.now().millisecond % responses.length];
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Safiyah AI: $randomResponse'),
        duration: const Duration(seconds: 4),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showSettingsDialog() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: DraggableScrollableSheet(
                initialChildSize: 0.9,
                minChildSize: 0.5,
                maxChildSize: 0.95,
                expand: false,
                builder: (context, scrollController) => SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        Text(
                          'Smart AI Companion Settings',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 24),
                    
                        // Accessibility Section
                        Text(
                          'Accessibility Features',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        Card(
                          elevation: 0,
                          color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                _buildSwitchTile(
                                  'Disability Mode',
                                  'Enable features for visually impaired users',
                                  _isDisabilityModeEnabled,
                                  Icons.accessibility_new,
                                  (value) {
                                    setModalState(() => _isDisabilityModeEnabled = value);
                                    setState(() => _isDisabilityModeEnabled = value);
                                    if (value && _isCameraEnabled && _isCameraInitialized) {
                                      if (_isCameraStabilizationEnabled) {
                                        _cameraStabilizer.enable();
                                      }
                                      if (_isPathGuideEnabled) {
                                        _pathGuideDetector.startDetection();
                                      }
                                    } else {
                                      _cameraStabilizer.disable();
                                      _pathGuideDetector.stopDetection();
                                    }
                                  },
                                ),
                                
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  height: _isDisabilityModeEnabled ? null : 0,
                                  child: Column(
                                    children: [
                                      _buildSwitchTile(
                                        'Camera Stabilization',
                                        'Vibration feedback to help align camera',
                                        _isCameraStabilizationEnabled,
                                        Icons.vibration,
                                        (value) {
                                          setModalState(() => _isCameraStabilizationEnabled = value);
                                          setState(() => _isCameraStabilizationEnabled = value);
                                          if (value && _isDisabilityModeEnabled) {
                                            _cameraStabilizer.enable();
                                          } else {
                                            _cameraStabilizer.disable();
                                          }
                                        },
                                      ),
                                      
                                      _buildSwitchTile(
                                        'Path Guide',
                                        'Detect road lines and provide navigation guidance',
                                        _isPathGuideEnabled,
                                        Icons.navigation,
                                        (value) {
                                          setModalState(() => _isPathGuideEnabled = value);
                                          setState(() => _isPathGuideEnabled = value);
                                          if (value && _isDisabilityModeEnabled) {
                                            _pathGuideDetector.startDetection();
                                          } else {
                                            _pathGuideDetector.stopDetection();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 24),
                        
                        // Voice selection
                        Text(
                          'AI Voice',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _selectedVoice,
                          dropdownColor: colorScheme.surfaceContainerHighest,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: colorScheme.outline),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: colorScheme.primary),
                            ),
                          ),
                          style: TextStyle(color: colorScheme.onSurface),
                          items: const [
                            DropdownMenuItem(value: 'Female - Safiyah', child: Text('Female - Safiyah')),
                            DropdownMenuItem(value: 'Male - Ahmad', child: Text('Male - Ahmad')),
                            DropdownMenuItem(value: 'Female - Aisha', child: Text('Female - Aisha')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setModalState(() => _selectedVoice = value);
                              setState(() => _selectedVoice = value);
                            }
                          },
                        ),
                    
                    const SizedBox(height: 24),
                    
                    // Microphone Mode
                    Text(
                      'Microphone Mode',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          RadioListTile<bool>(
                            title: const Text('Tap to Push', style: TextStyle(color: Colors.white)),
                            subtitle: const Text('Hold to record, release to send', style: TextStyle(color: Colors.grey)),
                            value: true,
                            groupValue: _tapToPush,
                            activeColor: Colors.blue,
                            onChanged: (value) {
                              setModalState(() => _tapToPush = value!);
                              setState(() => _tapToPush = value!);
                            },
                          ),
                          RadioListTile<bool>(
                            title: const Text('Click to Toggle', style: TextStyle(color: Colors.white)),
                            subtitle: const Text('Click to start/stop recording', style: TextStyle(color: Colors.grey)),
                            value: false,
                            groupValue: _tapToPush,
                            activeColor: Colors.blue,
                            onChanged: (value) {
                              setModalState(() => _tapToPush = value!);
                              setState(() => _tapToPush = value!);
                            },
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                        // Feature toggles
                        _buildSwitchTile(
                          'AR Navigation',
                          'Overlay navigation information',
                          _isArEnabled,
                          Icons.view_in_ar,
                          (value) {
                            setModalState(() => _isArEnabled = value);
                            setState(() => _isArEnabled = value);
                          },
                        ),
                        
                        _buildSwitchTile(
                          'Camera',
                          'Enable visual AI features',
                          _isCameraEnabled,
                          Icons.camera_alt,
                          (value) {
                            setModalState(() => _isCameraEnabled = value);
                            setState(() => _isCameraEnabled = value);
                            if (value) {
                              _initializeCamera();
                            } else {
                              _cameraController?.dispose();
                              _cameraController = null;
                              setState(() => _isCameraInitialized = false);
                            }
                          },
                        ),
                        
                        _buildSwitchTile(
                          'Speaker Output',
                          'Use speaker instead of earphone',
                          _useSpeaker,
                          Icons.volume_up,
                          (value) {
                            setModalState(() => _useSpeaker = value);
                            setState(() => _useSpeaker = value);
                          },
                        ),
                    
                    const SizedBox(height: 24),
                    
                        // Info section
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: colorScheme.primary.withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Smart Travel Companion Features',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '• Real-time environmental awareness\n'
                                '• Voice-guided navigation with AR\n'
                                '• Accessibility support for visually impaired\n'
                                '• Cultural and religious guidance\n'
                                '• Emergency assistance\n'
                                '• Multimodal AI (see, hear, understand)',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, IconData? icon, Function(bool) onChanged) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return SwitchListTile(
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: colorScheme.primary),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      value: value,
      activeColor: colorScheme.primary,
      onChanged: onChanged,
    );
  }
}

class ARFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw corner brackets
    const bracketSize = 30.0;
    const margin = 40.0;

    // Top-left
    canvas.drawLine(
      const Offset(margin, margin),
      const Offset(margin + bracketSize, margin),
      paint,
    );
    canvas.drawLine(
      const Offset(margin, margin),
      const Offset(margin, margin + bracketSize),
      paint,
    );

    // Top-right
    canvas.drawLine(
      Offset(size.width - margin, margin),
      Offset(size.width - margin - bracketSize, margin),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - margin, margin),
      Offset(size.width - margin, margin + bracketSize),
      paint,
    );

    // Bottom-left
    canvas.drawLine(
      Offset(margin, size.height - margin),
      Offset(margin + bracketSize, size.height - margin),
      paint,
    );
    canvas.drawLine(
      Offset(margin, size.height - margin),
      Offset(margin, size.height - margin - bracketSize),
      paint,
    );

    // Bottom-right
    canvas.drawLine(
      Offset(size.width - margin, size.height - margin),
      Offset(size.width - margin - bracketSize, size.height - margin),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - margin, size.height - margin),
      Offset(size.width - margin, size.height - margin - bracketSize),
      paint,
    );

    // Center crosshair
    final center = Offset(size.width / 2, size.height / 2);
    const crosshairSize = 15.0;

    canvas.drawLine(
      Offset(center.dx - crosshairSize, center.dy),
      Offset(center.dx + crosshairSize, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - crosshairSize),
      Offset(center.dx, center.dy + crosshairSize),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
} 
