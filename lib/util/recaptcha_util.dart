import 'package:alicsnet_app/util/api_util.dart';
import 'package:g_recaptcha_v3/g_recaptcha_v3.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

bool get isIOS => !kIsWeb && Platform.isIOS;
bool get isAndroid => !kIsWeb && Platform.isAndroid;
bool get isWeb => kIsWeb;

class RecaptchaUtil {

  static Future<void> initiate() async {
    if (!isWeb) return;
    await GRecaptchaV3.ready("6Le-di0hAAAAANzDwQ0Tn29KJ1ve0AQYJR7SmCQ2"); //--2
    /*
    bool ready = await GRecaptchaV3.ready("<your Recaptcha site key>"); //--2
    print("Is Recaptcha ready? $ready");
     */
  }

  static Future<String> getVerificationResponse(String action) async {
    if (!isWeb) {
      var json = {
        "apiStatus": "success",
        "apiMessage": "success",
        "data": {
          "isNotABot": true,
          "action": "submit",
          "score": 0.9,
          "hostname": "app.alicsnet.com",
          "challengeTs": "2022-08-04T07:50:16Z"
        }
      };
      return json.toString();
    }

    String token = await GRecaptchaV3.execute(action) ?? ''; //--3
    return await APIUtil.recaptchaSiteverify('6Le-di0hAAAAADefkB7Hg-EckWVF6vA8ZmA2Nexb', token);
  }



}
