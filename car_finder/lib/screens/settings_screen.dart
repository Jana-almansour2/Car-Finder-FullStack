import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart'; // Use local import
import '../core/providers/settings_providers.dart';
import '../features/location/presentation/location_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(darkModeProvider);
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
              localizations.settings,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white),
            ),
            Text(
              localizations.appearance,
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader(localizations.appearance, isDarkMode),
          _buildSettingCard(
            isDarkMode,
            child: SwitchListTile(
              title: Text(
                localizations.darkMode,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              subtitle: Text(
                localizations.enableDark,
                style: TextStyle(
                  color: isDarkMode ? Colors.white60 : Colors.grey[600],
                ),
              ),
              secondary: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.dark_mode, color: Colors.orange),
              ),
              value: isDarkMode,
              onChanged: (value) =>
                  ref.read(darkModeProvider.notifier).toggleDarkMode(value),
              activeColor: const Color(0xFF007AFF),
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingCard(
            isDarkMode,
            child: ListTile(
              title: Text(
                localizations.language,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              subtitle: Text(
                localizations.appLanguage,
                style: TextStyle(
                  color: isDarkMode ? Colors.white60 : Colors.grey[600],
                ),
              ),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.language, color: Colors.blue),
              ),
              trailing: DropdownButton<String>(
                value: language,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(value: 'en', child: Text('English')),
                  DropdownMenuItem(value: 'ar', child: Text('العربية')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    ref.read(languageProvider.notifier).setLanguage(value);
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(localizations.data, isDarkMode),
          _buildSettingCard(
            isDarkMode,
            child: ListTile(
              title: Text(
                localizations.clearAll,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              subtitle: Text(
                localizations.clearDesc,
                style: TextStyle(
                  color: isDarkMode ? Colors.white60 : Colors.grey[600],
                ),
              ),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.delete_forever, color: Colors.red),
              ),
              onTap: () => _showClearDataDialog(context, ref, localizations),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(localizations.about, isDarkMode),
          _buildSettingCard(
            isDarkMode,
            child: Column(
              children: [
                _buildAboutItem(
                  context,
                  ref,
                  localizations.terms,
                  Icons.description_outlined,
                  Colors.purple,
                  isDarkMode,
                  localizations,
                ),
                const Divider(height: 1),
                _buildAboutItem(
                  context,
                  ref,
                  localizations.privacy,
                  Icons.privacy_tip_outlined,
                  Colors.teal,
                  isDarkMode,
                  localizations,
                ),
                const Divider(height: 1),
                ListTile(
                  title: Text(
                    localizations.version,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  trailing: const Text(
                    '1.0.0',
                    style: TextStyle(color: Colors.grey),
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.info_outline, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8, right: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white38 : Colors.grey[600],
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingCard(bool isDarkMode, {required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: child,
    );
  }

  Widget _buildAboutItem(
      BuildContext context,
      WidgetRef ref,
      String title,
      IconData icon,
      Color color,
      bool isDarkMode,
      AppLocalizations localizations) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: Text(title == localizations.terms
                  ? localizations.termsContent
                  : localizations.privacyContent),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(localizations.close),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showClearDataDialog(
      BuildContext context, WidgetRef ref, AppLocalizations localizations) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.clearAllData),
        content: Text(localizations.clearConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.cancel),
          ),
          TextButton(
            onPressed: () {
              ref.read(locationActionProvider.notifier).clearAll();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(localizations.clearSuccess)),
              );
            },
            child: Text(
              localizations.clear,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
