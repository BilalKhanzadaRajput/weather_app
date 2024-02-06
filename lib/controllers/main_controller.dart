import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/services/api_services.dart';
import 'package:geolocator/geolocator.dart';

class MainController extends GetxController {
  @override
  void onInit() {
    getUserLocation();
    currentWeatherData = getCurrentWeather();
    hourlyWeatherData = getHourlyWeather();
    super.onInit();
  }

  var isDark = false.obs;
  var currentWeatherData;
  var hourlyWeatherData;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;

  getUserLocation() async {
    try {
      var isLocationEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isLocationEnabled) {
        throw Exception("Location service is not enabled");
      }

      var userPermission = await Geolocator.checkPermission();
      if (userPermission == LocationPermission.deniedForever) {
        throw Exception("Location permission is denied forever");
      } else if (userPermission == LocationPermission.denied) {
        userPermission = await Geolocator.requestPermission();
        if (userPermission == LocationPermission.denied) {
          throw Exception("Location permission is denied");
        }
      }

      var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitude.value = position.latitude;
      longitude.value = position.longitude;

      print("Latitude: ${latitude.value}, Longitude: ${longitude.value}");
    } catch (error) {
      print("Error getting user location: $error");
      // Handle error as necessary, for example:
      // showSnackbar("Error getting user location: $error");
    }
  }


  changeTheme() {
    isDark.value = !isDark.value;
    Get.changeThemeMode(isDark.value ? ThemeMode.dark : ThemeMode.light);
  }
}
