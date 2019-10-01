import 'package:rxdart/rxdart.dart';
import 'bloc_base.dart';
import '../models/team.dart';

class TeamBloc extends BlocBase {
  static final TeamBloc _teamBlocSingleton = new TeamBloc._internal();
  factory TeamBloc() {
    return _teamBlocSingleton;
  }
  TeamBloc._internal();

  Team _currentTeam = Team.fromId(TeamsIdList.all);
  final _team$ = BehaviorSubject<Team>.seeded(Team.fromId(TeamsIdList.all));

  set setTeam(Team _newTeam) => _team$.add(_currentTeam = _newTeam);
  set setTeamId(_newTeamId) {
    _currentTeam = Team.fromIdString(_newTeamId);
    _team$.add(_currentTeam);
  }

  Team get team => _team$.value;

  Stream<Team> get team$ => _team$.stream;

  @override
  void dispose() {
    _team$.distinct();
    super.dispose();
  }
}
