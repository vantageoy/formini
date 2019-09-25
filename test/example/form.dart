import 'package:flutter/material.dart';
import 'package:formini/formini.dart';

class ExampleFormValidator implements Validator {
  const ExampleFormValidator();

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
    } else if (values['password'].length < 5) {
      errors['password'] = Exception('Password min length is 5');
    }

    return errors;
  }
}

class ExampleForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Formini(
      validator: const ExampleFormValidator(),
      initialValues: const {'email': 'foo'},
      onSubmit: _onSubmit,
      child: Column(children: [
        ForminiStateBuilder(builder: (context, form) {
          return Column(children: [
            Text(form.status.toString()),
            Text(form.values.toString()),
          ]);
        }),
        ForminiField(
          name: 'email',
          builder: (context, state) => TextField(
            key: Key('email-field'),
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
            key: Key('password-field'),
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

  Future<bool> _onSubmit(values) async {
    print(values);
    return true;
  }
}
