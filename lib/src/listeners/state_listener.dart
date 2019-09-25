import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formini/src/bloc/errors.dart';
import 'package:formini/src/bloc/status.dart';
import 'package:formini/src/bloc/touches.dart';
import 'package:formini/src/bloc/values.dart';
import 'package:formini/src/builders/state_builder.dart';
import 'package:rxdart/rxdart.dart';

typedef ForminiStateListenerFunction(
  BuildContext builder,
  ForminiState state,
);

class ForminiStateListener extends StatefulWidget {
  final ForminiStateListenerFunction listener;

  const ForminiStateListener({Key key, this.listener}) : super(key: key);

  @override
  _ForminiStateListenerState createState() => _ForminiStateListenerState();
}

class _ForminiStateListenerState extends State<ForminiStateListener> {
  StreamSubscription state;

  @override
  void initState() {
    super.initState();

    state = Observable.combineLatest4(
      BlocProvider.of<ForminiValuesBloc>(context).state,
      BlocProvider.of<ForminiTouchesBloc>(context).state,
      BlocProvider.of<ForminiErrorsBloc>(context).state,
      BlocProvider.of<ForminiStatusBloc>(context).state,
      _combiner,
    ).listen((state) => widget.listener(context, state));
  }

  @override
  void dispose() {
    super.dispose();
    state?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  ForminiState _combiner(
    Map<String, dynamic> values,
    Map<String, bool> touches,
    Map<String, Exception> errors,
    ForminiStatusState status,
  ) {
    return ForminiState(
      values: values,
      touches: touches,
      errors: errors,
      status: status,
    );
  }
}
