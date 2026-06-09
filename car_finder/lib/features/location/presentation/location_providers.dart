import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import '../../../models/saved_location.dart';
import '../data/location_repository.dart';
import '../domain/location_service.dart';

final savedLocationsBoxProvider = Provider<Box<SavedLocation>>((ref) {
  return Hive.box<SavedLocation>('saved_locations');
});

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  final box = ref.watch(savedLocationsBoxProvider);
  return LocationRepository(box);
});

final allSavedLocationsProvider = StateProvider<List<SavedLocation>>((ref) {
  return ref.watch(locationRepositoryProvider).getAllLocations();
});

final currentCarLocationProvider = StateProvider<SavedLocation?>((ref) {
  final locations = ref.watch(allSavedLocationsProvider);
  return locations.isEmpty ? null : locations.first;
});

final userLocationProvider = StreamProvider<Position?>((ref) {
  return Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high, distanceFilter: 5),
  );
});

final distanceProvider =
    Provider.family<String, SavedLocation>((ref, location) {
  final userLocation = ref.watch(userLocationProvider).value;
  if (userLocation == null) return '--';
  final distanceInMeters = LocationService.calculateDistance(
    userLocation.latitude,
    userLocation.longitude,
    location.latitude,
    location.longitude,
  );
  return LocationService.formatDistance(distanceInMeters);
});

final walkingTimeProvider =
    Provider.family<String, SavedLocation>((ref, location) {
  final userLocation = ref.watch(userLocationProvider).value;
  if (userLocation == null) return '--';
  final distanceInMeters = LocationService.calculateDistance(
    userLocation.latitude,
    userLocation.longitude,
    location.latitude,
    location.longitude,
  );
  final walkingTimeInMinutes =
      LocationService.getEstimatedWalkingTime(distanceInMeters);
  return '$walkingTimeInMinutes min';
});

final locationSavingProvider = StateNotifierProvider<LocationSavingNotifier,
    ({bool isLoading, String? error})>((ref) {
  return LocationSavingNotifier(ref.watch(locationRepositoryProvider), ref);
});

class LocationSavingNotifier
    extends StateNotifier<({bool isLoading, String? error})> {
  final LocationRepository _repository;
  final Ref _ref;
  LocationSavingNotifier(this._repository, this._ref)
      : super((isLoading: false, error: null));

  Future<SavedLocation?> saveLocation() async {
    state = (isLoading: true, error: null);
    final location = await _repository.captureAndSaveLocation();

    if (location != null) {
      try {
        final dio = Dio();
        await dio.post(
          'http://10.0.2.2:5000/save-location',
          data: location.toJson(),
        );
        print('Backup sent to server successfully');
      } catch (e) {
        print('Failed to send backup to server: $e');
      }

      _ref.read(allSavedLocationsProvider.notifier).state =
          _repository.getAllLocations();
      _ref.read(currentCarLocationProvider.notifier).state = location;
      state = (isLoading: false, error: null);
      return location;
    } else {
      state = (isLoading: false, error: 'Failed to save location');
      return null;
    }
  }
}

final locationActionProvider =
    StateNotifierProvider<LocationActionNotifier, void>((ref) {
  return LocationActionNotifier(ref.watch(locationRepositoryProvider), ref);
});

class LocationActionNotifier extends StateNotifier<void> {
  final LocationRepository _repository;
  final Ref _ref;
  LocationActionNotifier(this._repository, this._ref) : super(null);

  Future<void> deleteLocation(String id) async {
    await _repository.deleteLocation(id);
    _ref.read(allSavedLocationsProvider.notifier).state =
        _repository.getAllLocations();
    final current = _ref.read(currentCarLocationProvider);
    if (current?.id == id) {
      final locations = _repository.getAllLocations();
      _ref.read(currentCarLocationProvider.notifier).state =
          locations.isEmpty ? null : locations.first;
    }
  }

  Future<void> clearAll() async {
    await _repository.clearAll();
    _ref.read(allSavedLocationsProvider.notifier).state = [];
    _ref.read(currentCarLocationProvider.notifier).state = null;
  }

  Future<void> updateNote(SavedLocation location, String note) async {
    final box = _ref.read(savedLocationsBoxProvider);
    final updated = location.copyWith(note: note);
    final dynamic key = box.keys
        .firstWhere((k) => box.get(k)?.id == location.id, orElse: () => null);
    if (key != null) {
      await box.put(key, updated);
      _ref.read(allSavedLocationsProvider.notifier).state =
          _repository.getAllLocations();
      final current = _ref.read(currentCarLocationProvider);
      if (current?.id == location.id) {
        _ref.read(currentCarLocationProvider.notifier).state = updated;
      }
    }
  }
}
