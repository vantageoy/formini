import 'package:formini/src/core/formini_state.dart';

abstract class AbstractControl<T> {
  Stream<ForminiState<T>> get stateChanges;

  void setValue(T value);
}
