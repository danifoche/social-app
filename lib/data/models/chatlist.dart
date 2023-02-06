class ChatList {
  int? id;
  String? name;
  String? websocketId;
  List<int>? members;
  String? lastMessage;
  String? lastMessageTs;
  bool? newMessage;
  String? image;

  ChatList({
    this.id,
    this.name,
    this.websocketId,
    this.members,
    this.lastMessage,
    this.lastMessageTs,
    this.newMessage,
    this.image,
  });

  ChatList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    websocketId = json['websocket_id'];
    members = json['members'].cast<int>();
    lastMessage = json['last_message'];
    lastMessageTs = json['last_message_ts'];
    newMessage = json['new_message'];
    image = json['group_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['websocket_id'] = websocketId;
    data['members'] = members;
    data['last_message'] = lastMessage;
    data['last_message_ts'] = lastMessageTs;
    data['new_message'] = newMessage;
    data['image'] = image;
    return data;
  }
}
