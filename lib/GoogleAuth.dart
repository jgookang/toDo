import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';


GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

//class GoogleAuth extends StatefulWidget {
//  @override
//  State createState() => SignInState();
//}
//
//class SignInState extends State<GoogleAuth> {
//  GoogleSignInAccount _currentUser;
//  String _contactText;
//}