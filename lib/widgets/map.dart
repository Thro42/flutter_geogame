import 'package:flutter/material.dart';
import 'package:flutter_geogame/bloc/caches_bloc.dart';
import 'package:flutter_geogame/bloc/mapbox_bloc.dart';
import 'package:flutter_geogame/bloc/team_bloc.dart';
import 'package:flutter_geogame/dialogs/show_cache.dart';
import 'package:flutter_geogame/models/cache.dart';
import 'package:flutter_geogame/models/caches.dart';
import 'package:flutter_geogame/models/mapbox.dart';
import 'package:flutter_geogame/models/team.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class MapHolder extends StatefulWidget {
  const MapHolder();
  State<StatefulWidget> createState() => MapHolderState();
}

class MapHolderState extends State<MapHolder> {
  MapHolderState();

  static final CameraPosition _kInitialPosition = const CameraPosition(
    //tilt: 45,
    //bearing: 30,
    target: LatLng(52.1695972, 7.5475882),
    zoom: 16.0,
  );

  MapboxMapController mapController;
  CameraPosition _position = _kInitialPosition;
  bool _compassEnabled = true;
  CameraTargetBounds _cameraTargetBounds = CameraTargetBounds.unbounded;
  MinMaxZoomPreference _minMaxZoomPreference = MinMaxZoomPreference.unbounded;
  String _styleString = MapboxStyles.MAPBOX_STREETS;
  bool _rotateGesturesEnabled = true;
  bool _scrollGesturesEnabled = true;
  bool _tiltGesturesEnabled = true;
  bool _zoomGesturesEnabled = true;
  bool _myLocationEnabled = true;
  MyLocationTrackingMode _myLocationTrackingMode =
      MyLocationTrackingMode.Tracking;
  final cityBounds = LatLngBounds(
    southwest: LatLng(52.16934, 7.54718),
    northeast: LatLng(52.16935, 7.54719),
  );

  List<Cache> caches = new List();

  MapboxOptions _mapboxOptions = MapboxOptions(_kInitialPosition,
      MyLocationTrackingMode.Tracking, MapboxStyles.MAPBOX_STREETS);
  MapboxBloc _mapboxBloc = MapboxBloc();

  Team _team = Team.fromId(TeamsIdList.all);
  TeamBloc _teamBloc = TeamBloc();
  CachesBloc _cachesBloc = CachesBloc();
  CacheDialog _cacheDialog = CacheDialog();

  @override
  void initState() {
    _teamBloc.team$.listen(_onTeamChaged);
    _mapboxBloc.mapboxOptions$.listen(_onMapOptionChange);
    super.initState();
  }

  void _onMapOptionChange(MapboxOptions _options) {
    this.setState(() {
      _myLocationTrackingMode = _options.myLocationTrackingMode;
    });
  }

  void _onTeamChaged(Team _newTeam) {
    this.setState(() {
      _team = _newTeam;
    });
    _cachesBloc.teamId = _team.id;
  }

  void _onMapChanged() {
    setState(() {
      _extractMapInfo();
    });
  }

  void _extractMapInfo() {
    _position = mapController.cameraPosition;
    //_isMoving = mapController.isCameraMoving;
  }

  @override
  void dispose() {
    mapController.removeListener(_onMapChanged);
    _teamBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MapboxMap mapboxMap = MapboxMap(
        onMapCreated: onMapCreated,
        initialCameraPosition: _kInitialPosition,
        trackCameraPosition: true,
        compassEnabled: _compassEnabled,
        cameraTargetBounds: _cameraTargetBounds,
        minMaxZoomPreference: _minMaxZoomPreference,
        styleString: _styleString,
        rotateGesturesEnabled: _rotateGesturesEnabled,
        scrollGesturesEnabled: _scrollGesturesEnabled,
        tiltGesturesEnabled: _tiltGesturesEnabled,
        zoomGesturesEnabled: _zoomGesturesEnabled,
        myLocationEnabled: _myLocationEnabled,
        myLocationTrackingMode: _myLocationTrackingMode,
        onMapClick: (point, latLng) async {
          print(
              "${point.x},${point.y}   ${latLng.latitude}/${latLng.longitude}");
        },
        onCameraTrackingDismissed: () {
          this.setState(() {
            _myLocationTrackingMode = MyLocationTrackingMode.None;
          });
        });

    String _posText() {
      this.setState(() {});
      String _newText = '';
      if (mapController != null) {
        _newText =
            'Team:${_team.id.toUpperCase()} pos: ${_position.target.latitude.toStringAsFixed(4)},'
            '${_position.target.longitude.toStringAsFixed(4)}';
      }
      return _newText;
    }

    final List<Widget> stacColumn = <Widget>[
      Flexible(
          child: Stack(children: <Widget>[
        mapboxMap,
        Align(
          alignment: Alignment.bottomRight,
          child: Text(_posText()),
        )
      ])),
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: stacColumn,
    );
  }

  _symboleTapped(Symbol marker) {
    Cache _cache = caches.singleWhere((ch) => ch.symbolId == marker.id);
    _cacheDialog.show(context, _cache);
  }

  void onMapCreated(MapboxMapController controller) {
    mapController = controller;
    mapController.addListener(_onMapChanged);
    mapController.onSymbolTapped.add(_symboleTapped);
    setState(() {
      _mapboxOptions.mapController = mapController;
    });

    _extractMapInfo();
    _readCacheBloc();
    setState(() {});
  }

// Cache Bloc
  void _readCacheBloc() {
    _cachesBloc.caches$.listen(_cachBlocChange);
    _cachesBloc.readcaches();
  }

  void _cachBlocChange(Caches _caches) {
    mapController.clearCircles();
    caches.clear();
    for (var cache in _caches.list) {
      _updateMarker(cache);
    }
  }

  void _updateMarker(Cache newCache) {
    var idx;
    if (caches == null) {
      caches = new List();
    }
    if (caches.length <= 0) {
      caches.add(newCache);
    }
    idx = caches.indexWhere((cache) => cache.id == newCache.id);
    if (idx < 0) {
      caches.add(newCache);
    }
    idx = caches.indexWhere((cache) => cache.id == newCache.id);
    if (idx >= 0) {
      _createMarker(idx);
    }
  }

  void _createMarker(int idx) {
    CircleOptions cycleOpt;
    if (caches[idx].found) {
      TeamsIdList foundID = Team.idFromStringID(caches[idx].found_by);
      cycleOpt = new CircleOptions(
          geometry: LatLng(caches[idx].coordinates.longitude,
              caches[idx].coordinates.latitude),
          circleRadius: 9,
          circleStrokeWidth: 3.0,
          circleStrokeColor: '#ffff00',
          circleColor: Team.colorById(foundID));
    } else {
      if (caches[idx].is_final) {
        cycleOpt = new CircleOptions(
            geometry: LatLng(caches[idx].coordinates.longitude,
                caches[idx].coordinates.latitude),
            circleRadius: 9,
            circleStrokeWidth: 3.0,
            circleStrokeColor: '#ffff00',
            circleColor: '#ff0fff');
      } else {
        cycleOpt = new CircleOptions(
            geometry: LatLng(caches[idx].coordinates.longitude,
                caches[idx].coordinates.latitude),
            circleRadius: 9,
            circleStrokeWidth: 3.0,
            circleStrokeColor: '#ffffff',
            circleColor: '#ffff00');
      }
    }
    // print('New cache ' + caches[idx].header);
    mapController.addCircle(cycleOpt);
  }
}
