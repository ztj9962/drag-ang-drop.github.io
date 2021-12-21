import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:async';

class authRespository {
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  /*
  static final FacebookAuth _facebookSignIn = FacebookAuth.instance;
  static final TwitterLogin _twitterLogin = new TwitterLogin(
      apiKey: "lG0aVgB0NnmnMWibaAyfEuiem",
      apiSecretKey: "5EATP6GGR8VCsOimxfn65pgduhCs8VDMjfZbPwY0ClAglUdYau",
      redirectURI: "myenglish-study.com://");
   */

  static Future<void> SendSignInWithEmailLink(String email) async {
    var acs = ActionCodeSettings(
      url: "https://selsapp.page.link/",
      handleCodeInApp: true,
      androidPackageName: "tw.nfs.selsapp.sels_app",
      iOSBundleId: "tw.nfs.selsapp.sels_app",
      androidInstallApp: true,
      dynamicLinkDomain: "selsapp.page.link",
      androidMinimumVersion: "9",
    );

    await _firebaseAuth
        .sendSignInLinkToEmail(
          email: email,
          actionCodeSettings: acs,
        )
        .catchError(
            (onError) => print('Error sending email verification $onError'))
        .then((value) => print('Successfully sent email verification'));
  }

  static Future<void> siginLink(Uri link, String email) async{
    if (link != null) {
      await _firebaseAuth
          .signInWithEmailLink(email: email, emailLink: link.toString())
          .then((value) {
        var userEmail = value.user;
        print('Successfully signed in with email link!');
      }).catchError((onError) {
        print('Error signing in with email link $onError');
      });
    }
  }

  static Future<void> signInWithApple()async{

    // 生成一個加密安全的隨機隨機數
    String generateNonce([int length = 32]) {
      final charset =
          '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
      final random = Random.secure();
      return List.generate(length, (_) => charset[random.nextInt(charset.length)])
          .join();
    }
    // 生成一個Sha256
    String sha256ofString(String input) {
      final bytes = utf8.encode(input);
      final digest = sha256.convert(bytes);
      return digest.toString();
    }

    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    await  _firebaseAuth.signInWithCredential(oauthCredential);

  }

  /*
  static Future<void> signInWithTwitter() async {
    SignOut();
    // Trigger the sign-in flow
    final authResult = await _twitterLogin.login();

    // Create a credential from the access token
    final twitterAuthCredential = TwitterAuthProvider.credential(
      accessToken: authResult.authToken!,
      secret: authResult.authTokenSecret!,
    );
    await FirebaseAuth.instance.signInWithCredential(twitterAuthCredential);
  }

   */

  static Future<void> signInWithGoogle() async {
    GoogleSignOut();
    final GoogleSignInAccount? googleAccount = await _googleSignIn.signIn();
    if (googleAccount != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleAccount.authentication;
      final AuthCredential credential = await GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      await _firebaseAuth.signInWithCredential(credential);
    }
  }

  /*
  static Future<void> signInWithFacebook() async {
    final LoginResult loginResult = await _facebookSignIn.login();
    OAuthCredential credential =
        await FacebookAuthProvider.credential(loginResult.accessToken!.token);
    await _firebaseAuth.signInWithCredential(credential);
  }

   */

  static Future<void> SignOut() async {
    Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
      //_facebookSignIn.logOut()
    ]);
  }

  static Future<void> GoogleSignOut() async {
    Future.wait([
      _googleSignIn.signOut(),
      _firebaseAuth.signOut(),
    ]);
  }

  /*
  static Future<void> FacebookSignOut() async {
    Future.wait([
      _facebookSignIn.logOut(),
      _firebaseAuth.signOut(),
    ]);
  }

   */

  static Future<bool> isSignedIn() async {
    try {
      final User? currentUser = _firebaseAuth.currentUser;
      if (currentUser != null) {
        return true;
      } else {
        return false;
      }
    } catch (_) {
      return false;
    }
  }

  static String getUid()  {
    String id = _firebaseAuth.currentUser!.uid.toString();
    return id;
  }
}
