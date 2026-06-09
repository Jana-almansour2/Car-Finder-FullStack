import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import '../../core/network/api_client.dart';

class WeatherService {

  static final ApiClient _apiClient = ApiClient();

  static String get _apiKey => dotenv.env['WEATHER_API_KEY'] ?? '';
  static const String _baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  static Future<Map<String, dynamic>?> getCurrentWeather(
      double lat, double lon) async {
    if (_apiKey.isEmpty) {
      print('Weather API Key is missing in .env file.');
      return null;
    }

    final response = await _apiClient.get(
      _baseUrl,
      queryParameters: {
        'lat': lat,
        'lon': lon,
        'appid': _apiKey,
        'units': 'metric',
      },
    );

    if (response != null && response.statusCode == 200) {
      final data = response.data;
      return {
        'temp': (data['main']['temp'] as num).toDouble(),
        'condition': data['weather'][0]['main'] as String,
        'icon': data['weather'][0]['icon'] as String,
      };
    }

    return null;
  }

  static String getWeatherEmoji(String? iconCode) {
    if (iconCode == null) return '🌡️';

    switch (iconCode) {
      case '01d':
        return '☀️';
      case '01n':
        return '🌙';
      case '02d':
      case '02n':
        return '⛅️';
      case '03d':
      case '03n':
        return '☁️';
      case '04d':
      case '04n':
        return '☁️';
      case '09d':
      case '09n':
        return '🌧️';
      case '10d':
      case '10n':
        return '🌦️';
      case '11d':
      case '11n':
        return '⛈️';
      case '13d':
      case '13n':
        return '❄️';
      case '50d':
      case '50n':
        return '🌫️';
      default:
        return '🌡️';
    }
  }
}

final weatherProvider =
    FutureProvider.family<Map<String, dynamic>?, ({double lat, double lon})>(
        (ref, pos) async {
  return WeatherService.getCurrentWeather(pos.lat, pos.lon);
});
