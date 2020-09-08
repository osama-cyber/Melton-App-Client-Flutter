import 'dart:developer'; //todo remove

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:melton_app/api/api.dart';
import 'package:melton_app/models/UserRegistrationStatusModel.dart';
import 'package:melton_app/screens/authorization_wall.dart';
import 'package:melton_app/screens/splash.dart';
import 'package:melton_app/util/secrets.dart';
import 'package:melton_app/util/persistent_storage.dart';
import 'package:melton_app/main.dart';
import 'package:melton_app/screens/main_home.dart';

import 'package:melton_app/constants/constants.dart' as Constants;
import 'package:melton_app/util/token_handler.dart';

import 'package:melton_app/screens/components/sign_up.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ["email", "profile"]);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Constants.meltonYellowAccent, Constants.meltonGreenAccent]//, Constants.meltonBlueAccent, Constants.meltonGreenAccent],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              WelcomeText("WELCOME TO THE MELTON APP!"),
              WelcomeText("Let's get started!"),
              WelcomeText("Only Melton Fellows can use this app. "),
              WelcomeText("Your data is used solely by the Melton Foundation. For more details see: meltonapp.com/privacy"),
              RaisedButton(onPressed: () {
                triggerLogin();
              },
              child: Text("SIGN IN WITH GOOGLE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              color: Constants.meltonYellow,
              splashColor: Constants.meltonRed,
              ),
              RaisedButton(onPressed: () {
                triggerRegister();
              },
                child: Text("SIGN UP", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                color: Constants.meltonBlueAccent,
                splashColor: Constants.meltonRed,
              ),
            ],
          ),
        ),
      ),
    );
  }

  //todo use "signinsilently"
  Future<bool> triggerLogin() async {
    print('calling oauth');
    UserRegistrationStatusModel tokenOrUnauthorized = await oauthLoginAndGetAppToken();
    if (tokenOrUnauthorized?.appToken != null) {
      print('saving to storage');
      PersistentStorage storage = GetIt.I.get<PersistentStorage>();
      await storage.saveStringToStorage(TokenHandler.APP_TOKEN_KEY, tokenOrUnauthorized.appToken);
      await GetIt.I.get<TokenHandler>().refresh(storage);
      await Future.delayed(Duration(seconds: 3)); //todo remove?
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
        return MyHomePage();
      }));
    } else if (tokenOrUnauthorized?.isApproved == false) {
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return AuthorizationWall();
      }));
    } else {
      //todo error screen or again push login page
      await Future.delayed(Duration(seconds: 3));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
        return MyHomePage();
      }));
    }

  }

  Future<UserRegistrationStatusModel> oauthLoginAndGetAppToken() async {
    UserRegistrationStatusModel tokenOrUnauthorized;
    await _googleSignIn.signIn().then((result) async {
      await result.authentication.then((googleKey) async {
        print(googleKey.accessToken);
        log(googleKey.idToken); //todo cleanup
        print(result.email);
        tokenOrUnauthorized = await ApiService().getAppToken(result.email, googleKey.idToken);
      }).catchError((err) {
        print('oauth inner error'); //todo error screen
      });
    }).catchError((err) {
      print('oauth error occured'); //todo error screen
    });
    return tokenOrUnauthorized;
  }

  Future<String> triggerRegister() async {
    showModalBottomSheet(context: context, isScrollControlled: true,
        builder: (BuildContext context) {
      return SignUp();
    });
  }

}

class WelcomeText extends StatelessWidget {
  final String text;

  WelcomeText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,
      color: Colors.white),);
  }
}


