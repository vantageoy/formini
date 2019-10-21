import 'package:formini/src/core/abstract_control.dart';
import 'package:formini/src/core/formini_state.dart';
import 'package:formini/src/core/validation/form_group_exception.dart';
import 'package:rxdart/rxdart.dart';

class FormGroup<T extends Map<String, dynamic>> implements AbstractControl<T> {
  final Map<String, AbstractControl> controls;

  Stream<ForminiState<T>> stateChanges;

  FormGroup(this.controls, [List<Function> validators = const []])
      : stateChanges = Observable.combineLatest(
          controls.values.map((control) => control.stateChanges),
          (List<ForminiState> controlStates) {
            final states = Map.fromIterables(controls.keys, controlStates);
            final errors = states.map(
              (key, state) => MapEntry(key, state.error),
            )..removeWhere((key, error) => error == null);

            return ForminiState(
              value: states.map((key, state) => MapEntry(key, state.value)),
              error: errors.isEmpty ? null : FormGroupException(errors),
              pristine: controlStates.every((state) => state.pristine),
            );
          },
        ).asBroadcastStream() as dynamic; // @todo remove dynamic

  setValue(T values) {
    controls.forEach((key, control) => control.setValue(values[key]));
  }
}
