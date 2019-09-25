import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:formini/src/validator.dart';

abstract class ForminiErrorsEvent {
  const ForminiErrorsEvent();
}

class ForminiValuesChangeEvent extends ForminiErrorsEvent {
  final Map<String, dynamic> values;

  const ForminiValuesChangeEvent({this.values});

  @override
  String toString() => '${describeIdentity(this)}($values)';
}

class ForminiErrorsBloc extends Bloc<ForminiErrorsEvent, Map<String, Exception>> {
  final Validator validator;

  ForminiErrorsBloc(this.validator);

  @override
  get initialState => {};

  @override
  mapEventToState(ForminiErrorsEvent event) async* {
    if (event is ForminiValuesChangeEvent) {
      yield validator.validate(event.values);
    }
  }
}
