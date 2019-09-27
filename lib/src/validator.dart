import 'package:formini/src/exception.dart';

abstract class Validator<T extends Map<String, dynamic>> {
  ForminiException validate(T values);
}
