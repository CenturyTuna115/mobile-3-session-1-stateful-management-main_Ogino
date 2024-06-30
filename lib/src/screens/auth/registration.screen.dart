import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:state_change_demo/src/controllers/auth_controller.dart';
import 'package:state_change_demo/src/dialogs/waiting_dialog.dart';

class RegistrationScreen extends StatefulWidget {
  static const String route = "/register";
  static const String name = "Registration Screen";

  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(RegistrationScreen.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: MultiValidator([
                  RequiredValidator(errorText: 'Email is required'),
                  EmailValidator(errorText: 'Enter a valid email address'),
                ]),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscurePassword,
                validator: MultiValidator([
                  RequiredValidator(errorText: 'Password is required'),
                  MinLengthValidator(6,
                      errorText: 'Password must be at least 6 characters long'),
                ]),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscureConfirmPassword,
                validator: (val) {
                  if (val != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  _registerUser();
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _registerUser() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      // Call Firebase registration method (Example: Using AuthController for Firebase authentication)
      try {
        WaitingDialog.show(context, future: AuthController.I.register(email, password));
        // You can handle success and navigate to another screen here
      } catch (e) {
        // Handle registration failure (e.g., display error message)
        print('Registration error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed. Please try again.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
