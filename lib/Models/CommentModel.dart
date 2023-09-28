class CommentModel {
  String? userId;
  String? post_Id;
  String? body;
  int? created_at;

  CommentModel({this.userId, this.post_Id, this.body, this.created_at});

  CommentModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_Id'];
    post_Id = json['post_Id'];
    body = json['body'];
    created_at = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_Id'] = this.userId;
    data['body'] = this.body;
    data['post_Id'] = this.post_Id;
    data['created_at'] = this.created_at;
    return data;
  }
}
