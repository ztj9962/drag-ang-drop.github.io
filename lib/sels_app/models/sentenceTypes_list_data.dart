

import 'package:flutter/material.dart';
import 'package:sels_app/sels_app/phoneticExercises/phoneticExercises_screen.dart';
import 'package:sels_app/main.dart';

BuildContext context = navigatorKey.currentState!.overlay!.context;
class SentenceTypesListData {

  SentenceTypesListData({
    this.imagePath = '',
    this.titleTxt = '',
    this.descripTxt = '',
    this.startColor = '',
    this.endColor = '',
    this.sentenceTypes,
    this.onTapFunction,
  });

  String imagePath;
  String titleTxt;
  String descripTxt;
  String startColor;
  String endColor;
  List<String>? sentenceTypes;
  Function()? onTapFunction;


  static const topicListData2 = [
    {
      "topicClass": "Animals",
      "topicName": ["Animals", "Birds", "Fish and shellfish", "Insects, worms, etc."]
    },
    {
      "topicClass": "Appearance",
      "topicName": ["Appearance", "Body", "Clothes and Fashion", "Colours and Shapes"]
    },
    {
      "topicClass": "Communication",
      "topicName": ["Language", "Phones, email and the internet"]
    },
    {
      "topicClass": "Culture",
      "topicName": ["Art", "Film and theatre", "Literature and writing", "Music", "TV, radio and news"]
    },
    {
      "topicClass": "Food and drink",
      "topicName": ["Cooking and eating", "Drinks", "Food"]
    },
    {
      "topicClass": "Functions",
      "topicName": ["Discussion and agreement", "Doubt, guessing and certainty", "Opinion and argument", "Permission and obligation", "Preferences and decisions", "Suggestions and advice"]
    },
    {
      "topicClass": "Health",
      "topicName": ["Health and Fitness", "Illness", "Medicine"]
    },
    {
      "topicClass": "Homes and buildings",
      "topicName": ["Buildings", "Gardens", "Houses and homes"]
    },
    {
      "topicClass": "Leisure",
      "topicName": ["Games and toys", "Hobbies", "Shopping"]
    },
    {
      "topicClass": "Notions",
      "topicName": ["Change, cause and effect", "Danger", "Difficulty and failure", "Success"]
    },
    {
      "topicClass": "People",
      "topicName": ["Education", "Family and relationships", "Feelings", "Life stages", "Personal qualities"]
    },
    {
      "topicClass": "Politics and society",
      "topicName": ["Crime and punishment", "Law and justice", "People in society", "Politics", "Religion and festivals", "Social issues", "War and conflict"]
    },
    {
      "topicClass": "Science and technology",
      "topicName": ["Biology", "Computers", "Engineering", "Maths and measurement", "Physics and chemistry", "Scientific research"]
    },
    {
      "topicClass": "Sport",
      "topicName": ["Sports: ball and racket sports", "Sports: other sports", "Sports: water sports"]
    },
    {
      "topicClass": "The natural world",
      "topicName": ["Farming", "Geography", "Plants and trees", "The environment", "Weather", "History", "Space", "Time"]
    },
    {
      "topicClass": "Time and space",
      "topicName": ["History", "Space", "Time"]
    },
    {
      "topicClass": "Travel",
      "topicName": ["Holidays", "Transport by air", "Transport by bus and train", "Transport by car or lorry", "Transport by water", "Business", "Jobs", "Money", "Working life"]
    }
  ];


