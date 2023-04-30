import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:alicsnet_app/util/shared_preferences_util.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

bool get isIOS => !kIsWeb && Platform.isIOS;

bool get isAndroid => !kIsWeb && Platform.isAndroid;

bool get isWeb => kIsWeb;

class APIUtil {
  static Future<String> getSentences(
      {String sentenceLevel: '',
      String sentenceTopic: '',
      String sentenceClass: '',
      String aboutWord: '',
      String sentenceMinLength: '',
      String sentenceMaxLength: '',
      String sentenceRanking: '',
      String sentenceRankingLocking: '',
      String dataLimit: ''}) async {
    final response = await http.post(
      Uri.https(await SharedPreferencesUtil.getAPIURL(), 'app/sentence/getSentences'),
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
    print(json);
    return json;
  }

  static Future<String> checkSentences(String questionText, String answerText,
      {int correctCombo: 0}) async {
    final response = await http.post(
      Uri.https(await SharedPreferencesUtil.getAPIURL(), 'app/sentence/checkSentences'),
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
      Uri.https(await SharedPreferencesUtil.getAPIURL(), 'app/grammar/checkGrammar'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'sentenceText': sentenceText,
      },
    );
    String json = response.body.toString();
    return json;
  }

  static Future<String> saveQuizData(
      String uuid,
      String quizTitle,
      List<int> sentenceIDArray,
      List<String> sentenceAnswerArray,
      List<int> scoreArray,
      List<int> secondsArray) async {
    final response = await http.post(
      Uri.https(await SharedPreferencesUtil.getAPIURL(), 'app/quiz/saveQuizData'),
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

  static Future<String> updateQuizData(
      String uuid,
      int quizID,
      List<int> sentenceIDArray,
      List<String> sentenceAnswerArray,
      List<int> scoreArray,
      List<int> secondsArray) async {
    final response = await http.post(
      Uri.https(await SharedPreferencesUtil.getAPIURL(), 'app/quiz/updateQuizData'),
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

  static Future<String> minimalPairTwoFinder(ipa1, ipa2,
      {String dataLimit = ''}) async {
    final response = await http.post(
      Uri.https(await SharedPreferencesUtil.getAPIURL(), 'app/minimalPair/twoFinder'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'ipa1': ipa1.toString(),
        'ipa2': ipa2.toString(),
        'dataLimit': dataLimit,
      },
    );
    String json = response.body.toString();
    return json;
  }

  static Future<String> minimalPairWordFinder(word1,
      {String dataLimit = ''}) async {
    final response = await http.post(
      Uri.https(await SharedPreferencesUtil.getAPIURL(), 'app/minimalPair/wordFinder'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'word1': word1.toString(),
        'dataLimit': dataLimit,
      },
    );
    String json = response.body.toString();
    return json;
  }

  static Future<String> getChatTopicData() async {
    final response = await http.get(
      Uri.https(await SharedPreferencesUtil.getAPIURL(), 'app/chatTopic/getChatTopicData'),
    );
    String json = response.body.toString();
    return json;
  }

  static Future<String> getIPAAvailable() async {
    final response = await http.get(
      Uri.https(await SharedPreferencesUtil.getAPIURL(), 'app/minimalPair/getIPAAvailable'),
    );
    String json = response.body.toString();
    return json;
  }

  static Future getSentenceSegmentation(String article) async {
    final response = await http.post(
        Uri.https(await SharedPreferencesUtil.getAPIURL(), 'app/sentence/sentSegmentation'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        },
        body: {
          'article': article,
        });
    var json = jsonDecode(response.body.toString());
    return json;
  }

  static Future getSentenceIPA(List sentenceList) async {
    final response = await http.post(
      Uri.https(await SharedPreferencesUtil.getAPIURL(), 'app/sentence/getSentenceIPA'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'sentenceList': jsonEncode(sentenceList),
      },
    );

    var json = jsonDecode(response.body.toString());
    return json;
  }

  static Future getStatitics(String article) async {
    final response = await http.post(
      Uri.https(await SharedPreferencesUtil.getAPIURL(), 'app/article/getStatitics'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'articleContent': article,
      },
    );

    var json = jsonDecode(response.body);
    return json;
  }

  static Future<String> vocabularyTestGetQuestion(
      {String indexMin: '', String indexMax: '', String dataLimit: ''}) async {
    final response = await http.post(
      Uri.https(await SharedPreferencesUtil.getAPIURL(), 'app/vocabularyTest/getQuestion'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'indexMin': indexMin,
        'indexMax': indexMax,
        'dataLimit': dataLimit,
      },
    );
    String json = response.body.toString();
    return json;
  }

  static Future<String> vocabularyGetList(String index,
      {String dataLimit = ''}) async {
    final response = await http.post(
      Uri.https(await SharedPreferencesUtil.getAPIURL(), 'app/vocabulary/getList'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'index': index,
        'dataLimit': dataLimit,
      },
    );
    String json = response.body.toString();
    return json;
  }

  static Future<String> vocabularyGetRowIndex(String word) async {
    final response = await http.post(
      Uri.https(await SharedPreferencesUtil.getAPIURL(), 'app/vocabulary/getRowIndex'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'word': word,
      },
    );
    String json = response.body.toString();
    return json;
  }

  static Future<String> vocabularyGetSentenceList(String index,
      {String dataLimit = ''}) async {
    final response = await http.post(
      Uri.https(await SharedPreferencesUtil.getAPIURL(), 'app/vocabulary/getSentenceList'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'index': index,
        'dataLimit': dataLimit,
      },
    );
    String json = response.body.toString();
    return json;
  }

  static Future<String> getPreferenceSentenceByRank(String rank) async {
    final response = await http.post(
      Uri.https(await SharedPreferencesUtil.getAPIURL(),
          'preferenceFeedback/sentence/get30RankedSentenceListByWord'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'rank': rank,
      },
    );
    String json = response.body.toString();
    return json;
  }

  static Future<String> getPreferenceDataByID(String id) async {
    final response = await http.post(
      Uri.https(await SharedPreferencesUtil.getAPIURL(),
          'preferenceFeedback/sentence/getPreferDataBySentenceID'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'id': id,
      },
    );
    String json = response.body.toString();
    return json;
  }

  static Future<String> sentRecommandAddQuery(String id, String chinese) async {
    final response = await http.post(
      Uri.https(await SharedPreferencesUtil.getAPIURL(),
          'preferenceFeedback/feedback/sentRecommandAddQuery'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'sentenceId': id,
        'chinese': chinese,
      },
    );
    String json = response.body.toString();
    return json;
  }

  static Future<String> sentRecommandEditQuery(
      String id, String chinese) async {
    final response = await http.post(
      Uri.https(await SharedPreferencesUtil.getAPIURL(),
          'preferenceFeedback/feedback/sentRecommandEditQuery'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'recommandId': id,
        'chinese': chinese,
      },
    );
    String json = response.body.toString();
    return json;
  }

  static Future<String> getUserSentenceLikeRecord(String uid) async {
    final response = await http.post(
      Uri.https(await SharedPreferencesUtil.getAPIURL(),
          'preferenceFeedback/feedback/getUserSentenceLikeRecord'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'uid': uid,
      },
    );
    String json = response.body.toString();
    return json;
  }

  static Future<String> getUserRecommendLikeRecord(String uid) async {
    final response = await http.post(
      Uri.https(await SharedPreferencesUtil.getAPIURL(),
          'preferenceFeedback/feedback/getUserRecommendLikeRecord'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'uid': uid,
      },
    );
    String json = response.body.toString();
    return json;
  }

  static Future<String> sentUserSentenceLikeRecord(
      String sentenceId, String uid) async {
    final response = await http.post(
      Uri.https(await SharedPreferencesUtil.getAPIURL(),
          'preferenceFeedback/feedback/sentUserSentenceLikeRecord'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'sentenceId': sentenceId,
        'uid': uid,
      },
    );
    String json = response.body.toString();
    return json;
  }

  static Future<String> sentUserRecommendLikeRecord(
      String recommendId, String uid) async {
    final response = await http.post(
      Uri.https(await SharedPreferencesUtil.getAPIURL(),
          'preferenceFeedback/feedback/sentUserRecommendLikeRecord'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'recommendId': recommendId,
        'uid': uid,
      },
    );
    String json = response.body.toString();
    return json;
  }

  static Future<String> sentSentenceClosedRecord(
      String sentenceId, String chinese) async {
    final response = await http.post(
      Uri.https(await SharedPreferencesUtil.getAPIURL(),
          'preferenceFeedback/feedback/sentSentenceClosedRecord'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'sentenceId': sentenceId,
        'chinese': chinese,
      },
    );
    String json = response.body.toString();
    return json;
  }

  static Future<String> sentenceClauseCount(String sent) async {
    final response = await http.post(
      Uri.https(await SharedPreferencesUtil.getAPIURL(), 'app/sentence/sentenceClauseCount'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'sent': sent,
      },
    );
    String json = response.body.toString();
    return json;
  }

  static Future<String> getCompleteSentenceList(List sent) async {
    final response = await http.post(
      Uri.https(await SharedPreferencesUtil.getAPIURL(), 'app/sentence/getCompleteSentenceList'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'sentenceList': jsonEncode(sent),
      },
    );

    var json = response.body.toString();
    return json;
  }

  static Future<String> getSpacyTreeByString(String sent) async {
    final response = await http.post(
      Uri.https(await SharedPreferencesUtil.getAPIURL(), 'app/analysis/getSpacyTreeByString'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'sentence': sent,
      },
    );

    var json = response.body.toString();
    return json;
  }

  static Future<String> getClauseTableByString(String sent) async {
    final response = await http.post(
      Uri.https(await SharedPreferencesUtil.getAPIURL(), 'app/analysis/getClauseTableByString'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'sentence': sent,
      },
    );

    var json = response.body.toString().replaceAll("NaN", '""');
    return json;
  }

  static Future<String> sendPasswordResetLink(String email) async {
    final response = await http.post(
      Uri.https(await SharedPreferencesUtil.getAPIURL(), 'app/account/sendPasswordResetLink'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'email': email,
      },
    );
    String json = response.body.toString();
    return json;
  }

  static Future<String> sendEmailVerificationLink(String email) async {
    final response = await http.post(
      Uri.https(await SharedPreferencesUtil.getAPIURL(), 'app/account/sendEmailVerificationLink'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'email': email,
      },
    );
    String json = response.body.toString();
    return json;
  }

  static Future<String> getConversationData(String chatTopicGroupId) async {
    final response = await http.post(
      Uri.https(await SharedPreferencesUtil.getAPIURL(), 'app/chatTopic/getConversationData'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'chatTopicGroupId': chatTopicGroupId,
      },
    );

    var json = response.body.toString();
    return json;
  }

  static Future<String> getConversationGroupData(String topicName) async {
    final response = await http.post(
      Uri.https(await SharedPreferencesUtil.getAPIURL(), 'app/chatTopic/getConversationGroupData'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'chatTopicName': topicName,
      },
    );

    var json = response.body.toString();
    return json;
  }

  static Future<String> getContractionPair(String wordCondition) async {
    final response = await http.post(
      Uri.https(await SharedPreferencesUtil.getAPIURL(), 'app/contraction/getContractionPair'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'wordCondition': wordCondition,
      },
    );

    var json = response.body.toString();
    return json;
  }

  static Future<String> getContractionFullForm(String wordCondition, String word) async {
    final response = await http.post(
      Uri.https(await SharedPreferencesUtil.getAPIURL(), 'app/contraction/getContractionFullForm'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'wordCondition': wordCondition,
        'word': word,
      },
    );

    var json = response.body.toString();
    return json;
  }

  static Future<String> getContractionSentence(String wordCondition, String word) async {
    final response = await http.post(
      Uri.https(await SharedPreferencesUtil.getAPIURL(), 'app/contraction/getContractionSentence'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'wordCondition': wordCondition,
        'word': word,
      },
    );

    var json = response.body.toString();
    return json;
  }
  
  static Future<String> getIPAGraphemePair(vowelConsonant,
      {String dataLimit = ''}) async {
    final response = await http.post(
      Uri.https(await SharedPreferencesUtil.getAPIURL(), 'app/ipaGraphemePair/getIPAGraphemePair'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'vowelConsonant': vowelConsonant.toString(),
        'dataLimit': dataLimit,
      },
    );
    String json = response.body.toString();
    return json;
  }

  static Future<String> getIPAGraphemePairWord(ipaSymbol,
      {String dataLimit = ''}) async {
    final response = await http.post(
      Uri.https(await SharedPreferencesUtil.getAPIURL(), 'app/ipaGraphemePair/getIPAGraphemePairWord'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'ipaSymbol': ipaSymbol.toString(),
        'dataLimit': dataLimit,
      },
    );
    String json = response.body.toString();
    return json;
  }
}
