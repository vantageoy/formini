import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

abstract class ForminiValuesEvent {
  const ForminiValuesEvent();
}

class ForminiValueChangeEvent extends ForminiValuesEvent {
  final String field;
  final dynamic value;

  const ForminiValueChangeEvent({this.field, this.value});

  @override
  String toString() => '${describeIdentity(this)}($field, $value)';
}

class ForminiValuesBloc extends Bloc<ForminiValuesEvent, Map<String, dynamic>> {
  final Map<String, dynamic> initialValues;

  ForminiValuesBloc(this.initialValues);

  @override
  get initialState => initialValues;

  @override
  mapEventToState(ForminiValuesEvent event) async* {
    if (event is ForminiValueChangeEvent) {
      yield {...currentState, event.field: event.value};
    }
  }
}
