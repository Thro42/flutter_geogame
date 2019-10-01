class Team {
  String id;
  String name;
  Team(this.id, this.name);

  static fromIdString(String _id) {
    switch (_id) {
      case 'blue':
        return fromId(TeamsIdList.blue);
        break;
      case 'red':
        return fromId(TeamsIdList.red);
        break;
      default:
        return fromId(TeamsIdList.all);
        break;
    }
  }

  static String nameFromId(TeamsIdList _id) {
    switch (_id) {
      case TeamsIdList.blue:
        return 'Team Blue';
        break;
      case TeamsIdList.red:
        return 'Team Red';
        break;
      default:
        return 'No Team';
        break;
    }
  }

  static String idString(TeamsIdList _id) {
    return _id.toString().split('.')[1];
  }

  static fromId(TeamsIdList _id) {
    return Team(idString(_id), nameFromId(_id));
  }

  static TeamsIdList idFromStringID(String _ids) {
    TeamsIdList retId = TeamsIdList.all;
    for (var _id in TeamsIdList.values) {
      if (idString(_id) == _ids) retId = _id;
    }
    return retId;
  }

  static colorById(TeamsIdList _id) {
    switch (_id) {
      case TeamsIdList.blue:
        return '#0000ff';
        break;
      case TeamsIdList.red:
        return '#ff0000';
        break;
      default:
        return '#00ff00';
        break;
    }
  }
}

enum TeamsIdList {
  blue,
  red,
  all,
}
