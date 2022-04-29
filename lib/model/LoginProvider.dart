import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:userproject/model/ConnectAPI.dart';


//userlogin
class LoginProvider {
  LoginProvider();
  Future<http.Response> doLogin(String username, String password) async { 
    String url = '${Connectapi().domain}/login';
    var body = { 
    'username': username,
    'password': password,
    };
    return http.post(Uri.parse(url), body: body);

  }
}