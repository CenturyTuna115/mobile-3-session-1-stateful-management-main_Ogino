import 'package:flutter/material.dart';
import 'package:state_change_demo/src/controllers/auth_controller.dart';
import 'package:state_change_demo/src/dialogs/waiting_dialog.dart';

class HomeScreen extends StatelessWidget {
  static const String route = '/home';
  static const String path = "/home";
  static const String name = "Home Screen";

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         bottomNavigationBar:  SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          height: 52,
          child: ElevatedButton(
            onPressed: () {
              WaitingDialog.show(context, future: AuthController.I.logout());
            },
            child: const Text("sign out"),
          ),
        ),
      ),
    
    body: const SafeArea(child: Text("Home")));
  }
}
