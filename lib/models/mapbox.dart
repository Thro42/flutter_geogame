import 'package:mapbox_gl/mapbox_gl.dart';

class MapboxOptions {
  MapboxMapController mapController;
  CameraPosition position;
  bool compassEnabled = true;
  CameraTargetBounds cameraTargetBounds = CameraTargetBounds.unbounded;
  MinMaxZoomPreference minMaxZoomPreference = MinMaxZoomPreference.unbounded;
  String styleString = MapboxStyles.MAPBOX_STREETS;
  bool rotateGesturesEnabled = true;
  bool scrollGesturesEnabled = true;
  bool tiltGesturesEnabled = true;
  bool zoomGesturesEnabled = true;
  bool myLocationEnabled = true;
  MyLocationTrackingMode myLocationTrackingMode =
      MyLocationTrackingMode.Tracking;

  MapboxOptions(this.position, this.myLocationTrackingMode, this.styleString);

  String toString() {
    var posLat = position.target.latitude;
    var posLon = position.target.longitude;
    return 'MapboxOptions{position: $posLat, $posLon}';
  }
}
