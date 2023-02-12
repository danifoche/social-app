import 'dart:convert';

import 'package:social_app_bloc/settings/make_api_call.dart';

class PusherApi {
  final MakeApiCall _makeApiCall = MakeApiCall();

  //? Funzione che serve per collegarmi al websocket pusher
  Future<Map<String, dynamic>?> init(String socketId, String channelName, String token) async {

    //? Endpoint per collegarsi a pusher
    String endpoint = "/auth/pusher";

    //? Dati che servono alla request
    Map<String, dynamic> requestData = {
      "socket_id": socketId,
      "channel_name": channelName
    };

    String response = await _makeApiCall.makePostRequest(jsonEncode(requestData), endpoint, token);
    
    return jsonDecode(response);
  }
}
