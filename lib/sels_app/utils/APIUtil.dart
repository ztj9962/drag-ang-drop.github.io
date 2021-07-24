import 'package:http/http.dart' as http;

class APIUtil {

  static Future<String> getSentences(String sentenceLevel, {String sentenceTopic :'', String sentenceClass:'', String aboutWord:'', String sentenceLengthLimit:'', String dataLimit:''}) async {
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
        'sentenceLengthLimit': sentenceLengthLimit,
        'dataLimit': dataLimit,
      },
    );
    String json = response.body.toString();
    return json;
  }

  static Future<String> checkSentences(String questionText, String answerText, {String sentenceLevel:''}) async {
    final response = await http.post(
      Uri.https('sels.nkfust.edu.tw', 'app/sentence/checkSentences'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'questionText': questionText,
        'answerText': answerText,
        'sentenceLevel': sentenceLevel,
      },
    );
    String json = response.body.toString();
    return json;
  }


}