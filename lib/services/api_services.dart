import 'package:http/http.dart' as http;
import 'package:weather_app/models/current_weather_model.dart';
import 'package:weather_app/models/hourly_weather_model.data.dart';

import '../consts/strings.dart';


var link = "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric";
var hourlyLink ="https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric";
getCurrentWeather() async {
  try {
    var res = await http.get(Uri.parse(link));

    if (res.statusCode == 200) {
      var data = currentWeatherDataFromJson(res.body.toString());
      print("Data is received");
      return data;
    } else {
      // Handle non-200 status codes
      print("Failed to fetch data. Status code: ${res.statusCode}");
      return null; // or throw an exception
    }
  } catch (error) {
    // Handle general errors
    print("Error: $error");
    return null; // or throw an exception
  }
}
getHourlyWeather() async {
  try {
    var res = await http.get(Uri.parse(hourlyLink));

    if (res.statusCode == 200) {
      var data = hourlyweatherDataFromJson(res.body.toString());
      print("HourlyData is received");
      return data;
    } else {
      // Handle non-200 status codes
      print("Failed to fetch data. Status code: ${res.statusCode}");
      return null; // or throw an exception
    }
  } catch (error) {
    // Handle general errors
    print("Error: $error");
    return null; // or throw an exception
  }
}
