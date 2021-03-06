import "dart:math";

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:melton_app/util/world_cities.dart';
import 'package:melton_app/constants/constants.dart';

class MapUtil {
  static const MAP_STYLE_PATH = "assets/maps/maps_style.json";
  static const MELTON_WORLD_MAP_PATH =
      "assets/maps/world_map_with_melton_cities.png";

  static const MARKER_ICON_PATH_ANDROID = "assets/maps/marker_icon_106.png";
  static const MARKER_ICON_PATH_IOS = "assets/maps/marker_icon_30.png";

  static final _random = new Random();

  static LatLng getLatLngForCity(String city) {
    if (!WorldCities.WORLD_CITIES.containsKey(city)) {
      return LatLng(12.9876, 77.7334); // whitefield :P
    }
    double lat = WorldCities.WORLD_CITIES[city][0];
    double lng = WorldCities.WORLD_CITIES[city][1];
    return LatLng(lat, lng);
  }

  static LatLng getLatLngForRandomMeltonCity() {
    String randomCity =
        Constants.meltonCities[_random.nextInt(Constants.meltonCities.length)];
    return getLatLngForCity(randomCity);
  }

  static LatLng getLatLngForCityWithRandomization(String city) {
    if (!WorldCities.WORLD_CITIES.containsKey(city)) {
      return LatLng(12.9876, 77.7334); // whitefield :P
    }
    double lat = WorldCities.WORLD_CITIES[city][0] + getRandomDisplacement();
    double lng = WorldCities.WORLD_CITIES[city][1] + getRandomDisplacement();
    return LatLng(lat, lng);
  }

  static double getRandomDisplacement() {
    // to avoid overlapping multiple markers
    // need to figure out clustering
    // no library support in flutter yet, 3rd party libs aren't perfect
    double displacement = _random.nextDouble() / 20;
    if (_random.nextBool()) {
      displacement = displacement * -1;
    }
    return displacement;
  }
}
