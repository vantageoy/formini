import 'package:flutter/material.dart';
import 'package:formini/formini.dart';
import 'package:formstate/initials.dart';
import 'package:formstate/user_form_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:schemani/schemani.dart';

const levelErrorMessages = {
  RequiredValidationException: 'Sorry, no guests allowed right now.',
};

class UserForm extends StatelessWidget {
  final UserFormState user;

  UserForm(
      [Map initialValues = const {
        'profile': {'name': 'foo'} // just for example
      }])
      : user = UserFormState(initialValues);

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      ListTile(
        title: Text('Profile', style: Theme.of(context).textTheme.caption),
      ),
      FormControlBuilder(
        control: user.name,
        builder: (context, nameState) => FormControlBuilder(
          control: user.avatar,
          builder: (context, avatarState) => ListTile(
            leading: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                final image = await ImagePicker.pickImage(
                  source: ImageSource.gallery,
                );

                user.avatar.setValue(image);
              },
              child: CircleAvatar(
                backgroundImage: avatarState.value == null
                    ? null
                    : FileImage(avatarState.value),
                child: nameState.value != null && avatarState.value == null
                    ? Text(initials(nameState.value))
                    : null,
              ),
            ),
            title: TextFormField(
              initialValue: nameState.value,
              onChanged: user.name.setValue,
              decoration: InputDecoration(
                labelText: 'Name',
                border: InputBorder.none,
                errorText: nameState.dirty ? nameState.error?.toString() : null,
              ),
            ),
          ),
        ),
      ),
      Divider(),
      ListTile(
        leading: CircleAvatar(
          child: Icon(Icons.email),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.grey,
        ),
        title: FormControlBuilder(
          control: user.email,
          builder: (context, state) => TextFormField(
            initialValue: state.value,
            onChanged: user.email.setValue,
            decoration: InputDecoration(
              labelText: 'Email address',
              errorText: state.dirty ? state.error?.toString() : null,
              border: InputBorder.none,
            ),
          ),
        ),
      ),
      Divider(),
      FormControlBuilder<Level>(
        control: user.level,
        builder: (context, state) => Column(children: [
          ListTile(
            title: Text(
              'Account level',
              style: Theme.of(context).textTheme.caption,
            ),
            subtitle: state.dirty && state.invalid
                ? Text(
                    levelErrorMessages.containsKey(state.error.runtimeType)
                        ? levelErrorMessages[state.error.runtimeType]
                        : state.error.toString(),
                    style: TextStyle(color: Colors.red),
                  )
                : null,
          ),
          RadioListTile(
            title: Text('Guest'),
            value: null,
            groupValue: state.value,
            onChanged: user.level.setValue,
          ),
          RadioListTile(
            title: Text('Basic'),
            value: Level.basic,
            groupValue: state.value,
            onChanged: user.level.setValue,
          ),
          RadioListTile(
            title: Text('Premium'),
            value: Level.premium,
            groupValue: state.value,
            onChanged: user.level.setValue,
          ),
        ]),
      ),
      Divider(),
      FormControlBuilder(
        control: user.hasDriverLicence,
        builder: (context, state) => Column(children: [
          CheckboxListTile(
            value: state.value,
            onChanged: user.hasDriverLicence.setValue,
            title: Text('Driver licence'),
            subtitle: Text(state.value
                ? 'The user has a driver licence'
                : 'The user does not have a driver licence'),
          ),
          if (state.value)
            ListTile(
              title: FormControlBuilder(
                control: user.driverLicenceExpires,
                builder: (context, state) => TextField(
                  controller: TextEditingController(
                    text: state.value?.toString(),
                  ),
                  decoration: InputDecoration(
                    labelText: 'Expiry date',
                    helperText: 'Located on the back side of the card',
                  ),
                  onTap: () async {
                    final datetime = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2018),
                      lastDate: DateTime(2030),
                    );

                    user.driverLicenceExpires.setValue(datetime);
                  },
                ),
              ),
            ),
        ]),
      ),
      Divider(),
      FormControlBuilder(
        control: user,
        builder: (context, state) => Column(children: [
          Text(DateTime.now().toString(), style: TextStyle(fontSize: 18)),
          Text(state.value.toString()),
          if (state.invalid)
            Text(state.error.toString(), style: TextStyle(color: Colors.red)),
          RaisedButton(
            child: Text('Submit'),
            // todo markAsDirty() on invalid so the error messages comes visible
            onPressed: state.invalid ? null : () => print(state),
          ),
        ]),
      ),
    ]);
  }
}
