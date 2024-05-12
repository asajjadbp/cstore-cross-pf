import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<Map<String, dynamic>> getLocation() async {
    bool serviceEnable = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnable) {
      Map<String, dynamic> myMap = {
        "locationIsPicked": false,
        "lat": "",
        "long": "",
        "msg": "Please enable your device location"
      };
      return myMap;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Map<String, dynamic> myMap = {
          "locationIsPicked": false,
          "lat": "",
          "long": "",
          "msg": "Please allow your device location"
        };
        return myMap;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Map<String, dynamic> myMap = {
        "locationIsPicked": false,
        "lat": "",
        "long": "",
        "msg": "Please allow your device location"
      };
      return myMap;
    }
    var u = await Geolocator.getCurrentPosition();

    Map<String, dynamic> myMap = {
      "locationIsPicked": true,
      "lat": u.latitude.toString(),
      "long": u.longitude.toString(),
      "msg": "Location access successfully"
    };
    return myMap;
  }
}
