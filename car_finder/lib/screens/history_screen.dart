import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../core/providers/settings_providers.dart';
import '../features/location/presentation/location_providers.dart';
import '../features/weather/weather_service.dart';
import '../models/saved_location.dart';
import 'car_details_screen.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allLocations = ref.watch(allSavedLocationsProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final language = ref.watch(languageProvider);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor:
          isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.history,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white),
            ),
            Text(
              localizations.historyDesc,
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
      body: allLocations.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_toggle_off_outlined,
                      size: 80,
                      color: isDarkMode ? Colors.white24 : Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(localizations.noHistory,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text(localizations.historyDesc,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          color:
                              isDarkMode ? Colors.white70 : Colors.grey[600])),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: allLocations.length,
              itemBuilder: (context, index) {
                final location = allLocations[index];
                final distance = ref.watch(distanceProvider(location));

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CarDetailsScreen(location: location),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
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
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [
                                  Color(0xFF007AFF),
                                  Color(0xFF00C6FF)
                                ]),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.location_on,
                                  color: Colors.white, size: 24),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    location.address,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    DateFormat('MMM d, h:mm a', language)
                                        .format(location.savedAt),
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  distance,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF007AFF),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Icon(
                                  language == 'ar'
                                      ? Icons.chevron_left
                                      : Icons.chevron_right,
                                  color: Colors.grey[400],
                                  size: 20,
                                ),
                              ],
                            ),
                          ],
                        ),

                        // Golden Note Section
                        if (location.note != null &&
                            location.note!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? const Color(0xFFFFD600).withOpacity(0.1)
                                  : const Color(0xFFFFF9C4).withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color:
                                      const Color(0xFFFBC02D).withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.note_alt_outlined,
                                    size: 16, color: Color(0xFFF57F17)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    location.note!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13,
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
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
