import 'package:rxdart/rxdart.dart';
import 'bloc_base.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import '../models/mapbox.dart';

class MapboxBloc extends BlocBase {
  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(52.1695972, 7.5475882),
    zoom: 16.0,
  );

  static final MapboxBloc _mapboxBlocSingleton = new MapboxBloc._internal();
  factory MapboxBloc() {
    return _mapboxBlocSingleton;
  }
  MapboxBloc._internal() {
    _mapboxOptions.compassEnabled = true;
    _mapboxOptions.rotateGesturesEnabled = true;
    _mapboxOptions.scrollGesturesEnabled = true;
    _mapboxOptions.tiltGesturesEnabled = true;
    _mapboxOptions.zoomGesturesEnabled = true;
    _mapboxOptions.myLocationEnabled = true;
  }

  MapboxOptions _mapboxOptions = MapboxOptions(_kInitialPosition,
      MyLocationTrackingMode.Tracking, MapboxStyles.MAPBOX_STREETS);

  final _mapboxOptions$ = BehaviorSubject<MapboxOptions>.seeded(MapboxOptions(
      _kInitialPosition,
      MyLocationTrackingMode.Tracking,
      MapboxStyles.MAPBOX_STREETS));

  MapboxOptions get mapboxOptions => _mapboxOptions;

  Stream<MapboxOptions> get mapboxOptions$ => _mapboxOptions$.stream;

  set myTrackingMode(MyLocationTrackingMode mode) {
    _mapboxOptions.myLocationTrackingMode = mode;
    _mapboxOptions$.add(_mapboxOptions);
  }

  @override
  void dispose() {
    _mapboxOptions$.distinct();
    super.dispose();
  }
}
