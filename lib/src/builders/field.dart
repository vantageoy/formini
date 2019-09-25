import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formini/src/bloc/touches.dart';
import 'package:formini/src/bloc/values.dart';
import 'package:formini/src/builders/field_state_builder.dart';

typedef Widget ForminiFieldBuilder<T extends Object>(
  BuildContext builder,
  InputState<T> state,
);

typedef void ChangeHandler<T extends Object>(T value);

class InputState<T extends Object> {
  final TextEditingController controller;
  final ForminiFieldState<T> field;
  final ChangeHandler<T> onChange;

  const InputState({this.controller, this.field, this.onChange});
}

class ForminiField<T extends Object> extends StatefulWidget {
  final String name;
  final ForminiFieldBuilder<T> builder;

  const ForminiField({
    Key key,
    @required this.builder,
    @required this.name,
  })  : assert(name != null || builder != null),
        super(key: key);

  @override
  _ForminiFieldState createState() => _ForminiFieldState<T>(builder);
}

class _ForminiFieldState<T extends Object> extends State<ForminiField> {
  TextEditingController controller;
  final ForminiFieldBuilder<T> builder;

  _ForminiFieldState(this.builder);

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(
        text: BlocProvider.of<ForminiValuesBloc>(context)
            .currentState[widget.name]);

    controller.addListener(() {
      final valuesBloc = BlocProvider.of<ForminiValuesBloc>(context);
      final currentValue =
          valuesBloc.currentState[widget.name]?.toString() ?? '';

      if (currentValue == controller.text) {
        return;
      }

      valuesBloc.dispatch(
        ForminiValueChangeEvent(field: widget.name, value: controller.text),
      );

      BlocProvider.of<ForminiTouchesBloc>(context).dispatch(
        ForminiFieldTouchedEvent(widget.name),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ForminiFieldStateBuilder<T>(
      name: widget.name,
      builder: (context, state) {
        final textValue = state.value?.toString() ?? '';

        if (textValue != controller.text) {
          controller.text = textValue;
        }

        return builder(
          context,
          InputState(
            controller: controller,
            field: state,
            onChange: (value) {
              // Exit early if the value didn't actually change.
              if (value == textValue ||
                  (value == null && state.value == null)) {
                return;
              }

              BlocProvider.of<ForminiValuesBloc>(context).dispatch(
                  ForminiValueChangeEvent(field: widget.name, value: value));

              BlocProvider.of<ForminiTouchesBloc>(context)
                  .dispatch(ForminiFieldTouchedEvent(widget.name));
            },
          ),
        );
      },
    );
  }
}
