import 'package:flutter/material.dart';
import '../models/team.dart';
import '../bloc/team_bloc.dart';

class SelectTeam {
  SelectTeam();

  TeamBloc _teamBloc = TeamBloc();

  Future<void> selectTeamDialog(BuildContext context) async {
    TeamsIdList newId = await showDialog<TeamsIdList>(
        context: context,
        builder: (BuildContext context) {
          return teamDialog(context);
        });
    _teamBloc.setTeam = Team.fromId(newId);
  }

  SimpleDialog teamDialog(BuildContext context) {
    return SimpleDialog(
      title: Text('Select the Team'),
      children: <Widget>[
        SimpleDialogOption(
          child: Text(Team.nameFromId(TeamsIdList.blue)),
          onPressed: () {
            Navigator.pop(context, TeamsIdList.blue);
          },
        ),
        SimpleDialogOption(
          child: Text(Team.nameFromId(TeamsIdList.red)),
          onPressed: () {
            Navigator.pop(context, TeamsIdList.red);
          },
        ),
        SimpleDialogOption(
          child: Text(Team.nameFromId(TeamsIdList.all)),
          onPressed: () {
            Navigator.pop(context, TeamsIdList.all);
          },
        ),
      ],
    );
  }
}
