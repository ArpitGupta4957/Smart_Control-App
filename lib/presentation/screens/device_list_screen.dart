import 'package:flutter/material.dart';
import 'device_control_screen.dart';
import 'settings_screen.dart';
import '../../domain/entities/device_entity.dart';

class DeviceListScreen extends StatefulWidget {
  const DeviceListScreen({super.key});

  @override
  State<DeviceListScreen> createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  // Mock fan data for demonstration
  final List<DeviceEntity> _mockDevices = [
    DeviceEntity(
      id: '1',
      name: 'Living Room Fan',
      type: 'Gorilla BLDC',
      isOnline: true,
      isPowerOn: true,
      speed: 3,
      isBreezeMode: false,
      isLightOn: true,
      lastUpdated: DateTime.now(),
    ),
    DeviceEntity(
      id: '2',
      name: 'Bedroom Fan',
      type: 'Renesa Smart',
      isOnline: true,
      isPowerOn: false,
      speed: 0,
      isBreezeMode: false,
      isLightOn: false,
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    DeviceEntity(
      id: '3',
      name: 'Kitchen Fan',
      type: 'Studio BLDC',
      isOnline: true,
      isPowerOn: true,
      speed: 5,
      isBreezeMode: true,
      isLightOn: false,
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
    DeviceEntity(
      id: '4',
      name: 'Office Fan',
      type: 'Efficio Plus',
      isOnline: false,
      isPowerOn: false,
      speed: 0,
      isBreezeMode: false,
      isLightOn: false,
      lastUpdated: DateTime.now().subtract(const Duration(hours: 1)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Uncomment when real API is ready:
      // context.read<DeviceProvider>().fetchDevices();
      // context.read<DeviceProvider>().startAutoRefresh();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    // context.read<DeviceProvider>().stopAutoRefresh();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    // Simulate refresh with mock data
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
    // await context.read<DeviceProvider>().fetchDevices(showLoading: false);
  }

  @override
  Widget build(BuildContext context) {
    // Use mock data for now
    final devices = _mockDevices;
    final hasDevices = devices.isNotEmpty;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Stunning App Bar with gradient
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
              ),
              child: FlexibleSpaceBar(
                title: const Text(
                  'My Fans',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Decorative circles
                    Positioned(
                      top: -50,
                      right: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -30,
                      left: -30,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
          ),

          // Stats Card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildStatsCard(devices),
            ),
          ),

          // Devices Grid
          if (hasDevices)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final device = devices[index];
                    return _buildEnhancedDeviceCard(context, device, index);
                  },
                  childCount: devices.length,
                ),
              ),
            )
          else
            SliverFillRemaining(
              child: _buildEmptyState(),
            ),

          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(List<DeviceEntity> devices) {
    final onlineCount = devices.where((d) => d.isOnline).length;
    final activeCount = devices.where((d) => d.isPowerOn).length;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.secondaryContainer,
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              icon: Icons.devices,
              label: 'Total',
              value: '${devices.length}',
              color: Colors.blue,
            ),
            Container(
                width: 1, height: 40, color: Colors.grey.withOpacity(0.3)),
            _buildStatItem(
              icon: Icons.wifi,
              label: 'Online',
              value: '$onlineCount',
              color: Colors.green,
            ),
            Container(
                width: 1, height: 40, color: Colors.grey.withOpacity(0.3)),
            _buildStatItem(
              icon: Icons.power_settings_new,
              label: 'Active',
              value: '$activeCount',
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedDeviceCard(
      BuildContext context, DeviceEntity device, int index) {
    final delay = index * 100;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 500 + delay),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => DeviceControlScreen(device: device),
            ),
          );
        },
        child: Card(
          elevation: 8,
          shadowColor: device.isPowerOn
              ? Theme.of(context).colorScheme.primary.withOpacity(0.4)
              : Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: device.isPowerOn
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.05),
                      ],
                    )
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status badge and icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: device.isOnline
                              ? Colors.green.withOpacity(0.2)
                              : Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: device.isOnline
                                    ? Colors.green
                                    : Colors.grey,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              device.isOnline ? 'Online' : 'Offline',
                              style: TextStyle(
                                fontSize: 10,
                                color: device.isOnline
                                    ? Colors.green
                                    : Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        device.isPowerOn
                            ? Icons.power_settings_new
                            : Icons.power_settings_new_outlined,
                        color: device.isPowerOn
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey,
                        size: 28,
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Fan icon/image placeholder
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: device.isPowerOn
                            ? Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.15)
                            : Colors.grey.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: device.isPowerOn && device.speed > 0
                          ? TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.0, end: 1.0),
                              duration:
                                  Duration(milliseconds: 3000 ~/ device.speed),
                              builder: (context, value, child) {
                                return Transform.rotate(
                                  angle: value * 2 * 3.14159,
                                  child: child,
                                );
                              },
                              onEnd: () {
                                if (mounted && device.isPowerOn) {
                                  setState(() {});
                                }
                              },
                              child: Icon(
                                Icons.air,
                                size: 40,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            )
                          : Icon(
                              Icons.air,
                              size: 40,
                              color: Colors.grey,
                            ),
                    ),
                  ),

                  const Spacer(),

                  // Device name
                  Text(
                    device.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Device type
                  Text(
                    device.type,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Speed indicator
                  if (device.isPowerOn && device.speed > 0)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.speed,
                              size: 14,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Speed ${device.speed}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: device.speed / 5,
                            minHeight: 4,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      device.isPowerOn ? 'Off' : 'Standby',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),

                  // Feature indicators
                  if (device.isBreezeMode || device.isLightOn)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          if (device.isBreezeMode)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.wind_power,
                                      size: 10, color: Colors.blue),
                                  SizedBox(width: 2),
                                  Text(
                                    'Breeze',
                                    style: TextStyle(
                                        fontSize: 9, color: Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                          if (device.isBreezeMode && device.isLightOn)
                            const SizedBox(width: 4),
                          if (device.isLightOn)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.lightbulb,
                                      size: 10, color: Colors.amber),
                                  SizedBox(width: 2),
                                  Text(
                                    'Light',
                                    style: TextStyle(
                                        fontSize: 9, color: Colors.amber),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated empty state illustration
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: child,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: Icon(
                  Icons.devices_other,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'No Devices Found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Add devices to your Atomberg account\nto see them here',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _onRefresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
