import 'package:flutter/material.dart';
import 'package:formini/src/builders/state_builder.dart';

class ForminiFieldState<T extends Object> {
  final T value;
  final Exception error;
  final bool touched;

  String get errorText => touched ? error?.toString() : null;

  const ForminiFieldState({this.value, this.error, this.touched});
}

typedef Widget ForminiFieldStateBuilderFunction<T extends Object>(
  BuildContext builder,
  ForminiFieldState<T> state,
);

class ForminiFieldStateBuilder<T extends Object> extends StatelessWidget {
  final ForminiFieldStateBuilderFunction<T> builder;
  final String name;

  const ForminiFieldStateBuilder({
    Key key,
    @required this.name,
    @required this.builder,
  })  : assert(builder != null || name != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ForminiStateBuilder(builder: (context, form) {
      final state = ForminiFieldState<T>(
        value: form.values[name],
        error: form.errors[name],
        touched: form.touches[name] ?? false,
      );

      return builder(context, state);
    });
  }
}
