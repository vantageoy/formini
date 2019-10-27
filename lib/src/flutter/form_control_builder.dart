import 'package:flutter/widgets.dart';
import 'package:formini/src/core/abstract_control.dart';
import 'package:formini/src/core/formini_state.dart';

typedef Widget Builder<T>(
  BuildContext context,
  ForminiState<T> state,
);

class FormControlBuilder<T> extends StatelessWidget {
  final Builder<T> builder;
  final AbstractControl<T> control;

  const FormControlBuilder({Key key, this.control, this.builder})
      : assert(control != null || builder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: control.stateChanges,
      builder: (context, AsyncSnapshot<ForminiState<T>> snapshot) {
        if (snapshot.hasData) {
          return builder(context, snapshot.data);
        }
        return Container();
      },
    );
  }
}
