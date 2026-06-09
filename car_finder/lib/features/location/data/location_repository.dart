import 'package:hive_flutter/hive_flutter.dart';
import '../../../models/saved_location.dart';
import '../domain/location_service.dart';
import '../../weather/weather_service.dart';

class LocationRepository {
  final Box<SavedLocation> _box;
  LocationRepository(this._box);

  Future<SavedLocation?> captureAndSaveLocation() async {
    try {
      final position = await LocationService.getCurrentLocation();
      if (position == null) return null;

      final results = await Future.wait([
        LocationService.getAddressFromCoordinates(
            position.latitude, position.longitude),
        WeatherService.getCurrentWeather(position.latitude, position.longitude),
      ]);

      final address = results[0] as String;
      final weatherData = results[1] as Map<String, dynamic>?;

      final location = SavedLocation(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
        savedAt: DateTime.now(),
        temperature: weatherData?['temp'],
        weatherCondition: weatherData?['condition'],
        weatherIcon: weatherData?['icon'],
      );

      await _box.add(location);
      return location;
    } catch (e) {
      print('LocationRepository Error: $e');
      return null;
    }
  }

  Future<void> deleteLocation(String id) async {
    final key =
        _box.keys.firstWhere((k) => _box.get(k)?.id == id, orElse: () => null);
    if (key != null) {
      await _box.delete(key);
    }
  }

  Future<void> clearAll() async {
    await _box.clear();
  }

  List<SavedLocation> getAllLocations() {
    return _box.values.toList().reversed.toList();
  }
}
