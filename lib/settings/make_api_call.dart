import 'package:dio/dio.dart';
import 'package:social_app_bloc/settings/app_settings.dart';

//? Classe che mi permette di fare una chiamata api senza riscrivere ogni volta tutta la procedura
class MakeApiCall {

  //? Fai una chiamata in post
  Future<dynamic> makePostRequest(String data, String endpoint, String? token) async {

    Response response = await Dio().post(
      appApiEndpoint + endpoint,
      data: data,
      options: Options(
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
        contentType: "application/json",
        headers: {
          "Accept": "application/json",
          "Authorization": token == null ? "" : "Bearer $token"
        },
      ),
    );

    return response.data;
  }

  //? Fai una chiamata in get
  Future<dynamic> makeGetRequest(String endpoint, String? token) async {

    Response response = await Dio().get(
      appApiEndpoint + endpoint,
      options: Options(
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
        contentType: "application/json",
        headers: {
          "Accept": "application/json",
          "Authorization": token!.isNotEmpty ? "Bearer $token" : ""
        },
      ),
    );

    return response.data;
  }

  //? Fai una chiamata delete
  Future<dynamic> makeDeleteRequest(String data, String endpoint, String? token) async {

    Response response = await Dio().delete(
      appApiEndpoint + endpoint,
      data: data,
      options: Options(
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
        contentType: "application/json",
        headers: {
          "Accept": "application/json",
          "Authorization": token == null ? "" : "Bearer $token"
        },
      ),
    );

    return response.data;

  }

}
