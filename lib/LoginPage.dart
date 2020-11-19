import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
{
  final _formKey = new GlobalKey<FormState>();
  String _email;
  String _password;

  bool validateAndSave() {
    final form = _formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() {
    if(validateAndSave()){

    }
  }

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Google Login'),
        ),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) => value.isEmpty ? "Email cna\'t be empty" : null,
                  onSaved: (value) => _email = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) => value.isEmpty ? "Password cna\'t be empty" : null,
                  onSaved: (value) => _password = value,
                ),
                RaisedButton(
                  child: Text('Login', style: TextStyle(fontSize: 20.0)),
                  onPressed: validateAndSubmit,
                ),
              ],
            ),
          )
        ),
      );
  }
}
