import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prezent/classes/p_user.dart';
import 'package:http/http.dart' as http;
import 'package:prezent/constants.dart';

class EditProfileScreen extends StatefulWidget {
  PUser pUser;

  EditProfileScreen({Key? key, required this.pUser}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _controllerUsername = TextEditingController(),
      _controllerFullname = TextEditingController(),
      _controllerEmail = TextEditingController(),
      _controllerPhone = TextEditingController();
  bool isChanged = false;

  @override
  void initState() {
    setState(() {
      _controllerEmail.text = widget.pUser.email!;
      _controllerUsername.text = widget.pUser.username;
      _controllerPhone.text = widget.pUser.numberofpost!.toString();
      _controllerFullname.text = widget.pUser.fullname;
    });
    super.initState();
  }

  void OnChange() {
    if (_controllerEmail.text.trim().toString() != widget.pUser.email ||
        _controllerUsername.text.trim().toString() != widget.pUser.username ||
        _controllerFullname.text.trim().toString() != widget.pUser.fullname ||
        _controllerPhone.text.trim().toString() !=
            widget.pUser.numberofpost.toString()) {
      setState(() {
        isChanged = true;
      });
    } else {
      setState(() {
        isChanged = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: const Text("Edit Profile"),
            systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarBrightness: Brightness.light),
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
                      controller: _controllerUsername,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        OnChange();
                      },
                      decoration: const InputDecoration(
                          label: Text("Username"),
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _controllerFullname,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        OnChange();
                      },
                      decoration: const InputDecoration(
                          label: Text("Fullname"),
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _controllerEmail,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        OnChange();
                      },
                      decoration: const InputDecoration(
                          label: Text("Email"), border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _controllerPhone,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        OnChange();
                      },
                      decoration: const InputDecoration(
                          label: Text("Phone"), border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: isChanged
                                ? () async {
                                    var body = {
                                      "username": _controllerUsername.text
                                          .trim()
                                          .toString(),
                                      "fullname": _controllerFullname.text
                                          .trim()
                                          .toString(),
                                      "emailaddress": _controllerEmail.text
                                          .trim()
                                          .toString(),
                                      "numberofpost": _controllerPhone.text
                                          .trim()
                                          .toString()
                                    };
                                    var res = await http.patch(
                                        Uri.parse(
                                            "${Constants.serverUrl}/usercollection/${widget.pUser.id}"),
                                        headers: {
                                          "content-type": "application/json"
                                        },
                                        body: jsonEncode(body));
                                    if (res.statusCode == 200) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text("Sucess")));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Error ${res.statusCode}")));
                                    }
                                  }
                                : null,
                            child: const Text("Save")),
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
