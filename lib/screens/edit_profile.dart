
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prezent/classes/p_user.dart';

class EditProfileScreen extends StatefulWidget {
  PUser pUser;

  EditProfileScreen({Key? key, required this.pUser}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: const Text("Edit Profile"),
          ),
          body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Container(
                      width: 125,
                      height: 125,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage("assets/defaultUserPic.png"),
                          )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      initialValue: widget.pUser.username,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          label: Text("Username"),
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      initialValue: widget.pUser.fullname,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          label: Text("Fullname"),
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      initialValue: widget.pUser.email,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          label: Text("Email"), border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      initialValue: widget.pUser.numberofpost.toString(),
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          label: Text("Phone"), border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(children: const [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: null, child: Text("Save")),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
