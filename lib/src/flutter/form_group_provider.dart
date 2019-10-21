import 'package:flutter/widgets.dart';
import 'package:formini/src/core/form_group.dart';
import 'package:provider/provider.dart';

class FormGroupProvider extends StatelessWidget {
  final Widget child;
  final String name;
  final FormGroup group;

  const FormGroupProvider({Key key, this.name, this.group, this.child})
      : assert((name != null && group != null) || child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final FormGroup group =
        this.group ?? Provider.of<FormGroup>(context).controls[name];

    return Provider<FormGroup>.value(
      value: group,
      child: child,
    );
  }
}
