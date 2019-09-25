import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formini/src/bloc/errors.dart';
import 'package:formini/src/bloc/status.dart';
import 'package:formini/src/bloc/touches.dart';
import 'package:formini/src/bloc/values.dart';
import 'package:formini/src/validator.dart';

typedef Future<bool> SubmitHandler<T extends Map<String, dynamic>>(T values);

class Formini<T extends Map<String, dynamic>> extends StatelessWidget {
  final Widget child;
  final T initialValues;
  final Validator<T> validator;
  final SubmitHandler<T> onSubmit;

  const Formini({
    Key key,
    this.initialValues,
    @required this.validator,
    @required this.child,
    @required this.onSubmit,
  })  : assert(child != null ||
            validator != null ||
            child != null ||
            onSubmit != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ForminiValuesBloc>(
          builder: (context) => ForminiValuesBloc(initialValues ?? {}),
        ),
        BlocProvider<ForminiErrorsBloc>(
          builder: (context) => ForminiErrorsBloc(validator),
        ),
        BlocProvider<ForminiStatusBloc>(
          builder: (context) => ForminiStatusBloc(onSubmit),
        ),
        BlocProvider<ForminiTouchesBloc>(
          builder: (context) => ForminiTouchesBloc(),
        ),
      ],
      child: BlocListener<ForminiValuesBloc, Map<String, dynamic>>(
        listener: (context, values) {
          BlocProvider.of<ForminiErrorsBloc>(context).dispatch(
            ForminiValuesChangeEvent(values: values),
          );
        },
        child: BlocListener<ForminiErrorsBloc, Map<String, Exception>>(
          listener: (context, errors) {
            BlocProvider.of<ForminiStatusBloc>(context).dispatch(
              errors.isEmpty
                  ? ForminiStatusEvent.valid()
                  : ForminiStatusEvent.invalid(),
            );
          },
          child: child,
        ),
      ),
    );
  }
}
