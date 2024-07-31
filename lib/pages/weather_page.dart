import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherapp/models/weather_model.dart';
import 'package:weatherapp/services/weather_service.dart';

class WeatherPage extends StatefulWidget
{
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage>
{

  // API KEY
  final _weatherService = WeatherService('82fcd58e4ebc4d9c3986994f5b7b0b96');
  Weather? _weather;

  // Fetch Weather
  _fetchWeather() async
  {
    // Get Current City
    String cityName = await _weatherService.getCurrentCity();

    // Get Weather for the City
    try
        {
          final weather = await _weatherService.getWeather(cityName);
          setState(()
          {
           _weather = weather;
          });
        }
    // Any Errors
    catch (e)
    {
      print (e);
    }
  }

  // Weather animations
  String getWeatherAnimations(String? mainCondition)
  {
    if(mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition)
    {
      case 'Clouds':
      case 'Mist':
      case 'Smoke':
      case 'Haze':
      case 'Dust':
      case 'Fog':
        return 'assets/cloud.json';
      case 'Rain':
      case 'Drizzle':
      case 'Shower Rain':
        return 'assets/rain.json';
      case 'ThunderStrom':
        return 'assets/Thunder.json';
      case 'Clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';

    }

  }


  // init state
  @override
  void initState()
  {
    super.initState();

    // Fetch weather on startup
    _fetchWeather();
  }


  @override
   Widget build(BuildContext context)
  {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // child name
          Text(_weather?.cityName ??  "Loading city.."),
          
          // animation
          Lottie.asset(getWeatherAnimations(_weather?.mainCondition)),

          // Temperature
          Text('${_weather?.temperature.round()}°C'),

          // weather condition
          Text(_weather?.mainCondition ?? '')

        ],
      ),
      ),
    );
  }

}