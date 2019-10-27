import 'dart:io';

import 'package:formini/formini.dart';
import 'package:schemani/schemani.dart';

enum Level { basic, premium }

class UserFormState extends FormGroup {
  FormControl<String> name;
  final FormControl<File> avatar = FormControl();
  final FormControl<Level> level = FormControl(Level.basic, [Required()]);
  final FormControl<String> email = FormControl(null, [Required(), Email()]);
  final FormControl<bool> hasDriverLicence = FormControl(false);
  FormControl<DateTime> driverLicenceExpires;

  UserFormState(Map initialValues) {
    name = FormControl(initialValues['profile']['name'], [Required()]);
    driverLicenceExpires = FormControl();
    // driverLicenceExpires = FormControl(null, [RequiredWhen(hasDriverLicence)]);
  }

  @override
  get shape => {
        'email': email,
        'profile': FormGroup({'name': name, 'avatar': avatar, 'level': level}),
        'licence_expires_at': driverLicenceExpires,
      };
}
