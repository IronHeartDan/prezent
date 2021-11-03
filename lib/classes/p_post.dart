class Post {
  String _id;
  int numberOfLikes;
  int numberOfComments;
  List<String> hashTags;
  String timeStamp;
  String userName;
  int type;
  String data;
  Map<String, dynamic> userDetail;

  Post(this._id, this.numberOfLikes, this.numberOfComments,this.hashTags,
      this.timeStamp, this.userName, this.type, this.data, this.userDetail);
}