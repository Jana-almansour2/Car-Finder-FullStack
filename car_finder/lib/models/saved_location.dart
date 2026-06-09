import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'saved_location.g.dart';

@HiveType(typeId: 0)
class SavedLocation extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double latitude;

  @HiveField(2)
  final double longitude;

  @HiveField(3)
  final String address;

  @HiveField(4)
  String? note;

  @HiveField(5)
  final DateTime savedAt;

  @HiveField(6)
  final double? temperature;

  @HiveField(7)
  final String? weatherCondition;

  @HiveField(8)
  final String? weatherIcon;

  SavedLocation({
    String? id,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.note,
    DateTime? savedAt,
    this.temperature,
    this.weatherCondition,
    this.weatherIcon,
  })  : id = id ?? const Uuid().v4(),
        savedAt = savedAt ?? DateTime.now();

  // Manual toJson method to support Backend communication
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'note': note,
      'savedAt': savedAt.toIso8601String(),
      'temperature': temperature,
      'weatherCondition': weatherCondition,
      'weatherIcon': weatherIcon,
    };
  }

  SavedLocation copyWith({
    String? id,
    double? latitude,
    double? longitude,
    String? address,
    String? note,
    DateTime? savedAt,
    double? temperature,
    String? weatherCondition,
    String? weatherIcon,
  }) {
    return SavedLocation(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      note: note ?? this.note,
      savedAt: savedAt ?? this.savedAt,
      temperature: temperature ?? this.temperature,
      weatherCondition: weatherCondition ?? this.weatherCondition,
      weatherIcon: weatherIcon ?? this.weatherIcon,
    );
  }

  @override
  String toString() {
    return 'SavedLocation(id: $id, latitude: $latitude, longitude: $longitude, address: $address, note: $note, savedAt: $savedAt, temp: $temperature, condition: $weatherCondition)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedLocation &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          address == other.address &&
          note == other.note &&
          savedAt == other.savedAt &&
          temperature == other.temperature &&
          weatherCondition == other.weatherCondition &&
          weatherIcon == other.weatherIcon;

  @override
  int get hashCode =>
      id.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      address.hashCode ^
      note.hashCode ^
      savedAt.hashCode ^
      temperature.hashCode ^
      weatherCondition.hashCode ^
      weatherIcon.hashCode;
}
