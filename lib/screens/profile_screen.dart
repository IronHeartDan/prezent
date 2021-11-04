import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:prezent/classes/p_sub_user.dart';
import 'package:prezent/classes/p_user.dart';
import 'package:prezent/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  late StreamController _streamControllerProfile;

  @override
  void initState() {
    _streamControllerProfile = StreamController();
    getUserProfile().then((value) => _streamControllerProfile.add(value));
    super.initState();
  }

  Future getUserProfile() async {
    var phoneNumber =
        FirebaseAuth.instance.currentUser!.phoneNumber.toString().substring(3);
    var res = await http
        .get(Uri.parse("${Constants.serverUrl}/profile/$phoneNumber"));
    return PUser.fromJson(json.decode(res.body));
  }

  Future getFollowing(PUser pUser) async {
    List<PSubUser> followings = [];
    var res = await http
        .get(Uri.parse("${Constants.serverUrl}/${pUser.username}/following"));
    try {
      json.decode(res.body).forEach((element) {
        followings.add(PSubUser.fromJson(element));
      });
    } catch (e) {
      print(e);
    }
    return followings;
  }

  Future getFollowers(PUser pUser) async {
    List<PSubUser> followings = [];
    var res = await http
        .get(Uri.parse("${Constants.serverUrl}/${pUser.username}/followers"));
    try {
      json.decode(res.body).forEach((element) {
        followings.add(PSubUser.fromJson(element));
      });
    } catch (e) {
      print(e);
    }
    return followings;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () {
          return getUserProfile();
        },
        child: StreamBuilder(
            stream: _streamControllerProfile.stream,
            builder: (context, snapshot) {
              PUser? pUser;
              if (snapshot.hasData) {
                pUser = (snapshot.data as PUser);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 75,
                                  height: 75,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: AssetImage(
                                            "assets/defaultUserPic.png"),
                                      )),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(pUser.username),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(pUser.fullname)
                              ],
                            ),
                            Expanded(
                                child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(pUser.numberofpost.toString()),
                                      const Text("Posts")
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {},
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Column(
                                                  children: [
                                                    const Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text("Followers"),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Expanded(
                                                      child: FutureBuilder(
                                                          future: getFollowers(
                                                              pUser!),
                                                          builder: (context,
                                                              snapshot) {
                                                            print(snapshot
                                                                .hasData);
                                                            print(
                                                                snapshot.data);
                                                            if (snapshot
                                                                    .hasData &&
                                                                snapshot.connectionState ==
                                                                    ConnectionState
                                                                        .done) {
                                                              List<PSubUser>
                                                                  followers =
                                                                  (snapshot.data
                                                                      as List<
                                                                          PSubUser>);
                                                              return ListView
                                                                  .builder(
                                                                      itemCount:
                                                                          followers
                                                                              .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        PSubUser
                                                                            follower =
                                                                            followers[index];
                                                                        return Card(
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(10.0),
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Container(
                                                                                  width: 40,
                                                                                  height: 40,
                                                                                  decoration: const BoxDecoration(
                                                                                      shape: BoxShape.circle,
                                                                                      image: DecorationImage(
                                                                                        fit: BoxFit.fill,
                                                                                        image: AssetImage("assets/defaultUserPic.png"),
                                                                                      )),
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 10,
                                                                                ),
                                                                                Text(follower.username),
                                                                                const Expanded(
                                                                                  child: Text(""),
                                                                                ),
                                                                                ElevatedButton(
                                                                                    onPressed: () async {
                                                                                      var res = await http.delete(Uri.parse("${Constants.serverUrl}/unfollow?id=${follower.id}"));
                                                                                      if (res.statusCode == 2000) {
                                                                                        setState(() {
                                                                                          followers.removeAt(index);
                                                                                        });
                                                                                      } else {
                                                                                        print("Err");
                                                                                      }
                                                                                    },
                                                                                    child: const Text("Remove"))
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        );
                                                                      });
                                                            } else {
                                                              return const Center(
                                                                  child:
                                                                      CircularProgressIndicator());
                                                            }
                                                          }),
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                        child: Column(
                                          children: [
                                            Text(pUser.followersCount
                                                .toString()),
                                            const Text("Followers")
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Column(
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text("Following"),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Expanded(
                                                  child: FutureBuilder(
                                                      future:
                                                          getFollowing(pUser!),
                                                      builder:
                                                          (context, snapshot) {
                                                        print(snapshot.hasData);
                                                        print(snapshot.data);
                                                        if (snapshot.hasData &&
                                                            snapshot.connectionState ==
                                                                ConnectionState
                                                                    .done) {
                                                          List<PSubUser>
                                                              followings =
                                                              (snapshot.data
                                                                  as List<
                                                                      PSubUser>);
                                                          return ListView
                                                              .builder(
                                                                  itemCount:
                                                                      followings
                                                                          .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    PSubUser
                                                                        following =
                                                                        followings[
                                                                            index];
                                                                    return Card(
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(10.0),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Container(
                                                                              width: 40,
                                                                              height: 40,
                                                                              decoration: const BoxDecoration(
                                                                                  shape: BoxShape.circle,
                                                                                  image: DecorationImage(
                                                                                    fit: BoxFit.fill,
                                                                                    image: AssetImage("assets/defaultUserPic.png"),
                                                                                  )),
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Text(following.username),
                                                                            const Expanded(
                                                                              child: Text(""),
                                                                            ),
                                                                            ElevatedButton(
                                                                                onPressed: () async {
                                                                                  var res = await http.delete(Uri.parse("${Constants.serverUrl}/unfollow?id=${following.id}"));
                                                                                  if (res.statusCode == 2000) {
                                                                                    setState(() {
                                                                                      followings.removeAt(index);
                                                                                    });
                                                                                  } else {
                                                                                    print("Err");
                                                                                  }
                                                                                },
                                                                                child: const Text("Unfollow"))
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  });
                                                        } else {
                                                          return const Center(
                                                              child:
                                                                  CircularProgressIndicator());
                                                        }
                                                      }),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(pUser.followingCount.toString()),
                                          const Text("Following")
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ))
                          ],
                        ),
                      ),
                      const Divider(
                        thickness: 2,
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
