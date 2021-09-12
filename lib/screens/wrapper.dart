import 'package:brew_crew/models/userAnon.dart';
import 'package:brew_crew/screens/auth/authenticate.dart';
import 'package:brew_crew/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserAnon?>(context);
    // return either Home or Authenticate widget
    if (user != null) {
      return Home();
    }
    return Authenticate();
  }
}