  static Map<String, List<SentenceTypesListData>> listDataNew ={
    'Animals': [
      SentenceTypesListData(
        imagePath: 'assets/sels_app/lion.png',
        titleTxt: 'Animals',
        descripTxt: 'Animals',
        onTapFunction: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatBotPage(topicClass:'Animals')));
          },
        startColor: '#FA7D82',
        endColor: '#FFB295',
      ),
      SentenceTypesListData(
        imagePath: 'assets/sels_app/lion.png',
        titleTxt: 'Animals',
        descripTxt: 'Animals',
        onTapFunction: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatBotPage(topicName:'Animals')));
          },
        startColor: '#FA7D82',
        endColor: '#FFB295',
      ),
      SentenceTypesListData(
        imagePath: 'assets/sels_app/lion.png',
        titleTxt: 'Birds',
        descripTxt: 'Animals',
        onTapFunction: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatBotPage(topicName:'Birds')));
        },
        startColor: '#FA7D82',
        endColor: '#FFB295',
      ),
      SentenceTypesListData(
        imagePath: 'assets/sels_app/lion.png',
        titleTxt: 'Fish and shellfish',
        descripTxt: 'Animals',
        onTapFunction: (){
          print('Card Clicked A');
        },
        startColor: '#FA7D82',
        endColor: '#FFB295',
      ),
      SentenceTypesListData(
        imagePath: 'assets/sels_app/lion.png',
        titleTxt: 'Insects, worms, etc.',
        descripTxt: 'Animals',
        onTapFunction: (){
          print('Card Clicked A');
        },
        startColor: '#FA7D82',
        endColor: '#FFB295',
      ),
    ],
    "Appearance": [
      SentenceTypesListData(
        imagePath: 'assets/sels_app/blend-tool.png',
        titleTxt: 'Appearance',
        descripTxt: 'Appearance',
        onTapFunction: (){
          print('Card Clicked V ');
        },
        startColor: '#738AE6',
        endColor: '#5C5EDD',
      ),
      SentenceTypesListData(
        imagePath: 'assets/sels_app/blend-tool.png',
        titleTxt: 'Appearance',
        descripTxt: 'Appearance',
        onTapFunction: (){
          print('Card Clicked V ');
        },
        startColor: '#738AE6',
        endColor: '#5C5EDD',
      ),
      SentenceTypesListData(
        imagePath: 'assets/sels_app/blend-tool.png',
        titleTxt: 'Body',
        descripTxt: 'Appearance',
        onTapFunction: (){
          print('Card Clicked V ');
        },
        startColor: '#738AE6',
        endColor: '#5C5EDD',
      ),
      SentenceTypesListData(
        imagePath: 'assets/sels_app/blend-tool.png',
        titleTxt: 'Clothes and Fashion',
        descripTxt: 'Appearance',
        onTapFunction: (){
          print('Card Clicked V ');
        },
        startColor: '#738AE6',
        endColor: '#5C5EDD',
      ),
      SentenceTypesListData(
        imagePath: 'assets/sels_app/blend-tool.png',
        titleTxt: 'Colours and Shapes',
        descripTxt: 'Appearance',
        onTapFunction: (){
          print('Card Clicked V ');
        },
        startColor: '#738AE6',
        endColor: '#5C5EDD',
      ),
    ],
    'Communication':[
      SentenceTypesListData(
        imagePath: 'assets/sels_app/communicate.png',
        titleTxt: 'Communication',
        descripTxt: 'Communication',
        onTapFunction: (){
          print('Card Clicked V ');
        },
        startColor: '#FE95B6',
        endColor: '#FF5287',
      ),
      SentenceTypesListData(
        imagePath: 'assets/sels_app/communicate.png',
        titleTxt: 'Language',
        descripTxt: 'Communication',
        onTapFunction: (){
          print('Card Clicked V ');
        },
        startColor: '#FE95B6',
        endColor: '#FF5287',
      ),
      SentenceTypesListData(
        imagePath: 'assets/sels_app/communicate.png',
        titleTxt: 'Phones, email and the internet',
        descripTxt: 'Communication',
        onTapFunction: (){
          print('Card Clicked V ');
        },
        startColor: '#FE95B6',
        endColor: '#FF5287',
      ),
    ],
    'Culture':[
      SentenceTypesListData(
        imagePath: 'assets/sels_app/teamwork.png',
        titleTxt: 'Culture',
        descripTxt: 'Culture',
        onTapFunction: (){
          print('Card Clicked V ');
        },
        startColor: '#6F72CA',
        endColor: '#1E1466',
      ),
      SentenceTypesListData(
        imagePath: 'assets/sels_app/teamwork.png',
        titleTxt: 'Art',
        descripTxt: 'Culture',
        onTapFunction: (){
          print('Card Clicked V ');
        },
        startColor: '#6F72CA',
        endColor: '#1E1466',
      ),
      SentenceTypesListData(
        imagePath: 'assets/sels_app/teamwork.png',
        titleTxt: 'Film and theatre',
        descripTxt: 'Culture',
        onTapFunction: (){
          print('Card Clicked V ');
        },
        startColor: '#6F72CA',
        endColor: '#1E1466',
      ),
      SentenceTypesListData(
        imagePath: 'assets/sels_app/teamwork.png',
        titleTxt: 'Literature and writing',
        descripTxt: 'Culture',
        onTapFunction: (){
          print('Card Clicked V ');
        },
        startColor: '#6F72CA',
        endColor: '#1E1466',
      ),
      SentenceTypesListData(
        imagePath: 'assets/sels_app/teamwork.png',
        titleTxt: 'Music',
        descripTxt: 'Culture',
        onTapFunction: (){
          print('Card Clicked V ');
        },
        startColor: '#6F72CA',
        endColor: '#1E1466',
      ),
      SentenceTypesListData(
        imagePath: 'assets/sels_app/teamwork.png',
        titleTxt: 'TV, radio and news',
        descripTxt: 'Culture',
        onTapFunction: (){
          print('Card Clicked V ');
        },
        startColor: '#6F72CA',
        endColor: '#1E1466',
      ),

    ],
  };


 static List<SentenceTypesListData>? getSentenceTypesListData({String key:''}){
   if(key == ''){
     List<SentenceTypesListData> list = [];
     listDataNew.forEach((key, value) {
       list.add(value[0]);
     });
     return list;
   }else{
     List<SentenceTypesListData> list = [];

     for (int i = 1; i < listDataNew[key]!.length; i++) {
       list.add(listDataNew[key]![i]);
     }
     return list;
   }
   //return listDataNew[key];
  }


}
