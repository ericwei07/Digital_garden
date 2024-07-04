import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StarterPageController {
  var tokenValid = false;

  Future<void> checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('accessToken');
    if (token == null || token == '') {
      return;
    }
    final jwt = JWT.decode(token);
    final exp = jwt.payload['exp'];
    final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    final currentTime = DateTime.now();
    if (expiryDate.difference(currentTime).inSeconds > 0) {
      tokenValid = true;
    }
    return;
  }
}
