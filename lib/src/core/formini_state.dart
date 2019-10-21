import 'package:meta/meta.dart';

class ForminiState<T> {
  final bool pristine;
  final T value;
  final Exception error;

  bool get dirty => !pristine;
  bool get valid => error == null;
  bool get invalid => !valid;

  const ForminiState({@required this.pristine, this.value, this.error})
      : assert(pristine != null);

  Map<String, dynamic> _toJson() =>
      {'pristine': pristine, 'value': value, 'error': error};

  @override
  String toString() => _toJson().toString();
}
