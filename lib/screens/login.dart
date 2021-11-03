import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:prezent/constants.dart';
import 'package:prezent/screens/main_screen.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _controller = TextEditingController();
  bool exists = false;
  bool codeSent = false;
  String? verId;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextFormField(
              keyboardType: TextInputType.number,
              maxLength: codeSent ? 6 : 10,
              controller: _controller,
              decoration: InputDecoration(
                  counterText: "",
                  label: codeSent
                      ? const Text("Enter Code")
                      : const Text("Enter Phone Number"),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  )),
            ),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                        onPressed: () async {
                          var phone = _controller.text.trim().toString();

                          if (!codeSent) {
                            var uri = Uri.parse(
                                "${Constants().serverUrl}/exists/$phone");
                            var response = await http.get(uri);
                            exists = response.statusCode == 200 ? true : false;

                            if (exists) {
                              if (phone.length == 10) {
                                verifyPhone(phone);
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("User Not Found")));
                            }
                          } else {
                            if (phone.length == 6) {
                              logIn(phone);
                            }
                          }
                        },
                        child: codeSent
                            ? const Text("LogIn")
                            : const Text("Send OTP")))
              ],
            )
          ],
        ),
      ),
    ));
  }

  void verifyPhone(String phoneNumber) async {
    await auth.verifyPhoneNumber(
      phoneNumber: "+91$phoneNumber",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential).then((value) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => const MainScreen()));
        });
      },
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _controller.text = "";
          codeSent = true;
          verId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void logIn(String smsCode) async {
    PhoneAuthCredential credential =
        PhoneAuthProvider.credential(verificationId: verId!, smsCode: smsCode);
    await auth.signInWithCredential(credential).then((value) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => const MainScreen()),
          (route) => false);
    });
  }
}
