import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../core/providers/settings_providers.dart';
import '../features/location/presentation/location_providers.dart';
import '../features/weather/weather_service.dart';
import '../models/saved_location.dart';

class AddNoteScreen extends ConsumerStatefulWidget {
  final SavedLocation location;
  const AddNoteScreen({super.key, required this.location});

  @override
  ConsumerState<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends ConsumerState<AddNoteScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.location.note ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final language = ref.watch(languageProvider);
    final weatherAsync = ref.watch(weatherProvider(
        (lat: widget.location.latitude, lon: widget.location.longitude)));

    String translate(String key, String fallback) {
      if (language == 'ar') {
        switch (key) {
          case 'add_note':
            return 'إضافة ملاحظة';
          case 'add_note_desc':
            return 'أضف تفاصيل حول موقع سيارتك';
          case 'saved_location':
            return 'الموقع المحفوظ';
          case 'your_note':
            return 'ملاحظتك';
          case 'hint_note':
            return 'مثلاً: موقف B، بجانب المدخل...';
          case 'skip':
            return 'تخطي';
          case 'save_note':
            return 'حفظ الملاحظة';
          case 'note_saved':
            return 'تم حفظ الملاحظة!';
          default:
            return fallback;
        }
      } else {
        switch (key) {
          case 'add_note':
            return 'Add Note';
          case 'add_note_desc':
            return 'Add details about your parking spot';
          case 'saved_location':
            return 'Saved Location';
          case 'your_note':
            return 'Your Note';
          case 'hint_note':
            return 'e.g. Level 2, near Pillar B4...';
          case 'skip':
            return 'Skip';
          case 'save_note':
            return 'Save Note';
          case 'note_saved':
            return 'Note saved!';
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
              translate('add_note', 'Add Note'),
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white),
            ),
            Text(
              translate('add_note_desc', 'Add details about your parking spot'),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
                  Text(
                    translate('saved_location', 'Saved Location'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        '${DateFormat('MMM d, h:mm a', language).format(widget.location.savedAt)}',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white60 : Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '•',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white38 : Colors.grey[400],
                        ),
                      ),
                      const SizedBox(width: 8),
                      weatherAsync.when(
                        data: (weather) => weather != null
                            ? Text(
                                '${WeatherService.getWeatherEmoji(weather['icon'])} ${weather['temp'].round()}°C',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode
                                      ? Colors.white70
                                      : Colors.grey[800],
                                ),
                              )
                            : const SizedBox.shrink(),
                        loading: () => const SizedBox.shrink(),
                        error: (err, stack) => const SizedBox.shrink(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: Color(0xFF007AFF)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.location.address,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Note Section
            Text(
              translate('your_note', 'Your Note'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(16),
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
              child: TextField(
                controller: _controller,
                maxLines: 8,
                minLines: 5,
                decoration: InputDecoration(
                  hintText:
                      translate('hint_note', 'e.g. Level 2, near Pillar B4...'),
                  hintStyle: TextStyle(
                      color: isDarkMode ? Colors.white54 : Colors.grey[500]),
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey,
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(translate('skip', 'Skip')),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(locationActionProvider.notifier).updateNote(
                              widget.location,
                              _controller.text,
                            );
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text(translate('note_saved', 'Note saved!'))),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007AFF),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(translate('save_note', 'Save Note')),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
