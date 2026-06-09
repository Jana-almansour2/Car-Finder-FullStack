import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../core/providers/settings_providers.dart';
import '../features/location/presentation/location_providers.dart';
import '../features/location/domain/location_service.dart';
import '../features/weather/weather_service.dart';
import '../models/saved_location.dart';

class CarDetailsScreen extends ConsumerWidget {
  final SavedLocation location;
  const CarDetailsScreen({super.key, required this.location});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final distance = ref.watch(distanceProvider(location));
    final walkingTime = ref.watch(walkingTimeProvider(location));
    final language = ref.watch(languageProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context)!;

    final weatherAsync = ref.watch(
        weatherProvider((lat: location.latitude, lon: location.longitude)));

    return Scaffold(
      backgroundColor:
          isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.carDetails,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white),
            ),
            Text(
              localizations.savedLocation,
              style:
                  TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8)),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF007AFF),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
              language == 'ar'
                  ? Icons.arrow_back_ios_new
                  : Icons.arrow_back_ios,
              color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildInfoCard(
              context,
              ref,
              title: localizations.myCar,
              icon: Icons.directions_car,
              color: const Color(0xFF007AFF),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location.address,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${localizations.savedTodayAt} ${DateFormat('h:mm a', language).format(location.savedAt)}',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white60 : Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _buildInfoCard(
              context,
              ref,
              title: localizations.navigationInfo,
              icon: Icons.navigation,
              color: Colors.green,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat(Icons.straighten, distance, localizations.distance,
                      isDarkMode),
                  _buildStat(Icons.directions_walk, walkingTime,
                      localizations.walkingTime, isDarkMode),
                ],
              ),
            ),
            const SizedBox(height: 20),

            weatherAsync.when(
              data: (weather) {
                if (weather != null) {
                  return _buildInfoCard(
                    context,
                    ref,
                    title: localizations.weather,
                    icon: Icons.wb_sunny,
                    color: Colors.orange,
                    child: Row(
                      children: [
                        Text(
                          WeatherService.getWeatherEmoji(weather['icon']),
                          style: const TextStyle(fontSize: 30),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${weather['temp'].round()}°C',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            Text(
                              weather['condition'] ?? '',
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.white60
                                    : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
              loading: () => const SizedBox.shrink(),
              error: (err, stack) => const SizedBox.shrink(),
            ),

            if (location.note != null && location.note!.isNotEmpty) ...[
              const SizedBox(height: 20),
              _buildInfoCard(
                context,
                ref,
                title: localizations.yourNote,
                icon: Icons.note_alt_outlined,
                color: const Color(0xFFFBC02D),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? const Color(0xFFFFD600).withOpacity(0.1)
                        : const Color(0xFFFFF9C4).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: const Color(0xFFFBC02D).withOpacity(0.3)),
                  ),
                  child: Text(
                    location.note!,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode
                          ? const Color(0xFFFFD600)
                          : const Color(0xFF5D4037),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 32),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () => LocationService.openMapsNavigation(
                        location.latitude,
                        location.longitude,
                        location.address,
                      ),
                      icon: const Icon(Icons.near_me_outlined),
                      label: Text(localizations.navigateToCar),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00C853), // Green
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? const Color(0xFFFF5252).withOpacity(0.15)
                        : const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: Color(0xFFFF5252)),
                    onPressed: () =>
                        _showDeleteConfirm(context, ref, localizations),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }

  Widget _buildStat(
      IconData icon, String value, String label, bool isDarkMode) {
    return Column(
      children: [
        Icon(icon, color: isDarkMode ? Colors.white60 : Colors.grey[600]),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: isDarkMode ? Colors.white54 : Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirm(
      BuildContext context, WidgetRef ref, AppLocalizations localizations) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.deleteLocation),
        content: Text(localizations.deleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.cancel),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(locationActionProvider.notifier)
                  .deleteLocation(location.id);
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(localizations.locationDeleted)),
              );
            },
            child: Text(
              localizations.deleteLocation,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
