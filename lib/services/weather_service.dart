import 'dart:async';
import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService
{
  static const BASE_URL= 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {

    final response = await http.get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

  if (response.statusCode == 200)
    {
      return Weather.fromJson(jsonDecode(response.body));
    }
  else
    {
      throw Exception('Failed to load Weather data');
    }
  }

  Future<String> getCurrentCity() async
  {
    // Get Permission From User
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied)
      {
        permission = await Geolocator.requestPermission();
      }

    // Fetch Current Location
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    // Convert the Location into a List of placemark Objects
    List<Placemark> placemark = await placemarkFromCoordinates(position.latitude, position.longitude);

    // Extract the City Name from the First Placemark
    String? city = placemark[0].locality;

    return city ?? "";
  }
}