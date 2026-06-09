import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../core/providers/settings_providers.dart';
import '../features/location/presentation/location_providers.dart';
import '../features/weather/weather_service.dart';
import '../models/saved_location.dart';
import 'car_details_screen.dart';
import 'add_note_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedLocation = ref.watch(currentCarLocationProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final language = ref.watch(languageProvider);
    final localizations = AppLocalizations.of(context)!;

    String translate(String key, String fallback) {
      if (language == 'ar') {
        switch (key) {
          case 'app_title':
            return 'محدد موقع السيارة';
          case 'save_location':
            return 'حفظ موقع السيارة';
          case 'saved_location':
            return 'الموقع المحفوظ';
          case 'my_car':
            return 'سيارتي';
          case 'today':
            return 'اليوم';
          case 'yesterday':
            return 'أمس';
          case 'view_details':
            return 'عرض التفاصيل';
          case 'no_location':
            return 'لا يوجد موقع محفوظ';
          case 'press_to_save':
            return 'اضغط على الزر أعلاه لحفظ موقع سيارتك';
          default:
            return fallback;
        }
      } else {
        switch (key) {
          case 'app_title':
            return 'Car Finder';
          case 'save_location':
            return 'Save Location';
          case 'saved_location':
            return 'Saved Location';
          case 'my_car':
            return 'My Car';
          case 'today':
            return 'Today';
          case 'yesterday':
            return 'Yesterday';
          case 'view_details':
            return 'View Details';
          case 'no_location':
            return 'No Location Saved';
          case 'press_to_save':
            return 'Press the button above to save your car\'s location';
          default:
            return fallback;
        }
      }
    }

    return Scaffold(
      backgroundColor:
          isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              translate('app_title', 'Car Finder'),
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white),
            ),
            Text(
              DateFormat('EEEE, d MMMM', language).format(DateTime.now()),
              style:
                  TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8)),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF007AFF),
        foregroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 65,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final location = await ref
                      .read(locationSavingProvider.notifier)
                      .saveLocation();
                  if (context.mounted && location != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddNoteScreen(location: location),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.directions_car, size: 28),
                label: Text(
                  translate('save_location', 'Save Location'),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007AFF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              translate('saved_location', 'Saved Location'),
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87),
            ),
            const SizedBox(height: 16),
            if (savedLocation != null)
              _buildLocationCard(
                  context, ref, savedLocation, isDarkMode, language, translate)
            else
              _buildEmptyState(isDarkMode, translate),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime,
      String Function(String, String) translate, String language) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final dateToCheck = DateTime(dateTime.year, dateTime.month, dateTime.day);

    String datePart;
    if (dateToCheck == today) {
      datePart = translate('today', 'Today');
    } else if (dateToCheck == yesterday) {
      datePart = translate('yesterday', 'Yesterday');
    } else {
      datePart = DateFormat('MMM d', language).format(dateTime);
    }

    return '$datePart ${DateFormat('h:mm a', language).format(dateTime)}';
  }

  Widget _buildLocationCard(
      BuildContext context,
      WidgetRef ref,
      SavedLocation location,
      bool isDarkMode,
      String lang,
      String Function(String, String) translate) {
    final distance = ref.watch(distanceProvider(location));
    final weatherAsync = ref.watch(
        weatherProvider((lat: location.latitude, lon: location.longitude)));

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10))
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFF007AFF), Color(0xFF00C6FF)]),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.directions_car,
                    color: Colors.white, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(translate('my_car', 'My Car'),
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black)),
                    Text(_formatDateTime(location.savedAt, translate, lang),
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 13)),
                    const SizedBox(height: 4),
                    weatherAsync.when(
                      data: (weather) => weather != null
                          ? Row(
                              children: [
                                Text(
                                  WeatherService.getWeatherEmoji(
                                      weather['icon']),
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${weather['temp'].round()}°C',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode
                                        ? Colors.white70
                                        : Colors.grey[800],
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                      loading: () => const SizedBox.shrink(),
                      error: (err, stack) => const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF007AFF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  distance,
                  style: const TextStyle(
                    color: Color(0xFF007AFF),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Color(0xFF007AFF)),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  location.address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white70 : Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
          if (location.note != null && location.note!.isNotEmpty) ...[
            const SizedBox(height: 15),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? const Color(0xFFFFD600).withOpacity(0.1)
                    : const Color(0xFFFFF9C4).withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: const Color(0xFFFBC02D).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.note_alt_outlined,
                      size: 18, color: Color(0xFFF57F17)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      location.note!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode
                            ? const Color(0xFFFFD600)
                            : const Color(0xFF5D4037),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CarDetailsScreen(location: location))),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007AFF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              child: Text(translate('view_details', 'View Details'),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
      bool isDarkMode, String Function(String, String) translate) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(Icons.location_off_outlined,
              size: 80, color: isDarkMode ? Colors.white24 : Colors.grey[300]),
          const SizedBox(height: 16),
          Text(translate('no_location', 'No Location Saved'),
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
          const SizedBox(height: 8),
          Text(
              translate('press_to_save',
                  'Press the button above to save your car\'s location'),
              style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.white70 : Colors.grey[600])),
        ],
      ),
    );
  }
}
