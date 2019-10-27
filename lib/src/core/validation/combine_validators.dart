import 'package:formini/src/core/validation/validator.dart';

class CombineValidators<T> implements Validator<T> {
  final List<Function> _validators;

  const CombineValidators(this._validators);

  @override
  call(T value) {
    try {
      _validators.forEach((validator) => validator(value));
    } on Exception catch (exception) {
      return exception;
    }

    return null;
  }
}
