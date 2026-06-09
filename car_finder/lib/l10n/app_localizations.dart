import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Car Finder'**
  String get appTitle;

  /// No description provided for @saveLocation.
  ///
  /// In en, this message translates to:
  /// **'Save Car Location'**
  String get saveLocation;

  /// No description provided for @savedLocation.
  ///
  /// In en, this message translates to:
  /// **'Saved Location'**
  String get savedLocation;

  /// No description provided for @noLocation.
  ///
  /// In en, this message translates to:
  /// **'No Location Saved'**
  String get noLocation;

  /// No description provided for @pressToSave.
  ///
  /// In en, this message translates to:
  /// **'Press the button above to save your car location'**
  String get pressToSave;

  /// No description provided for @myCar.
  ///
  /// In en, this message translates to:
  /// **'My Car'**
  String get myCar;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @calculating.
  ///
  /// In en, this message translates to:
  /// **'Calculating...'**
  String get calculating;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @walkingTime.
  ///
  /// In en, this message translates to:
  /// **'Walking Time'**
  String get walkingTime;

  /// No description provided for @walk.
  ///
  /// In en, this message translates to:
  /// **'walk'**
  String get walk;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No History Yet'**
  String get noHistory;

  /// No description provided for @historyDesc.
  ///
  /// In en, this message translates to:
  /// **'Your saved locations will appear here'**
  String get historyDesc;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'APPEARANCE'**
  String get appearance;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @enableDark.
  ///
  /// In en, this message translates to:
  /// **'Enable dark theme'**
  String get enableDark;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get appLanguage;

  /// No description provided for @data.
  ///
  /// In en, this message translates to:
  /// **'DATA'**
  String get data;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All Data'**
  String get clearAll;

  /// No description provided for @clearDesc.
  ///
  /// In en, this message translates to:
  /// **'Delete all saved locations'**
  String get clearDesc;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'ABOUT'**
  String get about;

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get terms;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @clearAllData.
  ///
  /// In en, this message translates to:
  /// **'Clear All Data'**
  String get clearAllData;

  /// No description provided for @clearConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all saved locations and notes? This action cannot be undone.'**
  String get clearConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @clearSuccess.
  ///
  /// In en, this message translates to:
  /// **'All data cleared'**
  String get clearSuccess;

  /// No description provided for @termsContent.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Car Finder.\n\nBy using this application, you agree to the following terms:\n\n- The app is provided to help you save and track your parked car location.\n- You are responsible for how you use the app and any data you store.\n- We do not guarantee 100% accuracy of location services at all times.\n- The app should not be relied on for critical navigation or emergency use.\n- We reserve the right to update or improve the app at any time.\n\nBy continuing to use Car Finder, you agree to these terms.'**
  String get termsContent;

  /// No description provided for @privacyContent.
  ///
  /// In en, this message translates to:
  /// **'Your privacy is important to us.\n\n- Car Finder may access your device location to save your parked car position.\n- Your saved locations are stored locally on your device and are not shared with any third parties.\n- We do not collect personal data such as your name, email, or contacts.\n- Location data is only used to provide app functionality.\n- You can delete your data at any time from the app settings.\n\nBy using this app, you agree to this privacy policy.'**
  String get privacyContent;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add Note'**
  String get addNote;

  /// No description provided for @hintNote.
  ///
  /// In en, this message translates to:
  /// **'e.g., Parking lot B, near entrance...'**
  String get hintNote;

  /// No description provided for @saveNote.
  ///
  /// In en, this message translates to:
  /// **'Save Note'**
  String get saveNote;

  /// No description provided for @noteSaved.
  ///
  /// In en, this message translates to:
  /// **'Note saved!'**
  String get noteSaved;

  /// No description provided for @carDetails.
  ///
  /// In en, this message translates to:
  /// **'Car Details'**
  String get carDetails;

  /// No description provided for @savedTodayAt.
  ///
  /// In en, this message translates to:
  /// **'Saved today at'**
  String get savedTodayAt;

  /// No description provided for @currentCar.
  ///
  /// In en, this message translates to:
  /// **'Current Car'**
  String get currentCar;

  /// No description provided for @yourNote.
  ///
  /// In en, this message translates to:
  /// **'Your Note'**
  String get yourNote;

  /// No description provided for @noNote.
  ///
  /// In en, this message translates to:
  /// **'No note added'**
  String get noNote;

  /// No description provided for @navigationInfo.
  ///
  /// In en, this message translates to:
  /// **'Navigation Info'**
  String get navigationInfo;

  /// No description provided for @approx.
  ///
  /// In en, this message translates to:
  /// **'Approximately'**
  String get approx;

  /// No description provided for @weather.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get weather;

  /// No description provided for @noWeatherInfo.
  ///
  /// In en, this message translates to:
  /// **'No weather info available'**
  String get noWeatherInfo;

  /// No description provided for @loadingWeather.
  ///
  /// In en, this message translates to:
  /// **'Loading weather...'**
  String get loadingWeather;

  /// No description provided for @weatherError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load weather'**
  String get weatherError;

  /// No description provided for @navigateToCar.
  ///
  /// In en, this message translates to:
  /// **'Navigate to Car'**
  String get navigateToCar;

  /// No description provided for @deleteLocation.
  ///
  /// In en, this message translates to:
  /// **'Delete Location'**
  String get deleteLocation;

  /// No description provided for @deleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this location?'**
  String get deleteConfirm;

  /// No description provided for @locationDeleted.
  ///
  /// In en, this message translates to:
  /// **'Location deleted'**
  String get locationDeleted;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
