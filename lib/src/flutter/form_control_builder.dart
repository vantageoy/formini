import 'package:flutter/widgets.dart';
import 'package:formini/formini.dart';
import 'package:formini/src/core/abstract_control.dart';
import 'package:formini/src/core/formini_state.dart';
import 'package:provider/provider.dart';

typedef Widget Builder<T>(
  BuildContext context,
  AbstractControl<T> control,
  ForminiState<T> state,
);

class FormControlBuilder<T> extends StatelessWidget {
  final Builder<T> builder;
  final String name;
  final AbstractControl control;

  const FormControlBuilder({Key key, this.name, this.control, this.builder})
      : assert((name != null && control != null) || builder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final AbstractControl<T> control =
        this.control ?? Provider.of<FormGroup>(context).controls[name];

    return StreamBuilder(
      stream: control.stateChanges,
      builder: (context, AsyncSnapshot<ForminiState<T>> snapshot) {
        if (snapshot.hasData) {
          return builder(context, control, snapshot.data);
        }
        return Container();
      },
    );
  }
}
