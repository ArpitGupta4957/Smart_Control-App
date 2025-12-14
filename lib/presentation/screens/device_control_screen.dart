import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/device_entity.dart';
import '../providers/device_provider.dart';
import '../widgets/fan_animation.dart';
import '../widgets/speed_slider.dart';
import '../widgets/control_toggle.dart';

class DeviceControlScreen extends StatefulWidget {
  final DeviceEntity device;
  
  const DeviceControlScreen({super.key, required this.device});

  @override
  State<DeviceControlScreen> createState() => _DeviceControlScreenState();
}

class _DeviceControlScreenState extends State<DeviceControlScreen> {
  Timer? _refreshTimer;
  bool _isControlling = false;
  
  @override
  void initState() {
    super.initState();
    _startAutoRefresh();
  }
  
  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }
  
  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(AppConstants.refreshInterval, (_) {
      if (!_isControlling) {
        context.read<DeviceProvider>().fetchDevice(widget.device.id);
      }
    });
  }
  
  Future<void> _togglePower(bool value) async {
    setState(() => _isControlling = true);
    
    final success = await context.read<DeviceProvider>().togglePower(
      widget.device.id,
      value,
    );
    
    setState(() => _isControlling = false);
    
    if (!success && mounted) {
      _showErrorSnackbar('Failed to toggle power');
    }
  }
  
  Future<void> _setSpeed(int value) async {
    setState(() => _isControlling = true);
    
    final success = await context.read<DeviceProvider>().setSpeed(
      widget.device.id,
      value,
    );
    
    setState(() => _isControlling = false);
    
    if (!success && mounted) {
      _showErrorSnackbar('Failed to set speed');
    }
  }
  
  Future<void> _toggleLight(bool value) async {
    setState(() => _isControlling = true);
    
    final success = await context.read<DeviceProvider>().toggleLight(
      widget.device.id,
      value,
    );
    
    setState(() => _isControlling = false);
    
    if (!success && mounted) {
      _showErrorSnackbar('Failed to toggle light');
    }
  }
  
  Future<void> _toggleBreeze(bool value) async {
    setState(() => _isControlling = true);
    
    final success = await context.read<DeviceProvider>().toggleBreeze(
      widget.device.id,
      value,
    );
    
    setState(() => _isControlling = false);
    
    if (!success && mounted) {
      _showErrorSnackbar('Failed to toggle breeze mode');
    }
  }
  
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.name),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: widget.device.isOnline 
                      ? Colors.green.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: widget.device.isOnline 
                            ? Colors.green 
                            : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      widget.device.isOnline ? 'Online' : 'Offline',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: widget.device.isOnline 
                            ? Colors.green 
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<DeviceProvider>(
        builder: (context, deviceProvider, _) {
          final currentDevice = deviceProvider.devices
              .firstWhere((d) => d.id == widget.device.id, orElse: () => widget.device);
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Fan Animation
                FanAnimation(
                  isSpinning: currentDevice.isPowerOn,
                  speed: currentDevice.speed,
                ),
                
                const SizedBox(height: 48),
                
                // Power Control
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.power_settings_new,
                                  color: currentDevice.isPowerOn 
                                      ? Theme.of(context).colorScheme.primary 
                                      : Colors.grey,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Power',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                            Switch(
                              value: currentDevice.isPowerOn,
                              onChanged: currentDevice.isOnline 
                                  ? _togglePower 
                                  : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Speed Control
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.speed),
                            const SizedBox(width: 12),
                            Text(
                              'Speed',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${currentDevice.speed}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SpeedSlider(
                          value: currentDevice.speed,
                          onChanged: currentDevice.isOnline && currentDevice.isPowerOn 
                              ? (value) => _setSpeed(value.round())
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Light Control
                ControlToggle(
                  icon: Icons.light_mode,
                  title: 'Light',
                  value: currentDevice.isLightOn,
                  onChanged: currentDevice.isOnline 
                      ? _toggleLight 
                      : null,
                ),
                
                const SizedBox(height: 16),
                
                // Breeze Mode Control
                ControlToggle(
                  icon: Icons.air,
                  title: 'Breeze Mode',
                  subtitle: 'Natural wind simulation',
                  value: currentDevice.isBreezeMode,
                  onChanged: currentDevice.isOnline && currentDevice.isPowerOn 
                      ? _toggleBreeze 
                      : null,
                ),
                
                const SizedBox(height: 24),
                
                // Device Info Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Device Information',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow('Device ID', currentDevice.id),
                        _buildInfoRow('Type', currentDevice.type.toUpperCase()),
                        _buildInfoRow(
                          'Last Updated',
                          currentDevice.lastUpdated != null 
                              ? _formatDateTime(currentDevice.lastUpdated!)
                              : 'N/A',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
  
  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}