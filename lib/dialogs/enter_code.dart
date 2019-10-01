import 'package:flutter/material.dart';
import 'package:flutter_geogame/bloc/caches_bloc.dart';

class CodeDialog {
  CodeDialog();

  CachesBloc _cachesBloc = CachesBloc();
  final _formKey = GlobalKey<FormState>();
  String _code;

  Future<void> show(BuildContext context) async {
    CodeDialogAnswer answer = await showDialog<CodeDialogAnswer>(
        context: context,
        builder: (BuildContext context) {
          return codeDialog(context);
        });
    if (answer == CodeDialogAnswer.save) {
      _cachesBloc.setVisibleByCode(_code);
    }
  }

  SimpleDialog codeDialog(BuildContext context) {
    return SimpleDialog(title: Text('Gib einen Code ein'), children: <Widget>[
      Form(
          key: _formKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Code eingeben',
                  labelText: 'Code',
                ),
                onSaved: (value) {
                  _code = value.trim().toLowerCase();
                }),
            ButtonTheme.bar(
              // make buttons use the appropriate styles for cards
              child: ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: const Text('Abbruch'),
                    onPressed: () {
                      Navigator.pop(context, CodeDialogAnswer.cancle);
                    },
                  ),
                  FlatButton(
                    child: const Text('Sichern'),
                    onPressed: () {
                      _formKey.currentState.save();
                      Navigator.pop(context, CodeDialogAnswer.save);
                    },
                  ),
                ],
              ),
            ),
          ]))
    ]);
  }
}

enum CodeDialogAnswer {
  save,
  cancle,
}
