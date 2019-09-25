import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formini/src/bloc/errors.dart';
import 'package:formini/src/bloc/status.dart';
import 'package:formini/src/bloc/touches.dart';
import 'package:formini/src/bloc/values.dart';
import 'package:rxdart/rxdart.dart';


class ForminiState {
  final ForminiStatusState status;
  final Map<String, Object> values;
  final Map<String, Exception> errors;
  final Map<String, bool> touches;
  final Function submit;

  const ForminiState({
    this.status,
    this.values,
    this.errors,
    this.touches,
    this.submit,
  });
}

typedef Widget ForminiStateBuilderFunction(
  BuildContext builder,
  ForminiState state,
);

class ForminiStateBuilder<T> extends StatelessWidget {
  final ForminiStateBuilderFunction builder;

  const ForminiStateBuilder({
    Key key,
    @required this.builder,
  })  : assert(builder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Observable.combineLatest4(
        BlocProvider.of<ForminiValuesBloc>(context).state,
        BlocProvider.of<ForminiTouchesBloc>(context).state,
        BlocProvider.of<ForminiErrorsBloc>(context).state,
        BlocProvider.of<ForminiStatusBloc>(context).state,
        (values, touches, errors, status) => ForminiState(
          values: values,
          touches: touches,
          errors: errors,
          status: status,
          submit: status.invalid
              ? null
              : () {
                  BlocProvider.of<ForminiStatusBloc>(context)
                      .dispatch(ForminiStatusEvent.submitting(values));
                },
        ),
      ),
      builder: (context, AsyncSnapshot<ForminiState> snapshot) {
        if (snapshot.hasData) {
          return builder(context, snapshot.data);
        }

        return Container();
      },
    );
  }
}
