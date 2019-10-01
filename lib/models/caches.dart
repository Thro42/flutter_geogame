import 'cache.dart';

class Caches {
  Caches() {
    list = new List();
  }

  List<Cache> list;
  void add(Cache _cache) {
    list.add(_cache);
  }

  Cache findByID(String _id) {
    return list.singleWhere((_c) => _c.id == _id);
  }

  Cache findBySymbolId(String _id) {
    return list.singleWhere((_c) => _c.symbolId == _id);
  }

  Cache findByCode(String _code) {
    Cache found;
    try {
      found = list.singleWhere((_c) => _c.code == _code);
    } catch (e) {
      print(e.toString());
    }
    return found;
  }

  void clear() {
    list.clear();
  }
}
