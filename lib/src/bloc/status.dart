import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:formini/src/builders/form.dart';

enum ForminiStatus { pristine, valid, invalid, submitting, submitted }

class ForminiStatusEvent {
  final ForminiStatus status;
  dynamic payload;

  ForminiStatusEvent.pristine() : status = ForminiStatus.pristine;
  ForminiStatusEvent.valid() : status = ForminiStatus.valid;
  ForminiStatusEvent.invalid() : status = ForminiStatus.invalid;
  ForminiStatusEvent.submitted() : status = ForminiStatus.submitted;
  ForminiStatusEvent.submitting(Map<String, dynamic> values)
      : status = ForminiStatus.submitting,
        payload = values;

  @override
  String toString() => '${describeIdentity(this)}($status, $payload)';
}

class ForminiStatusState {
  final bool pristine;
  final bool valid;
  final bool submitting;
  final bool submitted;

  bool get invalid => !valid;
  bool get dirty => !pristine;

  const ForminiStatusState({
    this.pristine = false,
    this.valid = false,
    this.submitting = false,
    this.submitted = false,
  });

  copyWith({bool pristine, bool valid, bool submitting, bool submitted}) {
    return ForminiStatusState(
      pristine: pristine ?? this.pristine,
      valid: valid ?? this.valid,
      submitting: submitting ?? this.submitting,
      submitted: submitted ?? this.submitted,
    );
  }

  @override
  String toString() => {
        "pristine": pristine,
        "valid": valid,
        "submitting": submitting,
        "submitted": submitted,
      }.toString();
}

class ForminiStatusBloc extends Bloc<ForminiStatusEvent, ForminiStatusState> {
  final SubmitHandler onSubmit;

  ForminiStatusBloc(this.onSubmit);

  @override
  get initialState => ForminiStatusState(pristine: true);

  @override
  mapEventToState(ForminiStatusEvent event) async* {
    switch (event.status) {
      case ForminiStatus.invalid:
        yield currentState.copyWith(
            valid: false, pristine: false, submitting: false);
        break;
      case ForminiStatus.pristine:
        yield ForminiStatusState(pristine: true);
        break;
      case ForminiStatus.submitted:
        yield currentState.copyWith(
            submitted: true, pristine: false, submitting: false);
        break;
      case ForminiStatus.submitting:
        yield currentState.copyWith(submitting: true, pristine: false);
        break;
      case ForminiStatus.valid:
        yield currentState.copyWith(valid: true, pristine: false);
        break;
    }

    if (event.status == ForminiStatus.submitting) {
      if (true == await onSubmit(event.payload)) {
        dispatch(ForminiStatusEvent.submitted());
      } else {
        dispatch(ForminiStatusEvent.invalid());
      }
    }
  }
}
