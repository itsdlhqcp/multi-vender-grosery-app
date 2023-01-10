import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:uuid/uuid.dart';

class WithdrawEarnins extends StatefulWidget {
  @override
  State<WithdrawEarnins> createState() => _WithdrawEarninsState();
}

class _WithdrawEarninsState extends State<WithdrawEarnins> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late int amount;
  late String bankName;

  late String bankAccountName;

  late String bankAccountNumber;

  late String withdrewId;

  @override
  Widget build(BuildContext context) {
    CollectionReference _vendor =
        FirebaseFirestore.instance.collection('vendors');
    return FutureBuilder<DocumentSnapshot>(
      future: _vendor.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              title: Text(
                'Withdrew',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 80,
                      ),
                      Text(
                        'Withdrew',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        onChanged: (value) {
                          amount = int.parse(value);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Field must not be empty';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'amount to Withdrew',
                          labelText: 'amount to Withdrew',
                        ),
                      ),
                      TextFormField(
                        onChanged: (value) {
                          bankName = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Field must not be empty';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Bank Name',
                          labelText: 'Bank Name',
                        ),
                      ),
                      TextFormField(
                        onChanged: (value) {
                          bankAccountName = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Field must not be empty';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Bank Account Name',
                          labelText: 'Bank Account Name',
                        ),
                      ),
                      TextFormField(
                        onChanged: (value) {
                          bankAccountNumber = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Field must not be empty';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Bank Account Number',
                          labelText: 'Bank Account Number',
                        ),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            EasyLoading.show();

                            CollectionReference withdrewRef =
                                _firestore.collection('withdrawal');
                            withdrewId = Uuid().v4();

                            withdrewRef.doc(withdrewId).set({
                              'withdrewId': withdrewId,
                              'amount': amount,
                              'name': data['bussinessName'],
                              'email': data['email'],
                              'phone': data['mobile'],
                              'bankName': bankName,
                              'bankAccountName': bankAccountName,
                              'BankAccountNumber': bankAccountNumber,
                            }).whenComplete(() {
                              setState(() {
                                setState(() {
                                  _formKey.currentState!.reset();
                                  EasyLoading.dismiss();
                                });
                              });
                            });
                          } else {
                            EasyLoading.dismiss();
                          }
                        },
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width - 40,
                          decoration: BoxDecoration(
                            color: Colors.yellow.shade900,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'COLLECT',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return Material(
            child: Center(
          child: CircularProgressIndicator(
            color: Colors.yellow.shade900,
          ),
        ));
      },
    );
  }
}
