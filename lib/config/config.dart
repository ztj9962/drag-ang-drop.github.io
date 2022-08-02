/// A Configuration Class that holds the `Google reCAPTCHA v3` API Confidential Information.
class Config {

  /// Prevents from object instantiation.
  Config._();

  /// Holds the 'Site Key' for the `Google reCAPTCHA v3` API .
  static const String siteKey = '6Le-di0hAAAAANzDwQ0Tn29KJ1ve0AQYJR7SmCQ2';

  /// Holds the 'Secret Key' for the `Google reCAPTCHA v3` API .
  static const String secretKey = '6Le-di0hAAAAADefkB7Hg-EckWVF6vA8ZmA2Nexb';

  /// Holds the 'Verfication URL' for the `Google reCAPTCHA v3` API .
  static final verificationURL =
  Uri.parse('https://www.google.com/recaptcha/api/siteverify');
}