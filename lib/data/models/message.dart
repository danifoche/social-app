class Message {
  int? id;
  String? message;
  bool? isMe;

  Message({this.id, this.message, this.isMe});

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    isMe = json['isMe'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['message'] = message;
    data['isMe'] = isMe;
    return data;
  }
}