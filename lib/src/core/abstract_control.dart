import 'package:formini/src/core/formini_state.dart';

abstract class AbstractControl<T> {
  Stream<ForminiState<T>> get stateChanges;
  final List<Function> validators = [];

  void setValue(T value);
}
