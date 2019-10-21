import 'package:flutter/widgets.dart';
import 'package:formini/formini.dart';
import 'package:formini/src/core/form_control.dart';
import 'package:formini/src/core/form_group.dart';
import 'package:formini/src/core/formini_state.dart';
import 'package:provider/provider.dart';

typedef Widget FormEditableTextAdaptorBuilder(
  BuildContext context,
  TextEditingController controller,
  ForminiState<String> state,
);

class FormEditableTextAdaptor extends StatelessWidget {
  final String name;
  final FormControl<String> control;
  final FormEditableTextAdaptorBuilder builder;

  const FormEditableTextAdaptor(
      {Key key, this.name, this.control, this.builder})
      : assert((name != null && control != null) || builder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final FormControl<String> control =
        this.control ?? Provider.of<FormGroup>(context).controls[name];

    final TextEditingController controller = TextEditingController();

    // @todo: unsub from these
    controller.addListener(() {
      control.setValue(controller.text);
    });

    return FormControlBuilder(
        name: name,
        control: control,
        builder: (context, control, state) {
          if (controller.text != state.value) {
            controller.text = state.value;
          }

          return builder(context, controller, state);
        });
  }
}
