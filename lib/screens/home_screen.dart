import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:prezent/classes/p_post.dart';
import 'package:prezent/classes/p_user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin<HomeScreen> {
  late PUser user;

  Future getUser() async {
    var phoneNumber =
        FirebaseAuth.instance.currentUser!.phoneNumber.toString().substring(3);
    var res =
        await http.get(Uri.parse("http://172.20.10.5:3000/user/$phoneNumber"));
    if (res.statusCode == 200) {
      user = PUser.fromJson(const JsonDecoder().convert(res.body));
      return true;
    } else {
      return Future.error("error");
    }
  }

  Future getHome() async {
    List<Post> list = [];

    var res = await http
        .get(Uri.parse("http://172.20.10.5:3000/${user.username}/home"));
    try {
      (json.decode(res.body)).forEach((element) {
        list.add(Post(
            element["_id"],
            element["numberoflikes"],
            element["numberofcomments"],
            (element["hashtages"] as List<dynamic>)
                .map((e) => e.toString())
                .toList(),
            element["timestamp"],
            element["userName"],
            element["type"],
            element["data"],
            element["userDetail"]));
      });
    } catch (e) {
      print(e);
    }

    return list;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
        future: getUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return FutureBuilder(
                future: getHome(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    List<Post> posts = (snapshot.data as List<Post>);
                    return ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          var post = posts[index];
                          return Card(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.person),
                                      Text(post.userName),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: double.infinity,
                                  height: 300,
                                  child: Icon(
                                    Icons.image,
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  } else {
                    return const Center(
                        child: SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator()));
                  }
                });
          } else {
            return const Center(
                child: SizedBox(
                    width: 50, height: 50, child: CircularProgressIndicator()));
          }
        });
  }
}
