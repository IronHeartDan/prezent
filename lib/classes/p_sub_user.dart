class PSubUser {
  String id;
  String? profilepicture;
  String username;

  PSubUser(this.id, this.profilepicture, this.username);

  factory PSubUser.fromJson(Map<String, dynamic> json) {
    return PSubUser(json["_id"], json["profilepicture"], json["username"]);
  }
}
