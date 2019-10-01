import 'package:flutter/material.dart';
import 'package:flutter_geogame/bloc/mapbox_bloc.dart';
import 'package:flutter_geogame/bloc/team_bloc.dart';
import 'package:flutter_geogame/dialogs/enter_code.dart';
import 'package:flutter_geogame/dialogs/select_team.dart';
import 'package:flutter_geogame/models/team.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:flutter_geogame/widgets/map.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MapWidget(), debugShowCheckedModeBanner: false);
  }
}

class MapWidget extends StatefulWidget {
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  SelectTeam _selectTeam = SelectTeam();
  CodeDialog _codeDialog = CodeDialog();
  MapboxBloc _mapboxBloc = MapboxBloc();
  Team _team = Team.fromId(TeamsIdList.all);
  TeamBloc _teamBloc = TeamBloc();

  @override
  void initState() {
    _teamBloc.team$.listen(_onTeamChaged);
    super.initState();
  }

  void _onTeamChaged(Team _newTeam) {
    this.setState(() {
      _team = _newTeam;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(context),
        body: Center(
          child: MapHolder(),
        ));
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: RichText(
          text: TextSpan(
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              children: <TextSpan>[
            TextSpan(text: 'GEO', style: TextStyle(color: Colors.greenAccent)),
            TextSpan(
              text: 'GAME',
            )
          ])),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.gps_fixed), // explore
          onPressed: () {
            if (_mapboxBloc.mapboxOptions.myLocationTrackingMode ==
                MyLocationTrackingMode.Tracking) {
              _mapboxBloc.myTrackingMode = MyLocationTrackingMode.TrackingGPS;
            } else {
              _mapboxBloc.myTrackingMode = MyLocationTrackingMode.Tracking;
            }
          },
        ),
        IconButton(
          icon: Icon(Icons.group_add),
          onPressed: () {
            selectTeamDialog(context);
          },
        ),
        IconButton(
          icon: Icon(Icons.vpn_key),
          onPressed: () {
            codeDialog(context);
          },
        ),
      ],
    );
  }

  Future<void> codeDialog(BuildContext context) async {
    _codeDialog.show(context);
  }

  Future<void> selectTeamDialog(BuildContext context) async {
    _selectTeam.selectTeamDialog(context);
  }
}
