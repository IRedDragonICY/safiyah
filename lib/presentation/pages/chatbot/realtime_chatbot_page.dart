import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart AI Companion'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
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
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera/AR view or Voice Orb
          _buildMainView(),
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
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0a0a0a),
            Color(0xFF1a1a2e),
            Color(0xFF16213e),
            Color(0xFF0f3460),
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
                          Colors.red.withValues(alpha: 0.8),
                          Colors.red.withValues(alpha: 0.4),
                          Colors.red.withValues(alpha: 0.1),
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
                        ? Colors.red.withValues(alpha: 0.5)
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
                      color: Colors.white.withValues(alpha: 0.9),
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
    return Container(
      color: Colors.black,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 16),
            Text(
              'Initializing Camera...',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraErrorView() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Camera Error',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _cameraError!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[400],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _initializeCamera,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArOverlay() {
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
              color: Colors.black.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Colors.blue, width: 2),
            ),
            child: const Stack(
              children: [
                Center(
                  child: Icon(
                    Icons.navigation,
                    color: Colors.red,
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
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
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
          child: _buildArWaypoint('Masjid Al-Haram', '500m', Icons.mosque, Colors.green),
        ),
        Positioned(
          top: 300,
          right: 80,
          child: _buildArWaypoint('Halal Restaurant', '200m', Icons.restaurant, Colors.orange),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        Container(
          width: 2,
          height: 20,
          color: color.withValues(alpha: 0.7),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: color, width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                distance,
                style: const TextStyle(
                  color: Colors.grey,
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on, color: Colors.blue, size: 14),
              SizedBox(width: 4),
              Text(
                'Current Location',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Mecca, Saudi Arabia',
            style: TextStyle(color: Colors.grey, fontSize: 9),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.visibility, color: Colors.green, size: 14),
              const SizedBox(width: 4),
              Text(
                '${_isArEnabled ? '2' : '0'} places nearby',
                style: const TextStyle(color: Colors.white, fontSize: 9),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverlayControls() {
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
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(String label, String status, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? Colors.green : Colors.grey,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive ? Colors.green : Colors.grey,
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
                style: const TextStyle(color: Colors.white70, fontSize: 10),
              ),
              Text(
                status,
                style: TextStyle(
                  color: isActive ? Colors.green : Colors.white,
                  fontSize: 12,
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
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withValues(alpha: 0.9),
            Colors.transparent,
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
                  ? Colors.blue.withValues(alpha: 0.3)
                  : Colors.grey.withValues(alpha: 0.3),
              shape: BoxShape.circle,
              border: Border.all(
                color: isActive ? Colors.blue : Colors.grey,
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              color: isActive ? Colors.white : Colors.grey[400],
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey[400],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainMicButton() {
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
                  ? Colors.red.withValues(alpha: 0.3)
                  : Colors.blue.withValues(alpha: 0.3),
              shape: BoxShape.circle,
              border: Border.all(
                color: _isListening ? Colors.red : Colors.blue,
                width: 3,
              ),
              boxShadow: _isListening ? [
                BoxShadow(
                  color: Colors.red.withValues(alpha: 0.5),
                  blurRadius: 20 * _pulseController.value,
                  spreadRadius: 5 * _pulseController.value,
                ),
              ] : null,
            ),
            child: Icon(
              _isListening ? Icons.mic : Icons.mic_none,
              color: _isListening ? Colors.red : Colors.white,
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
      _cameraController?.dispose();
      _cameraController = null;
      setState(() {
        _isCameraInitialized = false;
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Color(0xFF1E1E1E), // Dark background
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Smart AI Companion Settings',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Voice selection
                    Text(
                      'AI Voice',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedVoice,
                      dropdownColor: const Color(0xFF2D2D2D),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
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
                    _buildDarkSwitchTile(
                      'AR Navigation',
                      'Overlay navigation information',
                      _isArEnabled,
                      (value) {
                        setModalState(() => _isArEnabled = value);
                        setState(() => _isArEnabled = value);
                      },
                    ),
                    
                    _buildDarkSwitchTile(
                      'Camera',
                      'Enable visual AI features',
                      _isCameraEnabled,
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
                    
                    _buildDarkSwitchTile(
                      'Speaker Output',
                      'Use speaker instead of earphone',
                      _useSpeaker,
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
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Smart Travel Companion Features',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[300],
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '• Real-time environmental awareness\n'
                            '• Voice-guided navigation with AR\n'
                            '• Accessibility support for visually impaired\n'
                            '• Cultural and religious guidance\n'
                            '• Emergency assistance\n'
                            '• Multimodal AI (see, hear, understand)',
                            style: TextStyle(fontSize: 13, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDarkSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
      value: value,
      activeColor: Colors.blue,
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