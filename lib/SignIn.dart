import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restro_app/Constants/DatabaseHelper.dart';
import 'package:flutter_restro_app/HomeScreen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  int mobileText = 0;
  TextEditingController mobileNoController = TextEditingController();
  var isLoading = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _databaseHelper.getUserCount().then((value) {
      if (value > 0) {
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        print('User is currently signed out!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/img/firebase.png",
              height: 200.0,
              width: 200.0,
            ),
            InkWell(
              onTap: () {
                signInWithGoogle();
              },
              child: Container(
                height: 60.0,
                width: double.infinity,
                margin: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(36.0),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20.0,
                    ),
                    Image.asset(
                      "assets/img/google.png",
                      height: 30.0,
                      width: 30.0,
                    ),
                    SizedBox(
                      width: 100.0,
                    ),
                    Text(
                      "Google",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            mobileText == 0
                ? Container()
                : Container(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: TextFormField(
                      controller: mobileNoController,
                      decoration: InputDecoration(
                        labelText: "Mobile Number",
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
            mobileText == 0
                ? InkWell(
                    onTap: () async {
                      setState(() {
                        mobileText = 1;
                      });
                    },
                    child: Container(
                      height: 60.0,
                      margin: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(36.0),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20.0,
                          ),
                          Icon(
                            Icons.phone,
                            size: 30.0,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 100.0,
                          ),
                          Text(
                            "Phone",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : InkWell(
                    onTap: () async {
                      setState(() {
                        isLoading = 1;
                      });
                      await auth.verifyPhoneNumber(
                        phoneNumber: "+91" + mobileNoController.text,
                        verificationCompleted:
                            (PhoneAuthCredential credential) async {
                          await auth
                              .signInWithCredential(credential)
                              .then((value) {
                            print("value ${value.user.phoneNumber}");
                            _databaseHelper.deleteUser();
                            _databaseHelper.addUser(value.user.uid,
                                value.user.displayName==null?"-":value.user.displayName, value.user.phoneNumber);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()));
                          });
                        },
                        verificationFailed: (FirebaseAuthException e) {
                          setState(() {
                            isLoading = 0;
                          });
                          if (e.code == 'invalid-phone-number') {
                            print('The provided phone number is not valid.');
                          }
                        },
                        codeSent: (String verificationId, int resendToken) {},
                        codeAutoRetrievalTimeout: (String verificationId) {},
                      );
                    },
                    child: isLoading == 0
                        ? Container(
                            height: 60.0,
                            margin: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(36.0),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20.0,
                                ),
                                Icon(
                                  Icons.phone,
                                  size: 30.0,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 100.0,
                                ),
                                Text(
                                  "Verify",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential

    print("credential $credential");
    await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      _databaseHelper.deleteUser();
      _databaseHelper.addUser(value.user.uid,
          value.user.displayName, value.user.phoneNumber==null?"00":value.user.phoneNumber);
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    });
  }
}
