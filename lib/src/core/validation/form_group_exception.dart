class FormGroupException implements Exception {
  final Map<String, Exception> _exceptions;

  const FormGroupException(this._exceptions);

  FormGroupException operator [](String key) => _exceptions[key];

  @override
  String toString() => _exceptions.toString();
}
