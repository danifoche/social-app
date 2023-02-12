import 'package:social_app_bloc/data/models/message.dart';
import 'package:social_app_bloc/data/providers/chat_message_api.dart';
import 'package:social_app_bloc/data/providers/pusher_api.dart';

class PusherRepository {

  final PusherApi _pusherApi = PusherApi();

  //? Funzione che serve per connettermi con il websocket pusher
  Future<Map<String, dynamic>?> init(String socketId, String channelName, String token) async => _pusherApi.init(socketId, channelName, token);

}