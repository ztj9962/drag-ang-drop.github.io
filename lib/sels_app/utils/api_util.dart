import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:sels_app/sels_app/utils/shared_preferences_util.dart';

class APIUtil {

  static Future<String> getSentences({String sentenceLevel :'', String sentenceTopic :'', String sentenceClass:'', String aboutWord:'', String sentenceMinLength:'', String sentenceMaxLength:'', String sentenceRanking:'', String sentenceRankingLocking:'', String dataLimit:''}) async {
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
        'sentenceRankingLocking': sentenceRankingLocking,
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

  static Future<String> getPhoneticExercisesSentencesByWordSet(String learningClassification, String learningPhase) async {
    final response = await http.post(
      Uri.https('sels.nkfust.edu.tw', 'app/sentence/getPhoneticExercisesSentencesByWordSet'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'learningClassification': learningClassification,
        'learningPhase': learningPhase,
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

  static Future<String> saveQuizData(String uuid, String quizTitle, List<int> sentenceIDArray, List<String> sentenceAnswerArray, List<int> scoreArray, List<int> secondsArray) async {
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
        'secondsArray': jsonEncode(secondsArray),
      },
    );
    String json = response.body.toString();
    return json;
  }

  static Future<String> updateQuizData(String uuid, int quizID, List<int> sentenceIDArray, List<String> sentenceAnswerArray, List<int> scoreArray, List<int> secondsArray) async {
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
        'secondsArray': jsonEncode(secondsArray),
      },
    );
    String json = response.body.toString();
    return json;
  }

  static Future<String> minimalPairOneFinder(ipa) async {
    final response = await http.post(
      Uri.https('sels.nkfust.edu.tw', 'app/minimalPair/oneFinder'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'ipa': ipa.toString(),
      },
    );
    String json = response.body.toString();
    return json;
  }

  static Future<String> minimalPairTwoFinder(ipa1, ipa2) async {
    final response = await http.post(
      Uri.https('sels.nkfust.edu.tw', 'app/minimalPair/twoFinder'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'ipa1': ipa1.toString(),
        'ipa2': ipa2.toString(),
      },
    );
    String json = response.body.toString();
    return json;
  }

  static Future<String> minimalPairWordFinder(word1) async {
    final response = await http.post(
      Uri.https('sels.nkfust.edu.tw', 'app/minimalPair/wordFinder'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'word1': word1.toString(),
      },
    );
    String json = response.body.toString();
    return json;
  }

  static Future<String> checkPronunciation(String questionText, String answerText) async {
    final response = await http.post(
      Uri.https('sels.nkfust.edu.tw', 'app/sentence/checkSentences'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'questionText': questionText,
        'answerText': answerText,
      },
    );
    String json = response.body.toString();
    return json;
  }

  static Future<String> getWordLearning(String learningClassification, String learningPhase) async {
    final response = await http.post(
      Uri.https('sels.nkfust.edu.tw', 'app/word/getWordLearning'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'learningClassification': learningClassification,
        'learningPhase': learningPhase,
      },
    );
    String json = response.body.toString();
    return json;
  }


  static Future<String> getWordSetList(String uid, String learningClassification) async {
    final response = await http.post(
      Uri.https('sels.nkfust.edu.tw', 'app/word/getWordSetList'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'uid': uid,
        'learningClassification': learningClassification,
      },
    );
    String json = response.body.toString();
    return json;
  }

  static Future<String> addWordSet(String uid, String learningClassification) async {
    final response = await http.post(
      Uri.https('sels.nkfust.edu.tw', 'app/word/addWordSet'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'uid': uid,
        'learningClassification': learningClassification,
      },
    );
    String json = response.body.toString();
    return json;
  }


  static Future<String> getSentenceTopicData() async {
    final response = await http.get(
      Uri.https('sels.nkfust.edu.tw', 'app/sentence/getSentenceTopicData'),
    );
    String json = response.body.toString();
    return json;
  }

  static Future<String> getWordSetClassificationData() async {
    final response = await http.get(
      Uri.https('sels.nkfust.edu.tw', 'app/word/getWordSetClassificationData'),
    );
    String json = response.body.toString();
    return json;
  }

  static Future<String> getWordSetTotalList(String index) async {
    final response = await http.post(
      Uri.https('sels.nkfust.edu.tw', 'app/word/getWordSetTotalList'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'index': index,
      },
    );
    String json = response.body.toString();
    return json;
  }


}