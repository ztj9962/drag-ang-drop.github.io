import 'dart:ffi';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:sels_app/sels_app/models/purchase_provider_model.dart';

class PurchasePage extends StatefulWidget {
  const PurchasePage({Key? key}) : super(key: key);

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  String  SelectedPorduct = "three_month";
  List<bool> isSelected = [false, true, false, false];
  List plan_show = [
    {
      '0':120.0,
      '1':20.0,
      '2':14.0,
      '3':14.0,
      '4':12.0,
      '5':BoxDecoration(color: Color(0x0F000000),),
      '6':Colors.black38,
    },
    {
      '0':140.0,
      '1':24.0,
      '2':16.0,
      '3':16.0,
      '4':14.0,
      '5':BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blueAccent,
                Colors.lightBlueAccent
              ]),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.blueAccent.withOpacity(0.3),
                blurRadius: 16.0,
                spreadRadius: 1,
                offset:Offset(0,-4)
            ),
            BoxShadow(
                color: Colors.lightBlueAccent.withOpacity(0.3),
                blurRadius: 16.0,
                spreadRadius: 1,
                offset:Offset(0,4)
            )
          ]),
      '6':Colors.white,
    },
    {
      '0':120.0,
      '1':20.0,
      '2':14.0,
      '3':14.0,
      '4':12.0,
      '5':BoxDecoration(color: Color(0x0F000000)),
      '6':Colors.black38,
    },
    {
      '0':120.0,
      '1':20.0,
      '2':14.0,
      '3':14.0,
      '4':12.0,
      '5':BoxDecoration(color: Color(0x0F000000)),
      '6':Colors.black38,
    },
  ];
  String price = "三個月 NT\$150.00";
  @override
  Widget build(BuildContext context) {

    var provider = Provider.of<PurchaseProviderModel>(context);
    Size size = MediaQuery.of(context).size;
    BoxDecoration boxDecoration_selsected = BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blueAccent,
              Colors.lightBlueAccent
            ]),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.blueAccent.withOpacity(0.3),
              blurRadius: 16.0,
              spreadRadius: 1,
              offset:Offset(0,-4)
          ),
          BoxShadow(
              color: Colors.lightBlueAccent.withOpacity(0.3),
              blurRadius: 16.0,
              spreadRadius: 1,
              offset:Offset(0,4)
          )
        ]);
    BoxDecoration boxDecoration_noselected = BoxDecoration(color: Color(0x0F000000),);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "訂閱",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            AutoRouter.of(context).popTop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
                child: Text(
              "成為Premiere會員 擁有以下全部權益",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Table(
              columnWidths: {
                0: FractionColumnWidth(0.5),
                1: FractionColumnWidth(0.25),
                2: FractionColumnWidth(0.25),
              },
              border: TableBorder(
                  horizontalInside: BorderSide(
                      width: 1.0,
                      color: Colors.black45,
                      style: BorderStyle.solid)),
              children: [
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "權益",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                        child: Text(
                      "Premiere",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                        child: Text(
                      "Free",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                  ),
                ]),
                itemRow("基本學習數據", true),
                itemRow("解除每日學習上限", false),
                itemRow("學習數據分析", false),
                itemRow("學習資源持續更新", false),
                itemRow("解鎖全部功能", false),
              ],
            ),
          ),
          Container(
            height: 200,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: ToggleButtons(
                splashColor: Colors.transparent,
                fillColor: Colors.transparent,
                renderBorder: false,
                children: [
                  Container(
                    height: plan_show[0]['0'],
                    width: (size.width - 20) / 4,
                    //color: Color(0x0F000000),
                    decoration: plan_show[0]['5'] ,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            "1",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:plan_show[0]['1'],
                                color: plan_show[0]['6']),
                          ),
                        ),
                        Text(
                          "月",
                          style:
                          TextStyle(fontSize: plan_show[0]['2'], color: plan_show[0]['6']),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            "NT\$50.00",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: plan_show[0]['3'],
                                color: plan_show[0]['6']),
                          ),
                        ),
                        Container(
                          height: 2,
                          margin: EdgeInsets.only(right: 10,left: 10,top: 10,bottom: 5),
                          color: plan_show[0]['6'],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text("\$50.00\/月",style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: plan_show[0]['4'],
                              color: plan_show[0]['6']),),
                        )
                      ],
                    ),
                  ),
                  Container(
                    decoration:plan_show[1]['5'],
                    height: plan_show[1]['0'],
                    width: (size.width - 20) / 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            "3",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: plan_show[1]['1'],
                                color: plan_show[1]['6']),
                          ),
                        ),
                        Text(
                          "月",
                          style:
                              TextStyle(fontSize: plan_show[1]['2'], color:plan_show[1]['6']),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            "NT\$150.00",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: plan_show[1]['3'],
                                color: plan_show[1]['6']),
                          ),
                        ),
                        Container(
                          height: 2,
                          margin: EdgeInsets.only(right: 10,left: 10,top: 10),
                          color: plan_show[1]['6'],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5,top: 5),
                          child: Text("\$50.00\/月",style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: plan_show[1]['4'],
                              color: plan_show[1]['6']),),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: plan_show[2]['0'],
                    width: (size.width - 20) / 4,
                    decoration: plan_show[2]['5'],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            "6",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: plan_show[2]['1'],
                                color: plan_show[2]['6']),
                          ),
                        ),
                        Text(
                          "月",
                          style:
                          TextStyle(fontSize: plan_show[2]['2'], color: plan_show[2]['6']),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            "NT\$270.00",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: plan_show[2]['3'],
                                color: plan_show[2]['6']),
                          ),
                        ),
                        Container(
                          height: 2,
                          margin: EdgeInsets.only(right: 10,left: 10,top: 10,bottom: 5),
                          color: plan_show[2]['6'],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text("\$45.00\/月",style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: plan_show[2]['4'],
                              color: plan_show[2]['6']),),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: plan_show[3]['0'],
                    width: (size.width - 20) / 4,
                   decoration: plan_show[3]['5'],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            "12",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: plan_show[3]['1'],
                                color: plan_show[3]['6']),
                          ),
                        ),
                        Text(
                          "月",
                          style:
                          TextStyle(fontSize: plan_show[3]['2'], color: plan_show[3]['6']),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            "NT\$420.00",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: plan_show[3]['3'],
                                color: plan_show[3]['6']),
                          ),
                        ),
                        Container(
                          height: 2,
                          margin: EdgeInsets.only(right: 10,left: 10,top: 10),
                          color: plan_show[3]['6'],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5,bottom: 5),
                          child: Text("\$35.00\/月",style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: plan_show[3]['4'],
                              color: plan_show[3]['6']),),
                        )
                      ],
                    ),
                  ),
                ],
                isSelected: isSelected,
                onPressed: (index){
                  setState(() {
                    for(int i = 0;i<plan_show.length;i++){
                      if(index == i){
                        switch (index){
                          case 0:
                            price = "1 個月 NT\$50.00";
                            SelectedPorduct = "one_month";
                            break;
                          case 1:
                            price = "3 個月 NT\$150.00";
                            SelectedPorduct = "three_month";
                            break;
                          case 2:
                            price = "6 個月 NT\$270.00";
                            SelectedPorduct = "six_month";
                            break;
                          case 3:
                            price = "12 個月 NT\$420.00";
                            SelectedPorduct = "one_year";
                            break;
                        }
                        plan_show[i]['0'] = 140.0;
                        plan_show[i]['1'] = 24.0;
                        plan_show[i]['2'] = 16.0;
                        plan_show[i]['3'] = 16.0;
                        plan_show[i]['4'] = 14.0;
                        plan_show[i]['5'] = boxDecoration_selsected;
                        plan_show[i]['6'] = Colors.white;
                      }else{
                        plan_show[i]['0'] = 120.0;
                        plan_show[i]['1'] = 20.0;
                        plan_show[i]['2'] = 14.0;
                        plan_show[i]['3'] = 15.0;
                        plan_show[i]['4'] = 12.0;
                        plan_show[i]['5'] = boxDecoration_noselected;
                        plan_show[i]['6'] = Colors.black38;
                      }
                    }
                  });
                },
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            margin: EdgeInsets.only(left: 25,right: 25),
            child:Column(
              children: [
                Center(child: Text("注意事項",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),)),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text("1.若您訂閱，即表示您同意使用條款和隱私權政策\n2.訂閱確認後，將產生費用並計入商城帳戶，如需取消服務請確實進行解約操作，否則每月將自動續訂原訂閱並自動扣款",
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),),
                ),
                Row(children: [Text("3.如有任何疑問請 ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),),Text("聯絡我們",style: TextStyle(decoration: TextDecoration.underline,fontWeight: FontWeight.bold,fontSize: 12),)],)
              ],
            )
          ),
          SizedBox(height: 150,)
        ],
      ),
      bottomSheet: Container(
        height: 80,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent]),
        ),
        child: TextButton(
          onPressed: () {
              provider.buy(product: provider.products[SelectedPorduct]);
            },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("購買",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              Text(price,
                  style: TextStyle(color: Colors.white70, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

  TableRow itemRow(String name, bool f) => TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            "${name}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
              child: Icon(
            Icons.done_rounded,
            color: Colors.lightBlueAccent,
          )),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
              child: f
                  ? Icon(
                      Icons.done_rounded,
                      color: Colors.lightBlueAccent,
                    )
                  : Text(" ")),
        )
      ]);
}
