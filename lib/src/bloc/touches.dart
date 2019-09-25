import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

abstract class ForminiTouchesEvent {
  const ForminiTouchesEvent();
}

class ForminiFieldTouchedEvent extends ForminiTouchesEvent {
  final String field;

  const ForminiFieldTouchedEvent(this.field);

  @override
  String toString() => '${describeIdentity(this)}($field)';
}

class ForminiTouchesBloc extends Bloc<ForminiTouchesEvent, Map<String, bool>> {
  @override
  get initialState => {};

  @override
  mapEventToState(ForminiTouchesEvent event) async* {
    if (event is ForminiFieldTouchedEvent) {
      yield {...currentState, event.field: true};
    }
  }
}
