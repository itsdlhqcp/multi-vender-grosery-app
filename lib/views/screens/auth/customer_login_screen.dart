import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_grocery_shop/controllers/auth_controllers.dart';
import 'package:multi_grocery_shop/utils/show_snack.dart';
import 'package:multi_grocery_shop/views/screens/auth/customer_register.dart';
import 'package:multi_grocery_shop/views/screens/main_screen.dart';

class CustomerLoginScreen extends StatefulWidget {
  @override
  State<CustomerLoginScreen> createState() => _CustomerLoginScreenState();
}

class _CustomerLoginScreenState extends State<CustomerLoginScreen> {
  final AuthController _authController = AuthController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String email;

  late String password;

  bool _isLoading = false;

  _loginUsers() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      String res = await _authController.loginUsers(email, password);
      if (res == 'success') {
        return Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return MainScreen();
        }));
      } else {
        setState(() {
          _isLoading = false;
        });
        return showSnack(context, res);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      return showSnack(context, 'Please feidls most not be empty');
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Login Account',
              style: TextStyle(
                fontSize: 22,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Email Address must not be empty';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                hintText: 'Email Address',
              ),
              onChanged: (value) {
                email = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              obscureText: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Password must not be empty';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                hintText: 'Pasword',
              ),
              onChanged: (value) {
                password = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                _loginUsers();
              },
              child: Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.yellow.shade900,
                  borderRadius: BorderRadius.circular(
                    15,
                  ),
                ),
                child: Center(
                  child: _isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Need  an Account ?'),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: ((context) {
                      return CustomerRegisterScreen();
                    })));
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.yellow.shade900,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ))
            ],
          )
        ],
      ),
    ));
  }
}
