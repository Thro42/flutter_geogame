import 'package:flutter_geogame/models/cache.dart';
import 'package:flutter_geogame/models/caches.dart';
import 'package:flutter_geogame/models/team.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'bloc_base.dart';

class CachesBloc extends BlocBase {
  static final CachesBloc _cachesBlocSingleton = new CachesBloc._internal();
  factory CachesBloc() {
    return _cachesBlocSingleton;
  }
  CachesBloc._internal() {
    _collRef = Firestore.instance.collection('caches');
  }
  CollectionReference _collRef;
  Caches _caches = Caches();
  final _caches$ = BehaviorSubject<Caches>.seeded(Caches());

  String _teamId = Team.idString(TeamsIdList.all); //'all';

  void readcaches() {
    _collRef.snapshots().listen(_snapMarker);
  }

  void _snapMarker(QuerySnapshot snapShot) {
    var documents = snapShot.documents;
    if (documents.length > 0) {
      _caches.clear();
      for (var document in documents) {
        Cache _newCache = Cache.fromSnapshot(document);
        _caches.add(_newCache);
      }
      _fillCacheStream();
    }
  }

  void _fillCacheStream() {
    Caches _filterdCaches = Caches();
    for (var cache in _caches.list) {
      if (cache.found || cache.visible) {
        if (cache.schow_for == _teamId ||
            cache.schow_for == Team.idString(TeamsIdList.all) ||
            cache.found ||
            cache.is_final) {
          _filterdCaches.add(cache);
        }
      }
    }
    _caches$.add(_filterdCaches);
  }

  Caches get caches => _caches;

  Stream<Caches> get caches$ => _caches$.stream;

  set teamId(String _id) {
    _teamId = _id;
    _collRef.snapshots().listen(_snapMarker);
  }

  void setVisibleByCode(String _code) {
    Cache _upCache = _caches.findByCode(_code);
    if (_upCache != null) {
      _upCache.visible = true;
      _upCache.schow_for = _teamId;
      saveCache(_upCache);
    }
  }

  void setCacheFound(Cache _cache) {
    Cache _upCache = _cache;
    if (!_upCache.found) {
      _upCache.found = true;
      _upCache.found_by = _teamId;
      saveCache(_upCache);
    }
  }

  void saveCache(Cache _updCache) {
    _collRef.document(_updCache.id).updateData(_updCache.toDocument());
  }

  @override
  void dispose() {
    _caches$.distinct();
    super.dispose();
  }
}
