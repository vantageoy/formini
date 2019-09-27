import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formini/src/bloc/errors.dart';
import 'package:formini/src/bloc/status.dart';
import 'package:formini/src/bloc/touches.dart';
import 'package:formini/src/bloc/values.dart';
import 'package:formini/src/exception.dart';
import 'package:rxdart/rxdart.dart';

class ForminiState {
  final ForminiStatusState status;
  final Map<String, Object> values;
  final ForminiException errors;
  final Map<String, bool> touches;
  Function submit;

  ForminiState({
    this.status,
    this.values,
    this.errors,
    this.touches,
  });
}

typedef Widget ForminiStateBuilderFunction(
  BuildContext builder,
  ForminiState state,
);

class ForminiStateBuilder<T> extends StatelessWidget {
  final ForminiStateBuilderFunction builder;

  const ForminiStateBuilder({Key key, @required this.builder})
      : assert(builder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Observable.combineLatest4(
        BlocProvider.of<ForminiValuesBloc>(context).state,
        BlocProvider.of<ForminiTouchesBloc>(context).state,
        BlocProvider.of<ForminiErrorsBloc>(context).state,
        BlocProvider.of<ForminiStatusBloc>(context).state,
        _combiner,
      ),
      builder: (context, AsyncSnapshot<ForminiState> snapshot) {
        if (snapshot.hasData) {
          // @todo submit fn shouldn't go into the state.
          // ForminiActions?
          if (snapshot.data.status.valid) {
            snapshot.data.submit = () {
              BlocProvider.of<ForminiStatusBloc>(context).dispatch(
                ForminiStatusEvent.submitting(snapshot.data.values),
              );
            };
          }

          return builder(context, snapshot.data);
        }

        return Container();
      },
    );
  }

  ForminiState _combiner(
    Map<String, dynamic> values,
    Map<String, bool> touches,
    ForminiErrorsState errorsState,
    ForminiStatusState status,
  ) {
    return ForminiState(
      values: values,
      touches: touches,
      errors: errorsState.errors,
      status: status,
    );
  }
}
