import 'package:brew_crew/models/userAnon.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingForm extends StatefulWidget {
  const SettingForm({Key? key}) : super(key: key);

  @override
  _SettingFormState createState() => _SettingFormState();
}

class _SettingFormState extends State<SettingForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4', '5'];

  String? _currentName;
  String? _currentSugars;
  int? _currentStrength;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserAnon?>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user!.uid).userData,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Loading();
        }

        UserData? userData = snapshot.data;
        return Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                "Update your brew strength",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              TextFormField(
                initialValue: userData!.name,
                decoration: textInputDecoratoin,
                validator: (val) => val!.isEmpty ? "Please enter a name" : null,
                onChanged: (val) => _currentName = val,
              ),
              SizedBox(height: 20),
              DropdownButtonFormField(
                decoration: textInputDecoratoin,
                value: _currentSugars ?? userData.sugars,
                items: sugars.map((sugar) {
                  return DropdownMenuItem(
                    child: Text('$sugar sugars'),
                    value: sugar,
                  );
                }).toList(),
                onChanged: (val) => _currentSugars = val as String?,
              ),
              Slider(
                activeColor:
                    Colors.brown[_currentStrength ?? userData.strength],
                inactiveColor:
                    Colors.brown[_currentStrength ?? userData.strength],
                value: (_currentStrength ?? userData.strength).toDouble(),
                min: 100.0,
                max: 900.0,
                divisions: 8,
                onChanged: (val) =>
                    setState(() => _currentStrength = val.round()),
              ),
              SizedBox(height: 10),
              TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.pink[400]),
                child: Text(
                  'Update',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (!(_currentName == null &&
                      _currentSugars == null &&
                      _currentStrength == null)) {
                    await DatabaseService(uid: user.uid).updateUserData(
                        _currentSugars ?? userData.sugars,
                        _currentName ?? userData.name,
                        _currentStrength ?? userData.strength);
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
