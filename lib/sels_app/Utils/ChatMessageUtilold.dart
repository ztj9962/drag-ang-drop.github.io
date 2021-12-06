
import 'package:flutter/material.dart';

class ChatMessageUtil extends StatelessWidget {
  ChatMessageUtil({required this.senderIsMe, required this.senderName, required this.messageTextWidget, this.messageImage = ''});

  final bool senderIsMe;
  final String senderName;
  //final Widget messageText;

  final List<TextSpan> messageTextWidget ;
  final String messageImage;


/*
  List<Widget> otherMessage(context) {

    return <Widget>[
      new Container(
        margin: const EdgeInsets.only(right: 16.0),
        child: new CircleAvatar(child: new Text(this.senderName)),
      ),
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(this.senderName,
                style: new TextStyle(fontWeight: FontWeight.bold)),
            new Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(color: Colors.grey, offset: Offset(1.1, 1.1), blurRadius: 10.0),
                ],
              ),
              margin: const EdgeInsets.only(top: 5.0),
              child: messageWidget(),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> myMessage(context) {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Text(this.senderName, style: Theme.of(context).textTheme.subhead),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: new Text(messageText),
            ),
          ],
        ),
      ),
      new Container(
        margin: const EdgeInsets.only(left: 16.0),
        child: new CircleAvatar(
            child: new Text(
              this.senderName[0],
              style: new TextStyle(fontWeight: FontWeight.bold),
            )),
      ),
    ];
  }
  */

  Widget messageWidget(){
    if(messageImage != ''){
      return Image.network(messageImage);
    }
    /*
    return Text(
        messageText,
        style: new TextStyle(
            fontWeight: FontWeight.bold,
            color: this.senderIsMe ? Colors.blue : Colors.white
        ),
    );

     */
    return RichText(
      text: TextSpan(
        text: '',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: this.senderIsMe ? Colors.blue : Colors.white
        ),
        children: messageTextWidget,
      ),
    );
  }

  List<Widget> message(context) {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: (this.senderIsMe)
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
          children: <Widget>[
            new Text(
                this.senderName,
                style: new TextStyle(
                    fontWeight: FontWeight.normal
                )
            ),
            new Container(
              padding: const EdgeInsets.all(8.0),
              constraints: BoxConstraints(
                maxWidth: 250,
              ),
              decoration:
                (this.senderIsMe)
                  ? BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                    )
                  : BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                    )
              ,
              margin: const EdgeInsets.only(top: 5.0),
              child: messageWidget(),
            ),
          ],
        ),
      ),

    ];
  }


  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        //children: this.senderIsMe ? myMessage(context) : otherMessage(context),
        children: message(context),
      ),
    );
  }

}

