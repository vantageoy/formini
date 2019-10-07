import 'package:flutter/material.dart';
import 'package:formini/src/flutter/formini.dart';
import 'package:formini/src/flutter/formini_builder.dart';
import 'package:schemani/schemani.dart';

class UserForm extends StatelessWidget {
  static const schema = MapSchema({
    'email': Schema<String>([Email()]),
    'profile': MapSchema({
      'name': Schema<String>([Required()]),
    }),
  });

  const UserForm();

  @override
  Widget build(BuildContext context) {
    return Formini(
      schema: schema,
      child: Column(children: [
        ForminiBuilder(
          schema: schema['email'],
          builder: (context, state, actions) {
            return FlatButton(
              child: Text('Email ${state.value}'),
              onPressed: () {
                actions.onChange('new mail');
              },
            );
          },
        ),
        ForminiBuilder(
          schema: (schema['profile'] as MapSchema)['name'],
          builder: (context, state, actions) {
            return FlatButton(
              child: Text('Profile name ${state.value}'),
              onPressed: () {
                actions.onChange('new first last names');
              },
            );
          },
        ),
      ]),
    );
  }
}
