import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  // Future getUserProfile() async {
  //   var phoneNumber =
  //   FirebaseAuth.instance.currentUser!.phoneNumber.toString().substring(3);
  //   var res = http.get(
  //       Uri.parse("http://172.20.10.5:3000/profile/$phoneNumber"));
  // }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Row(
          children: const [
            Card(
              child: SizedBox(
                  width: 150,
                  height: 150,
                  child: Image(
                    image: AssetImage("assets/defaultUserPic.png"),
                  )),
            )
          ],
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
