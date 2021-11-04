class PUser {
  String _id;
  String? profilepicture;
  String username;
  String fullname;
  String? email;
  int? followingCount;
  int? followersCount;
  int? numberofpost;

  PUser(this._id, this.profilepicture, this.username, this.fullname,this.email,
      this.followingCount, this.followersCount, this.numberofpost);

  factory PUser.fromJson(Map<String, dynamic> json) {
    return PUser(
        json["_id"],
        json["profilepicture"],
        json["username"],
        json["fullname"],
        json["emailaddress"],
        json["followingCount"],
        json["followersCount"],
        json["numberofpost"]);
  }
}
