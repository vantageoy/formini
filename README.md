# formini

Working with forms shouldn't be so hard in Flutter.

Please note that the schemani/formini packages are under development. There are still some issues to resolve before this has any help for real use cases. [#roadmap](#roadmap)

## Usage

Formini doesn't care what inputs you use. It however provides a `TextEditingController` via `state.controller` out of the box. For inputs other than `TextField`s you can use `state.onChange` and `state.field.value`.

Values are not limited only to Dart built in types. If you want to store a date field as `DateTime` and display the value formatted you absolutely can.

![Login form using formini](https://raw.githubusercontent.com/vantageoy/formini/master/readme-login-form.png)

```dart
import 'package:flutter/material.dart';
import 'package:formini/formini.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Formini(
      validator: const LoginFormValidator(),
      initialValues: const {'email': 'foo'},
      onSubmit: _authenticate,
      child: Column(children: [
        ForminiStateBuilder(builder: (context, form) {
          return Column(children: [
            Text('Status: ${form.status}'),
            Text('Values: ${form.values}'),
          ]);
        }),
        ForminiField(
          name: 'email',
          builder: (context, state) => TextField(
            controller: state.controller,
            decoration: InputDecoration(
              labelText: 'Email address',
              errorText: state.field.errorText,
            ),
          ),
        ),
        ForminiField(
          name: 'password',
          builder: (context, state) => TextField(
            controller: state.controller,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              errorText: 
                  state.field.touched ? state.field.error?.toString() : null,
            ),
          ),
        ),
        ForminiStateBuilder(builder: (context, form) {
          return RaisedButton(
            onPressed: form.submit,
            child: Text('Login'),
          );
        }),
      ]),
    );
  }

  Future<bool> _authenticate(Map<String, dynamic> credentials) async {
    // Do what ever you need to do here.
    print(credentials);
    
    return true;
  }
}
```

### Validation

Implement the `Validator` interface on your validator class.

#### 1. Option - Manually

```dart
import 'package:formini/formini.dart';

class LoginFormValidator implements Validator {
  const LoginFormValidator();

  @override
  Map<String, Exception> validate(Map<String, dynamic> values) {
    final errors = <String, Exception>{};

    if (values['email'] == null || values['email'].isEmpty) {
      errors['email'] = Exception('Email is required');
    } else if (!values['email'].contains('@')) {
      errors['email'] = Exception('Email is invalid');
    }

    if (values['password'] == null || values['password'].isEmpty) {
      errors['password'] = Exception('Password is required');
    }

    return errors;
  }
}
```

#### 2. Option - Schemani (recommended)

Use [formini-schemani](https://pub.dev/packages/formini-schemani) package for validating values using [schemani](https://pub.dev/packages/schemani). Or just copy the one simple file to your project.

```dart
import 'package:schemani/schemani.dart';
import 'package:formini-schemani/validator.dart';

const LoginFormValidator = ForminiSchemaniValidator(MapSchema({
  'email': [Required(), Email()],
  'password': [Required()],
}));
```

## API reference

https://pub.dev/documentation/formini

## Contributing

Please open an issue or pull request in GitHub. Any help and feedback is much appreciated.

## Licence

MIT

## Roadmap

- Support for nested values maps
- Support for lists
- Async validation
- Unit testing after refactoring
  - Separate core out from the Flutter stuff
