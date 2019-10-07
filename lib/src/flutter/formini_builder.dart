import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:formini/src/core/formini.dart';
import 'package:schemani/schemani.dart';

typedef void OnChange(value);

class ForminiActions {
  final OnChange onChange;

  const ForminiActions({this.onChange});
}

typedef Widget ForminiBuilderFunc(
  BuildContext context,
  ForminiState state,
  ForminiActions actions,
);

class ForminiBuilder extends StatelessWidget {
  final Schema schema;
  final ForminiBuilderFunc builder;

  const ForminiBuilder({Key key, this.schema, this.builder})
      : assert(schema != null || builder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<Map<Schema, ForminiState>>(builder: (context, store) {
      return builder(
        context,
        store.state[schema],
        ForminiActions(
          onChange: (value) => store.dispatch(ValueChangeAction(schema, value)),
        ),
      );
    });
  }
}
