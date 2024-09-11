import 'dart:math' show cos, sqrt, asin;

double calculateDistance(startLat, startLong, storeLat, storeLong) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 - c((storeLat - startLat) * p)/2 +
      c(startLat * p) * c(storeLat * p) *
          (1 - c((storeLong - startLong) * p))/2;
  return 12742 * asin(sqrt(a));
}