import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:state_change_demo/src/controllers/auth_controller.dart';
import 'package:state_change_demo/src/dialogs/waiting_dialog.dart';

// Define your RegisterScreen class here (not shown for brevity)

class LoginScreen extends StatefulWidget {
  static const String route = "/auth";
  static const String name = "Login Screen";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late GlobalKey<FormState> formKey;
  late TextEditingController username, password;
  late FocusNode usernameFn, passwordFn;

  bool obfuscate = true;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    username = TextEditingController(text: "mayaogino2002@gmail.com");
    password = TextEditingController(text: "Ogino@03292002");
    usernameFn = FocusNode();
    passwordFn = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    username.dispose();
    password.dispose();
    usernameFn.dispose();
    passwordFn.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text("Login"),
      ),
      bottomNavigationBar: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text("Register"),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: onSubmit,
              child: const Text("Login"),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: TextFormField(
                    decoration: decoration.copyWith(
                      labelText: "Username",
                      prefixIcon: const Icon(Icons.person),
                    ),
                    focusNode: usernameFn,
                    controller: username,
                    onEditingComplete: () {
                      passwordFn.requestFocus();
                    },
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'Please fill out the username'),
                      MaxLengthValidator(32, errorText: "Username cannot exceed 32 characters"),
                      EmailValidator(errorText: "Please enter a valid email"),
                    ]).call,
                  ),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: obfuscate,
                    decoration: decoration.copyWith(
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.password),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obfuscate = !obfuscate;
                          });
                        },
                        icon: Icon(
                          obfuscate ? Icons.remove_red_eye_rounded : CupertinoIcons.eye_slash,
                        ),
                      ),
                    ),
                    focusNode: passwordFn,
                    controller: password,
                    onEditingComplete: () {
                      passwordFn.unfocus();
                    },
                    validator: MultiValidator([
                      RequiredValidator(errorText: "Password is required"),
                      MinLengthValidator(11, errorText: "Password must be at least 11 characters long"),
                      MaxLengthValidator(128, errorText: "Password cannot exceed 72 characters"),
                      PatternValidator(
                        r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+?\-=[\]{};':,.<>]).*$",
                        errorText: 'Password must contain at least one symbol, one uppercase letter, one lowercase letter, and one number.',
                      ),
                    ]).call,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onSubmit() {
    if (formKey.currentState?.validate() ?? false) {
      WaitingDialog.show(
        context,
        future: AuthController.I.login(username.text.trim(), password.text.trim()),
      );
    }
  }

  final OutlineInputBorder _baseBorder = const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey),
    borderRadius: BorderRadius.all(Radius.circular(4)),
  );

  InputDecoration get decoration => InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        filled: true,
        fillColor: Colors.white,
        errorMaxLines: 3,
        disabledBorder: _baseBorder,
        enabledBorder: _baseBorder.copyWith(
          borderSide: const BorderSide(color: Colors.black87, width: 1),
        ),
        focusedBorder: _baseBorder.copyWith(
          borderSide: const BorderSide(color: Colors.blueAccent, width: 1),
        ),
        errorBorder: _baseBorder.copyWith(
          borderSide: const BorderSide(color: Colors.deepOrangeAccent, width: 1),
        ),
      );
}
