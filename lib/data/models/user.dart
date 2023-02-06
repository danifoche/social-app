import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class User extends Equatable {
  
  int? userId;
  String? username;
  String? email;
  String? websocketId;
  String? accessToken;
  String? image;

  User(
      {this.userId,
      this.username,
      this.email,
      this.websocketId,
      this.accessToken,
      this.image});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['id'];
    username = json['username'];
    email = json['email'];
    websocketId = json['websocket_id'];
    accessToken = json['access_token'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = userId;
    data['username'] = username;
    data['email'] = email;
    data['websocket_id'] = websocketId;
    data['access_token'] = accessToken;
    data['image'] = image;
    return data;
  }

  @override
  List<Object?> get props => [userId, username, email, websocketId, accessToken, image];
}
