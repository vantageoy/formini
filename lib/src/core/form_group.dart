import 'package:formini/src/core/abstract_control.dart';
import 'package:formini/src/core/formini_state.dart';
import 'package:formini/src/core/validation/form_group_exception.dart';
import 'package:rxdart/rxdart.dart';

class FormGroup<T extends Map<String, dynamic>> implements AbstractControl<T> {
  final Map<String, AbstractControl> controls;
  final List<Function> validators;

  Map<String, AbstractControl> get shape => controls;

  Stream<ForminiState<T>> get stateChanges => Observable.combineLatest(
        shape.values.map((control) => control.stateChanges),
        (List<ForminiState> controlStates) {
          final states = Map.fromIterables(shape.keys, controlStates);
          final value = states.map(
            (key, state) => MapEntry(key, state.value),
          );
          final errors = states.map(
            (key, state) => MapEntry(key, state.error),
          )..removeWhere((key, error) => error == null);

          // CombineValidators(validators)(value);

          return ForminiState(
            value: value,
            error: errors.isEmpty ? null : FormGroupException(errors),
            pristine: controlStates.every((state) => state.pristine),
          );
        },
      );

  FormGroup([this.controls = const {}, this.validators = const []]);

  setValue(T values) {
    shape.forEach((key, control) => control.setValue(values[key]));
  }
}
