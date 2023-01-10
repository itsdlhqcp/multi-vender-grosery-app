import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_grocery_shop/controllers/auth_controllers.dart';
import 'package:multi_grocery_shop/utils/show_snack.dart';
import 'package:multi_grocery_shop/vendor/auth/vendor_login_screen.dart';
import 'package:multi_grocery_shop/views/screens/auth/customer_login_screen.dart';

class CustomerRegisterScreen extends StatefulWidget {
  @override
  State<CustomerRegisterScreen> createState() => _CustomerRegisterScreenState();
}

class _CustomerRegisterScreenState extends State<CustomerRegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();
  bool _isLoading = false;

  late String email;
  late String fullName;
  late String phone;
  late String password;

  Uint8List? _image;

  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();

    XFile? _file = await _imagePicker.pickImage(source: source);

    if (_file != null) {
      return _file.readAsBytes();
    } else {
      print('NO IMAGE SELECTED');
    }
  }

  pickImageFromGallery() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  _signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      await _authController
          .signUpUSers(email, fullName, phone, password, _image)
          .whenComplete(() {
        setState(() {
          _image = null;
          _formKey.currentState!.reset();
          _isLoading = false;
        });
      });

      return showSnack(
          context, 'Congratulations Account has been Created For You');
    } else {
      setState(() {
        _isLoading = false;
      });
      return showSnack(context, 'Please Fields must not be empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Center(
                child: Text(
                  'Create an Account',
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
              ),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          backgroundColor: Colors.yellow.shade900,
                          radius: 65,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : CircleAvatar(
                          backgroundColor: Colors.yellow.shade900,
                          radius: 65,
                          backgroundImage: NetworkImage(
                            'https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png',
                          ),
                        ),
                  Positioned(
                    left: 90,
                    top: 10,
                    child: IconButton(
                      onPressed: () {
                        pickImageFromGallery();
                      },
                      icon: Icon(CupertinoIcons.photo),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Emaill addresss must not be empty';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Email Adress',
                  ),
                  onChanged: (value) {
                    email = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please full name must not be empty";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Full Name',
                  ),
                  onChanged: (value) {
                    fullName = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please phone number must not be empty";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Phone Number',
                  ),
                  onChanged: (value) {
                    phone = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please password must not be empty";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Password',
                  ),
                  onChanged: (value) {
                    password = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () {
                    _signUpUser();
                  },
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade900,
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    child: Center(
                        child: _isLoading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'Register',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              )),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an Account ?'),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: ((context) {
                          return CustomerLoginScreen();
                        })));
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.yellow.shade900,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Create a Vendor account ?'),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: ((context) {
                          return VendorLoginScreen();
                        })));
                      },
                      child: Text(
                        'Create',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.yellow.shade900,
                          fontWeight: FontWeight.bold,
                        ),
                      ))
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
