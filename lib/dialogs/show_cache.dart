import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_geogame/bloc/caches_bloc.dart';
import 'package:flutter_geogame/models/cache.dart';

class CacheDialog {
  CacheDialog();

  CachesBloc _cachesBloc = CachesBloc();

  Future<void> show(BuildContext context, Cache _cache) async {
    CacheDialogAnswer answer = await showDialog<CacheDialogAnswer>(
        context: context,
        builder: (BuildContext context) {
          return cacheDialog(context, _cache);
        });
    if (answer == CacheDialogAnswer.found) {
      _cachesBloc.setCacheFound(_cache);
    }
  }

  SimpleDialog cacheDialog(BuildContext context, Cache cache) {
    Cache _cache = cache;
    Widget _leading;

    return SimpleDialog(title: Text(_cache.header), children: <Widget>[
      Card(
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        //_leading,
        ListTile(
          //leading: _leading, // Icon(Icons.album),
          title: Text(_cache.description),
        ),
      ])),
      ButtonTheme.bar(
        // make buttons use the appropriate styles for cards
        child: ButtonBar(
          children: <Widget>[
            FlatButton(
              child: const Text('Cancle'),
              onPressed: () {
                Navigator.pop(context, CacheDialogAnswer.cancle);
              },
            ),
            FlatButton(
              child: const Text('Found'),
              onPressed: () {
                Navigator.pop(context, CacheDialogAnswer.found);
              },
            ),
          ],
        ),
      ),
    ]);
  }
}

enum CacheDialogAnswer {
  found,
  cancle,
}
