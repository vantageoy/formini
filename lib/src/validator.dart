abstract class Validator<T extends Map<String, dynamic>> {
  ForminiException validate(T values);
}

class ForminiException implements Exception {
  final Map<String, ForminiException> exceptions;
  final String message;

  const ForminiException({this.exceptions, this.message});

  const ForminiException.map(Map<String, ForminiException> exceptions)
      : exceptions = exceptions,
        message = null;

  ForminiException operator [](String field) => exceptions[field];

  operator []=(String field, ForminiException exception) =>
      exceptions[field] = exception;

  @override
  String toString() => message ?? super.toString();
}
