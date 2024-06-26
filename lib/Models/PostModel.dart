class PostModel {
  String? userId;
  List? like;
  Media? media;
  String? body;
  String? post_Id;
  int? created_at;
  String? sharedPost;

  PostModel(
      {this.userId,
      this.like,
      this.media,
      this.body,
      this.post_Id,
      this.created_at,
      this.sharedPost});

  PostModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_Id'];
    like = json['like'];
    media = json['media'] != null ? new Media.fromJson(json['media']) : null;
    body = json['body'];
    post_Id = json['post_Id'];
    created_at = json['created_at'];
    sharedPost = json['sharedPost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_Id'] = this.userId;
    data['like'] = this.like;
    if (this.media != null) {
      data['media'] = this.media!.toJson();
    }
    data['body'] = this.body;
    data['post_Id'] = this.post_Id;
    data['created_at'] = this.created_at;
    data['sharedPost'] = this.sharedPost;
    return data;
  }
}

class Media {
  List<dynamic>? imageUrl;
  String? videoUrl;

  Media({this.imageUrl, this.videoUrl});

  Media.fromJson(Map<String, dynamic> json) {
    imageUrl = json['imageUrl'];
    videoUrl = json['videoUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageUrl'] = this.imageUrl;
    data['videoUrl'] = this.videoUrl;
    return data;
  }
}
