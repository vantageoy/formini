import 'package:schemani/schemani.dart';

class ValueChangeAction {
  final Schema schema;
  final dynamic value;

  const ValueChangeAction(this.schema, this.value);

  @override
  String toString() => 'ValueChangeAction($schema, $value)';
}

class ForminiState {
  final dynamic value;

  const ForminiState({this.value});

  String toString() => 'ForminiState($value)';
}

Map<Schema, ForminiState> forminiReducer(
  Map<Schema, ForminiState> state,
  action,
) {
  if (action is ValueChangeAction) {
    return {...state, action.schema: ForminiState(value: action.value)};
  }

  return state;
}
