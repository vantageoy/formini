import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:formini/src/exception.dart';
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

// BLoC disallows null states so wrap errors to a state class.
class ForminiErrorsState {
  final ForminiException errors;

  const ForminiErrorsState(this.errors);
}

class ForminiErrorsBloc extends Bloc<ForminiErrorsEvent, ForminiErrorsState> {
  final Validator validator;

  ForminiErrorsBloc(this.validator);

  @override
  get initialState => const ForminiErrorsState(null);

  @override
  mapEventToState(ForminiErrorsEvent event) async* {
    if (event is ForminiValuesChangeEvent) {
      yield ForminiErrorsState(validator.validate(event.values));
    }
  }
}
