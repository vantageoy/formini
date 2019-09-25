abstract class Validator<T extends Map<String, dynamic>> {
  Map<String, Exception> validate(T values);
}
