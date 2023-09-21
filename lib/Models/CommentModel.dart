class CommentModel {
  String? userId;
  String? post_Id;
  String? body;

  CommentModel({this.userId, this.post_Id, this.body});

  CommentModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_Id'];
    post_Id = json['post_Id'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_Id'] = this.userId;
    data['body'] = this.body;
    data['post_Id'] = this.post_Id;
    return data;
  }
}
