import 'package:equatable/equatable.dart';
import '../../domain/entities/device_entity.dart';

class DeviceModel extends Equatable {
  final String id;
  final String name;
  final String type;
  final bool isOnline;
  final bool isPowerOn;
  final int speed;
  final bool isBreezeMode;
  final bool isLightOn;
  final DateTime? lastUpdated;
  
  const DeviceModel({
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
  
  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'] ?? json['deviceId'] ?? '',
      name: json['name'] ?? 'Unknown Device',
      type: json['type'] ?? 'fan',
      isOnline: json['isOnline'] ?? json['online'] ?? false,
      isPowerOn: json['isPowerOn'] ?? json['power'] ?? false,
      speed: json['speed'] ?? 1,
      isBreezeMode: json['isBreezeMode'] ?? json['breeze'] ?? false,
      isLightOn: json['isLightOn'] ?? json['light'] ?? false,
      lastUpdated: json['lastUpdated'] != null 
          ? DateTime.parse(json['lastUpdated']) 
          : DateTime.now(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'isOnline': isOnline,
      'isPowerOn': isPowerOn,
      'speed': speed,
      'isBreezeMode': isBreezeMode,
      'isLightOn': isLightOn,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }
  
  DeviceEntity toEntity() {
    return DeviceEntity(
      id: id,
      name: name,
      type: type,
      isOnline: isOnline,
      isPowerOn: isPowerOn,
      speed: speed,
      isBreezeMode: isBreezeMode,
      isLightOn: isLightOn,
      lastUpdated: lastUpdated,
    );
  }
  
  factory DeviceModel.fromEntity(DeviceEntity entity) {
    return DeviceModel(
      id: entity.id,
      name: entity.name,
      type: entity.type,
      isOnline: entity.isOnline,
      isPowerOn: entity.isPowerOn,
      speed: entity.speed,
      isBreezeMode: entity.isBreezeMode,
      isLightOn: entity.isLightOn,
      lastUpdated: entity.lastUpdated,
    );
  }
  
  @override
  List<Object?> get props => [
    id, name, type, isOnline, isPowerOn, 
    speed, isBreezeMode, isLightOn, lastUpdated
  ];
}