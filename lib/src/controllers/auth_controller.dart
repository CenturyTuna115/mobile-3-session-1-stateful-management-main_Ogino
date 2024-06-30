import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:state_change_demo/src/enum/enum.dart';

class AuthController with ChangeNotifier {
  // Static method to initialize the singleton in GetIt
  static void initialize() {
    GetIt.instance.registerSingleton<AuthController>(AuthController());
  }

  // Static getter to access the instance through GetIt
  static AuthController get instance => GetIt.instance<AuthController>();

  static AuthController get I => GetIt.instance<AuthController>();

  late StreamSubscription<User?>currentAuthedUser;

  AuthState state = AuthState.unauthenticated;



  listen(){
    currentAuthedUser = FirebaseAuth.instance.authStateChanges().listen(handleUserChanges);
  }

  void handleUserChanges(User? user){
    if(user == null){
      state = AuthState.unauthenticated;
    }
    else{
      state = AuthState.authenticated;
    }
    notifyListeners();
  }



  login(String userName, String password) async {
    UserCredential userCredential = await FirebaseAuth.instance
    .signInWithEmailAndPassword(email: userName, password: password);
    //User? user = userCredential.user
  }

  ///write code to log out the user and add it to the home page.
  logout() {
    return FirebaseAuth.instance.signOut();
    //should clear session
  }

  ///must be called in main before runApp
  ///
  loadSession() async {
    listen();
    User? user = FirebaseAuth.instance.currentUser;
    handleUserChanges(user);
    //check secure storage method
  }

  register(String email, String password) {}

  ///https://pub.dev/packages/flutter_secure_storage or any caching dependency of your choice like localstorage, hive, or a db
}

class SimulatedAPI {
}