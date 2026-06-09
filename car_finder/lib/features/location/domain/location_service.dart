import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

class LocationService {
  static Future<bool> requestLocationPermission() async {
    final permission = await Geolocator.requestPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  static Future<Position?> getCurrentLocation() async {
    try {
      // Check if location service is enabled
      final isEnabled = await isLocationServiceEnabled();
      if (!isEnabled) {
        print('â‌Œ Location services are disabled');
        return null;
      }

      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final granted = await requestLocationPermission();
        if (!granted) {
          print('â‌Œ Location permission denied');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('â‌Œ Location permission denied forever');
        await Geolocator.openLocationSettings();
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: const Duration(seconds: 10),
      );

      print(
          'âœ… Got real GPS location: ${position.latitude}, ${position.longitude}');
      return position;
    } catch (e) {
      print('â‌Œ Error getting location: $e');
      return null;
    }
  }

  /// Convert coordinates to human-readable address
  static Future<String> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final address = [
          place.street,
          place.locality,
          place.administrativeArea,
          place.country,
        ].where((e) => e != null && e.isNotEmpty).join(', ');

        print('âœ… Address: $address');
        return address.isNotEmpty ? address : 'Unknown Location';
      }
      return 'Unknown Location';
    } catch (e) {
      print('â‌Œ Error getting address: $e');
      return 'Unknown Location';
    }
  }

  /// Calculate distance between two coordinates using Haversine formula
  /// Returns distance in meters
  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadiusMeters = 6371000; // Earth's radius in meters

    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    final distance = earthRadiusMeters * c;

    print('ًں“چ Distance calculated: ${distance.toStringAsFixed(0)}m');
    return distance;
  }

  /// Convert degrees to radians
  static double _toRadians(double degrees) {
    return degrees * math.pi / 180;
  }

  /// Format distance for display
  static String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.toStringAsFixed(0)} m';
    } else {
      final km = meters / 1000;
      return '${km.toStringAsFixed(1)} km';
    }
  }

  /// Get estimated walking time in minutes
  static int getEstimatedWalkingTime(double meters) {
    // Average walking speed: 1.4 m/s (5 km/h)
    const avgWalkingSpeed = 1.4;
    final seconds = meters / avgWalkingSpeed;
    return (seconds / 60).ceil();
  }

  /// Open Google Maps with directions to the saved car location
  /// Uses direct coordinates URL to avoid login requirements
  static Future<void> openMapsNavigation(
    double latitude,
    double longitude,
    String label,
  ) async {
    try {
      // Create Google Maps URL with exact coordinates (no login required)
      final String googleMapsUrl =
          'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude&travelmode=walking';

      // Try to launch the URL
      final Uri uri = Uri.parse(googleMapsUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        print('âœ… Opened Google Maps with coordinates: $latitude, $longitude');
      } else {
        print('â‌Œ Could not launch Google Maps');
      }
    } catch (e) {
      print('â‌Œ Error opening maps: $e');
    }
  }
}
