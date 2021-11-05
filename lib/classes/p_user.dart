class PUser {
  String id;
  String? profilepicture;
  String username;
  String fullname;
  String? email;
  int? number;
  int? followingCount;
  int? followersCount;
  int? numberofpost;

  PUser(this.id, this.profilepicture, this.username, this.fullname, this.email,this.number,
      this.followingCount, this.followersCount, this.numberofpost);

  factory PUser.fromJson(Map<String, dynamic> json) {
    return PUser(
        json["_id"],
        json["profilepicture"],
        json["username"],
        json["fullname"],
        json["emailaddress"],
        json["phonenumber"],
        json["followingCount"],
        json["followersCount"],
        json["numberofpost"]);
  }
}
