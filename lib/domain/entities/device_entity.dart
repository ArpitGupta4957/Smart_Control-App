import 'package:equatable/equatable.dart';

class DeviceEntity extends Equatable {
  final String id;
  final String name;
  final String type;
  final bool isOnline;
  final bool isPowerOn;
  final int speed;
  final bool isBreezeMode;
  final bool isLightOn;
  final DateTime? lastUpdated;
  
  const DeviceEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.isOnline,
    required this.isPowerOn,
    required this.speed,
    required this.isBreezeMode,
    required this.isLightOn,
    this.lastUpdated,
  });
  
  DeviceEntity copyWith({
    String? id,
    String? name,
    String? type,
    bool? isOnline,
    bool? isPowerOn,
    int? speed,
    bool? isBreezeMode,
    bool? isLightOn,
    DateTime? lastUpdated,
  }) {
    return DeviceEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      isOnline: isOnline ?? this.isOnline,
      isPowerOn: isPowerOn ?? this.isPowerOn,
      speed: speed ?? this.speed,
      isBreezeMode: isBreezeMode ?? this.isBreezeMode,
      isLightOn: isLightOn ?? this.isLightOn,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
  
  @override
  List<Object?> get props => [
    id, name, type, isOnline, isPowerOn, 
    speed, isBreezeMode, isLightOn, lastUpdated
  ];
}