import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:sels_app/sels_app/Utils/SharedPreferencesUtil.dart';

class APIUtil {

  static Future<String> getSentences(String sentenceLevel, {String sentenceTopic :'', String sentenceClass:'', String aboutWord:'', String sentenceMinLength:'', String sentenceMaxLength:'', var sentenceRanking:'', String dataLimit:''}) async {
    final response = await http.post(
      Uri.https('sels.nkfust.edu.tw', 'app/sentence/getSentences'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'sentenceLevel': sentenceLevel,
        'sentenceTopic': sentenceTopic,
        'sentenceClass': sentenceClass,
        'aboutWord': aboutWord,
        'sentenceMinLength': sentenceMinLength,
        'sentenceMaxLength': sentenceMaxLength,
        'sentenceRanking': sentenceRanking,
        'dataLimit': dataLimit,
      },
    );
    String json = response.body.toString();
    return json;
  }

  static Future<String> getSentencesByID(sentencesID) async {
    final response = await http.post(
      Uri.https('sels.nkfust.edu.tw', 'app/sentence/getSentencesByID'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'sentencesID': sentencesID.toString(),
      },
    );
    String json = response.body.toString();
    return json;
  }

  static Future<String> checkSentences(String questionText, String answerText, {int correctCombo:0}) async {
    final response = await http.post(
      Uri.https('sels.nkfust.edu.tw', 'app/sentence/checkSentences'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'questionText': questionText,
        'answerText': answerText,
        'correctCombo': correctCombo.toString(),
      },
    );
    String json = response.body.toString();
    return json;
  }


  static Future<String> checkGrammar(String sentenceText) async {
    final response = await http.post(
      Uri.https('sels.nkfust.edu.tw', 'app/grammar/checkGrammar'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'sentenceText': sentenceText,      },
    );
    String json = response.body.toString();
    return json;
  }


  static Future<String> sendMessageToConversation(String accessToken, String conversationID, String message) async {
    final response = await http.post(
      Uri.https('sels.nkfust.edu.tw', 'app/rasa/sendMessageToConversation'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'accessToken': accessToken,
        'conversationID': conversationID,
        'message': message,
      },
    );
    String json = response.body.toString();
    return json;
  }
  static Future<void> getConversationTokenAndID() async {
    final response = await http.get(
      Uri.https('sels.nkfust.edu.tw', 'app/rasa/getConversationTokenAndID'),
    );
    String json = response.body.toString();
    var data = jsonDecode(json.toString());
    if(data['apiStatus'] == 'success'){
      print(data['data']['accessToken']);
      SharedPreferencesUtil.saveData<String>('applicationSettingsDataAccessToken', data['data']['accessToken']);
      SharedPreferencesUtil.saveData<String>('applicationSettingsDataConversationID', data['data']['conversationID']);
    } else {
      print('_responseAPI Error apiStatus:' + data['apiStatus'] + ' apiMessage:' + data['apiMessage']);
      sleep(Duration(seconds:1));
      getConversationTokenAndID();
    }

  }

  static Future<String> getQuizHistory(String uuid) async {
    final response = await http.post(
      Uri.https('sels.nkfust.edu.tw', 'app/quiz/getQuizHistory'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'uuid': uuid,
      },
    );
    String json = response.body.toString();
    return json;
  }

  static Future<String> getQuizDataByID(quizID, String uuid) async {
    final response = await http.post(
      Uri.https('sels.nkfust.edu.tw', 'app/quiz/getQuizDataByID'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'quizID': quizID.toString(),
        'uuid': uuid,
      },
    );
    String json = response.body.toString();
    return json;
  }

  static Future<String> saveQuizData(String uuid, String quizTitle, List<int> sentenceIDArray, List<String> sentenceAnswerArray, List<int> scoreArray) async {
    final response = await http.post(
      Uri.https('sels.nkfust.edu.tw', 'app/quiz/saveQuizData'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'uuid': uuid,
        'quizTitle': quizTitle.substring(0, min(quizTitle.length, 30)),
        'sentenceIDArray': jsonEncode(sentenceIDArray),
        'sentenceAnswerArray': jsonEncode(sentenceAnswerArray),
        'scoreArray': jsonEncode(scoreArray),
      },
    );
    String json = response.body.toString();
    return json;
  }

  static Future<String> updateQuizData(String uuid, int quizID, List<int> sentenceIDArray, List<String> sentenceAnswerArray, List<int> scoreArray) async {
    final response = await http.post(
      Uri.https('sels.nkfust.edu.tw', 'app/quiz/updateQuizData'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'uuid': uuid,
        'quizID': quizID.toString(),
        'sentenceIDArray': jsonEncode(sentenceIDArray),
        'sentenceAnswerArray': jsonEncode(sentenceAnswerArray),
        'scoreArray': jsonEncode(scoreArray),
      },
    );
    String json = response.body.toString();
    return json;
  }


}