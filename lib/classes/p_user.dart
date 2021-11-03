class PUser {
  String _id;
  String? profilepicture;
  String username;
  String fullname;

  PUser(this._id, this.profilepicture, this.username, this.fullname);

  factory PUser.fromJson(Map<String, dynamic> json) {
    return PUser(json["_id"], json["profilepicture"], json["username"],
        json["fullname"]);
  }
}
