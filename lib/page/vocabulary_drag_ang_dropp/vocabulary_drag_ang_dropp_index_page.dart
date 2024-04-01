import 'dart:convert';

import 'package:alicsnet_app/router/router.gr.dart';
import 'package:alicsnet_app/util/hexcolor_util.dart';
import 'package:alicsnet_app/view/button_square_view.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:alicsnet_app/page/page_theme.dart';
import 'package:alicsnet_app/view/title_view.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:alicsnet_app/util/api_util.dart';
import 'package:flutter_emoji/flutter_emoji.dart';

class VocabularydragangdroppIndexPage extends StatefulWidget {
  const VocabularydragangdroppIndexPage({Key? key}) : super(key: key);

  @override
  _VocabularydragangdroppIndexPageState createState() =>
      _VocabularydragangdroppIndexPageState();
}

class _VocabularydragangdroppIndexPageState
    extends State<VocabularydragangdroppIndexPage> {
  List<Widget> _listViews = <Widget>[];
  TextEditingController _textController = TextEditingController();
  bool get isWeb => kIsWeb;

  @override
  void initState() {
    super.initState();
    initVocabularydragangdroppIndexPage();
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }
  int value =0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: PageTheme.app_theme_black,
          title: AutoSizeText(
            '選擇難度級別',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              letterSpacing: 3.0,
              color: Color(0xFFFEFEFE),
            ),
            maxLines: 1,
          ),
        ),
      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,

          children: [
        Expanded(
            child: Container(

              child: ListView.builder(
                padding: EdgeInsets.only(
                  top: 24,
                  bottom: 8, // 調整底部 padding
                ),
                itemCount: _listViews.length,
                itemBuilder: (BuildContext context, int index) {
                  return _listViews[index];
                },
              ),
            ),

        ),

            Expanded(
              flex: 4,
              child: Container(

                child:  DropdownButton(
                  items: <DropdownMenuItem<int>>[
                    DropdownMenuItem(child: Text("選擇頁數",style: TextStyle(color: value==0?Colors.red:Colors.grey),),value: 0,),
                    DropdownMenuItem(child: Text("1",style: TextStyle(color: value==1?Colors.red:Colors.grey),),value: 1,),
                    DropdownMenuItem(child: Text("2",style: TextStyle(color: value==2?Colors.red:Colors.grey),),value: 2,),
                    DropdownMenuItem(child: Text("3",style: TextStyle(color: value==3?Colors.red:Colors.grey),),value: 3,),
                    DropdownMenuItem(child: Text("4",style: TextStyle(color: value==4?Colors.red:Colors.grey),),value: 4,),
                    DropdownMenuItem(child: Text("5",style: TextStyle(color: value==5?Colors.red:Colors.grey),),value: 5,),
                    DropdownMenuItem(child: Text("6",style: TextStyle(color: value==6?Colors.red:Colors.grey),),value: 6,),
                    DropdownMenuItem(child: Text("7",style: TextStyle(color: value==7?Colors.red:Colors.grey),),value: 7,),
                    DropdownMenuItem(child: Text("8",style: TextStyle(color: value==8?Colors.red:Colors.grey),),value: 8,),
                    DropdownMenuItem(child: Text("9",style: TextStyle(color: value==9?Colors.red:Colors.grey),),value: 9,),
                    DropdownMenuItem(child: Text("10",style: TextStyle(color: value==10?Colors.red:Colors.grey),),value: 10,),
                    DropdownMenuItem(child: Text("11",style: TextStyle(color: value==11?Colors.red:Colors.grey),),value: 11,),
                    DropdownMenuItem(child: Text("12",style: TextStyle(color: value==12?Colors.red:Colors.grey),),value: 12,),
                    DropdownMenuItem(child: Text("13",style: TextStyle(color: value==13?Colors.red:Colors.grey),),value: 13,),
                    DropdownMenuItem(child: Text("14",style: TextStyle(color: value==14?Colors.red:Colors.grey),),value: 14,),
                    DropdownMenuItem(child: Text("15",style: TextStyle(color: value==15?Colors.red:Colors.grey),),value: 15,),
                    DropdownMenuItem(child: Text("16",style: TextStyle(color: value==16?Colors.red:Colors.grey),),value: 16,),
                    DropdownMenuItem(child: Text("17",style: TextStyle(color: value==17?Colors.red:Colors.grey),),value: 17,),
                    DropdownMenuItem(child: Text("18",style: TextStyle(color: value==18?Colors.red:Colors.grey),),value: 18,),
                    DropdownMenuItem(child: Text("19",style: TextStyle(color: value==19?Colors.red:Colors.grey),),value: 19,),
                    DropdownMenuItem(child: Text("20",style: TextStyle(color: value==20?Colors.red:Colors.grey),),value: 20,),
                  ],
                  onChanged: (selectValue){//選中後的回撥
                    setState(() {
                      value = selectValue!;
                    });
                  },
                  value: value,// 設定初始值，要與列表中的value是相同的
                  elevation: 10,//設定陰影
                  style: new TextStyle(//設定文字框裡面文字的樣式
                      color: Colors.blue,
                      fontSize: 15
                  ),
                  iconSize: 30,//設定三角標icon的大小
                  underline: Container(height: 1,color: Colors.blue,),// 下劃線

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  initVocabularydragangdroppIndexPage() async {
    List<Widget> listViews = <Widget>[];

    List<String> mainStringList = [
      '簡單',
      '中等',
      '困難',
    ];
    List<String> subStringList = [
      'Rank 1~1000',
      'Rank 1000~3000',
      'Rank 3000~10000',
    ];
    List<List<int>> rankRange = [
      [1,1000],
      [1000,3000],
      [3000,10000],
    ];

    listViews.add(
        Container(
          width: double.infinity,
          child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 2,
              children: List.generate(3, (index) {
                //if (index == 0) return Container();
                //return Text(value['title'][index]);
                //print(value['title'][index]);
                return Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        width: 350,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                          ),
                        ),

                        child: ButtonSquareView(
                          mainText: mainStringList[index],
                          subTextBottomRight: '',
                          subTextBottomLeft: subStringList[index],
                          onTapFunction: () {
                            AutoRouter.of(context).push(
                                VocabularydragangdroppPracticeRoute(minRank: rankRange[index][0], maxRank: rankRange[index][1], value :value
                                 ));
                          },
                          widgetColor: HexColor('#FDFEFB'),
                          borderColor: Colors.transparent,
                          //widgetColor: PageTheme.app_theme_blue.withOpacity(
                          //    0.2 + index * (0.8 / dataList!.length)),

                        ),
                      ),
                    ),

                ],
                );
              })),
        ),
    );
    setState(() {
      _listViews = listViews;
    });
  }
}
