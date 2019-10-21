import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formini/formini.dart';
import 'package:image_picker/image_picker.dart';
import 'package:schemani/schemani.dart';

enum Level { basic, premium }

class UserForm extends StatelessWidget {
  final form = FormGroup({
    'email': FormControl<String>(null, [Required(), Email()]),
    'profile': FormGroup({
      'name': FormControl<String>(null, [Required()]),
      'avatar': FormControl<File>(),
      'level': FormControl<Level>(Level.basic, [Required()]),
    }),
    'newsletter': FormControl<bool>(false),
    'newsletter_at': FormControl<DateTime>(null),
  });

  @override
  Widget build(BuildContext context) {
    return FormGroupProvider(
      group: form,
      child: ListView(children: [
        ListTile(
          title: Text(
            'Profile',
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        FormControlBuilder(
          name: 'profile',
          builder: (context, control, state) {
            final group = control as FormGroup;

            return ListTile(
              leading: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  group.controls['avatar'].setValue(
                    await ImagePicker.pickImage(source: ImageSource.gallery),
                  );
                },
                child: CircleAvatar(
                  backgroundImage: state.value['avatar'] == null
                      ? null
                      : FileImage(state.value['avatar']),
                  child: state.value['name'] != null &&
                          state.value['avatar'] == null
                      ? Text(state.value['name']
                          .toString()
                          .split(' ')
                          .take(2)
                          .map((word) => word.isEmpty ? '' : word[0])
                          .join()
                          .toUpperCase())
                      : null,
                ),
              ),
              title: TextField(
                onChanged: group.controls['name'].setValue,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: InputBorder.none,
                  // errorText: state.dirty ? state.error?.toString() : null,
                ),
              ),
            );
          },
        ),
        Divider(),
        ListTile(
          leading: CircleAvatar(
            child: Icon(Icons.email),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.grey,
          ),
          title: FormEditableTextAdaptor(
            name: 'email',
            builder: (context, controller, state) => TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Email address',
                errorText: state.dirty ? state.error?.toString() : null,
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        Divider(),
        ListTile(
          title: Text(
            'Account level',
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        FormControlBuilder<Level>(
          control: (form.controls['profile'] as FormGroup).controls['level'],
          builder: (context, control, state) => Column(children: [
            RadioListTile(
              title: Text('Guest'),
              value: null,
              groupValue: state.value,
              onChanged: control.setValue,
            ),
            RadioListTile(
              title: Text('Basic'),
              value: Level.basic,
              groupValue: state.value,
              onChanged: control.setValue,
            ),
            RadioListTile(
              title: Text('Premium'),
              value: Level.premium,
              groupValue: state.value,
              onChanged: control.setValue,
            ),
          ]),
        ),
        Divider(),
        FormControlBuilder<bool>(
          name: 'newsletter',
          builder: (context, control, state) => CheckboxListTile(
            value: state.value,
            onChanged: control.setValue,
            title: Text('Newsletter'),
            subtitle: Text(state.value
                ? 'Weekly news are sent to your mail box'
                : "No weekly mails are sent"),
          ),
        ),
        FormControlBuilder<DateTime>(
          name: 'newsletter_at',
          builder: (context, control, state) => Text('millo?'),
        ),
        Divider(),
        FormControlBuilder<Map>(
          control: form,
          builder: (context, control, state) => Column(children: [
            Text(DateTime.now().toString(), style: TextStyle(fontSize: 18)),
            Text(state.value.toString()),
            if (state.dirty)
              Text(state.error.toString(), style: TextStyle(color: Colors.red)),
            RaisedButton(
              child: Text('Submit'),
              onPressed: state.invalid ? null : () => print(state),
            )
          ]),
        ),
      ]),
    );
  }
}
