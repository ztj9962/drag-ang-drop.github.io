import 'package:flutter/material.dart';

class ChatTopicMessageUtil extends StatelessWidget {
  final bool senderIsMe;
  final String senderName;
  final List<TextSpan> messageTextWidget;

  final String messageImage;
  final Widget? actionButton;
  final bool changeColor;
  final bool usePrefix;
  final String prefix;
  final bool highlighted;
  final bool secondaryTheme;
  final String commentary;

  const ChatTopicMessageUtil(
      {Key? key,
      required this.senderIsMe,
      required this.senderName,
      required this.messageTextWidget,
      this.messageImage = '',
      this.actionButton,
      this.changeColor = false,
      this.usePrefix = false,
      this.prefix = '',
      this.highlighted = false,
      this.secondaryTheme = false,
      this.commentary = '',
      })
      : super(key: key);

  Widget messageWidget() {
    if (messageImage != '') {
      return Image.network(messageImage);
    }
    if (actionButton != null) {
      return Row(
        children: <Widget>[
          usePrefix ?
          RichText(
                text: TextSpan(
                  text: usePrefix ? prefix : '',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: secondaryTheme ? Colors.white : Colors.black),
                ),
              )
          : Container(),

          actionButton!,

          Expanded(
              flex: 8,
              child: RichText(
                text: TextSpan(
                  text: '',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: secondaryTheme ? Colors.white : Colors.black),
                  children: messageTextWidget,
                ),
              )),
        ],
      );
    }
    return RichText(
      text: TextSpan(
        text: '',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: secondaryTheme ? Colors.white : Colors.black,
        ),
        children: messageTextWidget,
      ),
    );

    RichText(
      text: TextSpan(
        text: '',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: senderIsMe ? Colors.black : Colors.black),
        children: messageTextWidget,
      ),
    );
  }

  List<Widget> message(context) {
    return <Widget>[
        Expanded(
          child: Row(
            children: <Widget>[
              //(senderIsMe) ? Padding(padding: EdgeInsets.all(8)) : Container(),
              (senderIsMe) ? Text('Ans. ',style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 10)) : Text(senderName,style: const TextStyle(fontWeight: FontWeight.normal)),
              Expanded(
                flex: 10,
                child: Container(
                  padding: (senderIsMe) ? const EdgeInsets.all(0) : const EdgeInsets.all(16.0),
                  /*constraints: const BoxConstraints(
                    maxWidth: 300,
                  ),*/
                  decoration: (senderIsMe) ? null : BoxDecoration(
                    color: (secondaryTheme) ? Colors.black.withOpacity(0.7) : Colors.transparent,
                    border: Border.all(),
                    shape: BoxShape.rectangle, // 矩形
                    borderRadius: new BorderRadius.circular(
                        (20.0)), // 圓角度
                    boxShadow: highlighted ? [
                        BoxShadow(
                          blurRadius: 10,
                          color: Color(0x98F8FF00),
                          offset: Offset(0, 2),
                          spreadRadius: 10,
                        )
                      ] : []
                  ),
                  margin: const EdgeInsets.all(8),
                  child: messageWidget(),
                ),
              ),
              (senderIsMe && commentary != '') ?
              Expanded(flex:8,child: Align(alignment:Alignment.centerRight,child: Text(commentary))) : Container(),
            ],
          ),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        //children: this.senderIsMe ? myMessage(context) : otherMessage(context),
        children: message(context),
      ),
    );
  }
}
