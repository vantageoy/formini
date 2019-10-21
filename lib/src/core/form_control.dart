import 'package:formini/src/core/abstract_control.dart';
import 'package:formini/src/core/formini_state.dart';
import 'package:formini/src/core/validation/combine_validators.dart';
import 'package:formini/src/core/validation/validator.dart';
import 'package:rxdart/rxdart.dart';

class FormControl<T> implements AbstractControl<T> {
  final BehaviorSubject<T> _valueSubject;
  final Validator _validator;

  Stream<ForminiState<T>> get stateChanges => _valueSubject.scan(
        (previousState, value, i) => ForminiState(
          value: value,
          pristine: previousState == null,
          error: _validator(value),
        ),
      );

  FormControl([T initialValue, List<Function> validators = const []])
      : _valueSubject = BehaviorSubject.seeded(initialValue),
        _validator = CombineValidators(validators);

  void setValue(T newValue) {
    if (_valueSubject.value != newValue) {
      _valueSubject.add(newValue);
    }
  }
}
