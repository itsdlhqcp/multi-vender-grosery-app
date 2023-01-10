import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_grocery_shop/vendor/provider/cart_provider.dart';
import 'package:multi_grocery_shop/views/screens/auth/customer_login_screen.dart';
import 'package:multi_grocery_shop/views/screens/customer_tab/cus_shipping.dart';

import 'package:multi_grocery_shop/views/screens/edit_profile_screen.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    CollectionReference users = FirebaseFirestore.instance.collection('buyers');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
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
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                'Profile',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      FontAwesomeIcons.moon,
                      color: Colors.yellow.shade900,
                    ),
                  ),
                ),
              ],
            ),
            body: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: CircleAvatar(
                      radius: 65,
                      backgroundImage: NetworkImage(data['profileImage']),
                    ),
                  ),
                  Text(
                    '${data['fullName']}'.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${data['email']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.yellow.shade900,
                        ),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return EditProfileScreen(
                              userData: data,
                            );
                          }));
                        },
                        child: Text(
                          'Edit Profile',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Icon(Icons.settings),
                    ),
                    title: Text(
                      'Settings',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Icon(Icons.phone),
                    ),
                    title: Text(
                      'Phone',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                      ),
                    ),
                    subtitle: Text(
                      data['phoneNumber'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Icon(FontAwesomeIcons.cartPlus),
                    ),
                    title: Text(
                      'Cart',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CusShippingScreen();
                      }));
                    },
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Icon(FontAwesomeIcons.cartShopping),
                    ),
                    title: Text(
                      'Orders',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () async {
                      await FirebaseAuth.instance.signOut().whenComplete(() {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return CustomerLoginScreen();
                        })).whenComplete(() {
                          _cartProvider.clearCart();
                        });
                      });
                    },
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Icon(Icons.logout),
                    ),
                    title: Text(
                      'Logout',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                        color: Colors.yellow.shade900,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }

        return Center(
          child: CircularProgressIndicator(
            color: Colors.blueGrey,
          ),
        );
      },
    );

    // return FutureBuilder<DocumentSnapshot>(
    //   future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
    //   builder:
    //       (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    //     if (snapshot.hasError) {
    //       return Text("Something went wrong");
    //     }

    //     if (snapshot.hasData && !snapshot.data!.exists) {
    //       return Text("Document does not exist");
    //     }

    //     if (snapshot.connectionState == ConnectionState.done) {
    //       Map<String, dynamic> data =
    //           snapshot.data!.data() as Map<String, dynamic>;
    //       return Scaffold(
    //         body: CustomScrollView(
    //           slivers: [
    //             SliverAppBar(
    //               automaticallyImplyLeading: false,
    //               toolbarHeight: 200,
    //               flexibleSpace: LayoutBuilder(
    //                 builder: (context, constraints) {
    //                   return FlexibleSpaceBar(
    //                     background: Container(
    //                       decoration: BoxDecoration(
    //                         gradient: LinearGradient(
    //                           colors: [
    //                             Colors.yellow.shade900,
    //                             Colors.yellow.shade900,
    //                           ],
    //                         ),
    //                       ),
    //                       child: Padding(
    //                         padding: const EdgeInsets.all(10.0),
    //                         child: Column(
    //                           mainAxisAlignment: MainAxisAlignment.center,
    //                           children: [
    //                             CircleAvatar(
    //                               radius: 65,
    //                               backgroundImage:
    //                                   NetworkImage(data['profileImage']),
    //                             ),
    //                             SizedBox(
    //                               height: 14,
    //                             ),
    //                             Text(
    //                               '${data['fullName']}'.toUpperCase(),
    //                               style: TextStyle(
    //                                 color: Colors.white,
    //                                 fontSize: 20,
    //                                 fontWeight: FontWeight.bold,
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                     ),
    //                   );
    //                 },
    //               ),
    //             ),
    //             SliverToBoxAdapter(
    //               child: Padding(
    //                 padding: const EdgeInsets.all(10.0),
    //                 child: Column(
    //                   children: [
    //                     Text(
    //                       'Account Info',
    //                       style: TextStyle(
    //                         fontSize: 25,
    //                         fontWeight: FontWeight.bold,
    //                       ),
    //                     ),
    //                     SizedBox(
    //                       height: 10,
    //                     ),
    //                     ListTile(
    //                       leading: Icon(
    //                         Icons.email,
    //                       ),
    //                       title: Text(
    //                         'Email Address',
    //                       ),
    //                       subtitle: Text('${data['email']}'),
    //                     ),
    //                     ListTile(
    //                       leading: Icon(Icons.phone),
    //                       title: Text(
    //                         'Phone Number',
    //                       ),
    //                       subtitle: Text(
    //                         '${data['phone']}',
    //                       ),
    //                     ),
    //                     ListTile(
    //                       leading: Icon(
    //                         CupertinoIcons.cart_badge_plus,
    //                       ),
    //                       title: Text(
    //                         'Cart',
    //                       ),
    //                       trailing: Icon(
    //                         Icons.arrow_forward,
    //                       ),
    //                       onTap: () {
    //                         Navigator.push(context,
    //                             MaterialPageRoute(builder: (context) {
    //                           return CartScreen();
    //                         }));
    //                       },
    //                     ),
    //                     ListTile(
    //                       leading: Icon(
    //                         Icons.shop,
    //                       ),
    //                       title: Text(
    //                         'My Orders',
    //                       ),
    //                       trailing: Icon(
    //                         Icons.arrow_forward,
    //                       ),
    //                     ),
    //                     ListTile(
    //                       leading: Icon(Icons.logout),
    //                       title: Text('Logout'),
    //                       trailing: Icon(
    //                         Icons.arrow_forward,
    //                       ),
    //                       onTap: () async {
    //                         await FirebaseAuth.instance
    //                             .signOut()
    //                             .whenComplete(() {
    //                           Navigator.push(context,
    //                               MaterialPageRoute(builder: (context) {
    //                             return CustomerLoginScreen();
    //                           }));
    //                         });
    //                       },
    //                     )
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       );
    //     }

    //     return Center(
    //       child: CircularProgressIndicator(
    //         color: Colors.blueGrey,
    //       ),
    //     );
    //   },
    // );
  }
}
