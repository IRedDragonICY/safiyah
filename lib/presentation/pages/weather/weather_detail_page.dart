import 'package:flutter/material.dart';

class WeatherDetailPage extends StatefulWidget {
  const WeatherDetailPage({super.key});

  @override
  State<WeatherDetailPage> createState() => _WeatherDetailPageState();
}

class _WeatherDetailPageState extends State<WeatherDetailPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedProvider = 'OpenWeather';

  final List<String> _providers = [
    'OpenWeather',
    'AccuWeather',
    'Weather.com',
    'Dark Sky',
    'WeatherAPI',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Mock weather data
  Map<String, dynamic> get _currentWeather => {
    'temperature': 24,
    'feelsLike': 26,
    'condition': 'Partly Cloudy',
    'humidity': 65,
    'windSpeed': 12,
    'windDirection': 'SW',
    'pressure': 1013,
    'visibility': 10,
    'uvIndex': 6,
    'dewPoint': 17,
    'sunrise': '06:30',
    'sunset': '18:45',
    'cloudCover': 40,
    'location': 'Tokyo, Japan',
    'lastUpdated': '2024-01-15 14:30',
  };

  List<Map<String, dynamic>> get _hourlyForecast => [
    {'time': '15:00', 'temp': 25, 'condition': 'sunny', 'rain': 0},
    {'time': '16:00', 'temp': 26, 'condition': 'sunny', 'rain': 0},
    {'time': '17:00', 'temp': 25, 'condition': 'partly_cloudy', 'rain': 10},
    {'time': '18:00', 'temp': 23, 'condition': 'partly_cloudy', 'rain': 20},
    {'time': '19:00', 'temp': 22, 'condition': 'cloudy', 'rain': 30},
    {'time': '20:00', 'temp': 21, 'condition': 'rainy', 'rain': 60},
    {'time': '21:00', 'temp': 20, 'condition': 'rainy', 'rain': 80},
    {'time': '22:00', 'temp': 20, 'condition': 'rainy', 'rain': 70},
  ];

  List<Map<String, dynamic>> get _weeklyForecast => [
    {
      'day': 'Today',
      'date': 'Jan 15',
      'condition': 'partly_cloudy',
      'high': 26,
      'low': 18,
      'rain': 20,
      'humidity': 65,
    },
    {
      'day': 'Tomorrow',
      'date': 'Jan 16',
      'condition': 'rainy',
      'high': 22,
      'low': 16,
      'rain': 80,
      'humidity': 85,
    },
    {
      'day': 'Wednesday',
      'date': 'Jan 17',
      'condition': 'cloudy',
      'high': 20,
      'low': 14,
      'rain': 40,
      'humidity': 70,
    },
    {
      'day': 'Thursday',
      'date': 'Jan 18',
      'condition': 'sunny',
      'high': 25,
      'low': 16,
      'rain': 5,
      'humidity': 55,
    },
    {
      'day': 'Friday',
      'date': 'Jan 19',
      'condition': 'sunny',
      'high': 27,
      'low': 18,
      'rain': 0,
      'humidity': 50,
    },
    {
      'day': 'Saturday',
      'date': 'Jan 20',
      'condition': 'partly_cloudy',
      'high': 24,
      'low': 17,
      'rain': 15,
      'humidity': 60,
    },
    {
      'day': 'Sunday',
      'date': 'Jan 21',
      'condition': 'thunderstorm',
      'high': 21,
      'low': 15,
      'rain': 90,
      'humidity': 90,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 350,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Theme.of(context).colorScheme.surface,
              surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
              actions: [
                PopupMenuButton<String>(
                  onSelected: (value) {
                    setState(() {
                      _selectedProvider = value;
                    });
                  },
                  icon: Icon(
                    Icons.more_vert,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        enabled: false,
                        child: Text(
                          'Weather Provider',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const PopupMenuDivider(),
                      ..._providers.map((provider) {
                        return PopupMenuItem<String>(
                          value: provider,
                          child: Row(
                            children: [
                              if (_selectedProvider == provider)
                                Icon(
                                  Icons.check,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 20,
                                )
                              else
                                const SizedBox(width: 20),
                              const SizedBox(width: 8),
                              Text(provider),
                            ],
                          ),
                        );
                      }).toList(),
                    ];
                  },
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: _buildWeatherHeader(),
              ),
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Theme.of(context).colorScheme.primary,
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
                tabs: const [
                  Tab(text: 'Today'),
                  Tab(text: 'Hourly'),
                  Tab(text: '7 Days'),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildTodayTab(),
            _buildHourlyTab(),
            _buildWeeklyTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherHeader() {
    final weather = _currentWeather;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getWeatherGradientColor(weather['condition'])[0],
            _getWeatherGradientColor(weather['condition'])[1],
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: CustomPaint(
              painter: WeatherPatternPainter(),
            ),
          ),
          
          // Main content
          Positioned(
            left: 24,
            right: 24,
            bottom: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Provider badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.cloud,
                        size: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _selectedProvider,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Location
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.white.withValues(alpha: 0.9),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      weather['location'],
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Temperature and condition
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${weather['temperature']}',
                                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 72,
                                  height: 0.9,
                                ),
                              ),
                              Text(
                                '°C',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            weather['condition'],
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Feels like ${weather['feelsLike']}°C',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Weather icon
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                      child: Icon(
                        _getWeatherIcon(weather['condition']),
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayTab() {
    final weather = _currentWeather;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current details grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.3,
            children: [
              _buildWeatherDetailCard(
                context,
                icon: Icons.water_drop,
                title: 'Humidity',
                value: '${weather['humidity']}%',
                color: Colors.blue,
              ),
              _buildWeatherDetailCard(
                context,
                icon: Icons.air,
                title: 'Wind Speed',
                value: '${weather['windSpeed']} km/h ${weather['windDirection']}',
                color: Colors.green,
              ),
              _buildWeatherDetailCard(
                context,
                icon: Icons.compress,
                title: 'Pressure',
                value: '${weather['pressure']} hPa',
                color: Colors.orange,
              ),
              _buildWeatherDetailCard(
                context,
                icon: Icons.visibility,
                title: 'Visibility',
                value: '${weather['visibility']} km',
                color: Colors.purple,
              ),
              _buildWeatherDetailCard(
                context,
                icon: Icons.wb_sunny,
                title: 'UV Index',
                value: '${weather['uvIndex']} (High)',
                color: Colors.red,
              ),
              _buildWeatherDetailCard(
                context,
                icon: Icons.opacity,
                title: 'Dew Point',
                value: '${weather['dewPoint']}°C',
                color: Colors.teal,
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Sun times
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.orange.withValues(alpha: 0.1),
                  Colors.yellow.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.orange.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Icon(
                        Icons.wb_sunny_outlined,
                        color: Colors.orange,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sunrise',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        weather['sunrise'],
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 60,
                  color: Colors.orange.withValues(alpha: 0.3),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Icon(
                        Icons.brightness_3,
                        color: Colors.deepOrange,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sunset',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        weather['sunset'],
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Last updated
          Center(
            child: Text(
              'Last updated: ${weather['lastUpdated']}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hourly Forecast',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _hourlyForecast.length,
              itemBuilder: (context, index) {
                final forecast = _hourlyForecast[index];
                return Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        forecast['time'],
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(
                        _getWeatherIcon(forecast['condition']),
                        size: 32,
                        color: _getConditionColor(forecast['condition']),
                      ),
                      Text(
                        '${forecast['temp']}°',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.water_drop,
                            size: 12,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${forecast['rain']}%',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '7-Day Forecast',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...(_weeklyForecast.map((forecast) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                children: [
                  // Day and date
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          forecast['day'],
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          forecast['date'],
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Weather icon
                  Icon(
                    _getWeatherIcon(forecast['condition']),
                    size: 32,
                    color: _getConditionColor(forecast['condition']),
                  ),
                  const SizedBox(width: 16),
                  
                  // Rain chance
                  Container(
                    width: 60,
                    child: Row(
                      children: [
                        Icon(
                          Icons.water_drop,
                          size: 16,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${forecast['rain']}%',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Temperature range
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${forecast['low']}°',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${forecast['high']}°',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList()),
        ],
      ),
    );
  }

  Widget _buildWeatherDetailCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
      case 'clear':
        return Icons.wb_sunny;
      case 'partly cloudy':
      case 'partly_cloudy':
        return Icons.wb_cloudy;
      case 'cloudy':
      case 'overcast':
        return Icons.cloud;
      case 'rainy':
      case 'rain':
        return Icons.umbrella;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'snowy':
      case 'snow':
        return Icons.ac_unit;
      default:
        return Icons.wb_sunny;
    }
  }

  Color _getConditionColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
      case 'clear':
        return Colors.orange;
      case 'partly cloudy':
      case 'partly_cloudy':
        return Colors.amber;
      case 'cloudy':
      case 'overcast':
        return Colors.grey;
      case 'rainy':
      case 'rain':
        return Colors.blue;
      case 'thunderstorm':
        return Colors.deepPurple;
      case 'snowy':
      case 'snow':
        return Colors.lightBlue;
      default:
        return Colors.orange;
    }
  }

  List<Color> _getWeatherGradientColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
      case 'clear':
        return [Colors.orange.shade400, Colors.yellow.shade300];
      case 'partly cloudy':
        return [Colors.blue.shade400, Colors.lightBlue.shade300];
      case 'cloudy':
      case 'overcast':
        return [Colors.grey.shade500, Colors.blueGrey.shade400];
      case 'rainy':
      case 'rain':
        return [Colors.blueGrey.shade600, Colors.blue.shade400];
      case 'thunderstorm':
        return [Colors.grey.shade800, Colors.purple.shade400];
      case 'snowy':
      case 'snow':
        return [Colors.lightBlue.shade300, Colors.white];
      default:
        return [Colors.blue.shade400, Colors.lightBlue.shade300];
    }
  }
}

class WeatherPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    // Draw some decorative circles
    for (int i = 0; i < 5; i++) {
      canvas.drawCircle(
        Offset(size.width * (0.1 + i * 0.2), size.height * 0.3),
        20,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
} 
