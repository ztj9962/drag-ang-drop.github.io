import 'package:flutter/material.dart';

class ChatMessageUtil extends StatelessWidget {
  final bool senderIsMe;
  final String senderName;
  final List<TextSpan> messageTextWidget;

  final String messageImage;
  final Widget? actionButton;
  final bool changeColor;

  const ChatMessageUtil(
      {Key? key,
      required this.senderIsMe,
      required this.senderName,
      required this.messageTextWidget,
      this.messageImage = '',
      this.actionButton,
      this.changeColor = false})
      : super(key: key);

  Widget messageWidget() {
    if (messageImage != '') {
      return Image.network(messageImage);
    }
    if (actionButton != null) {
      return Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: actionButton!,
          ),
          Expanded(
              flex: 8,
              child: RichText(
                text: TextSpan(
                  text: '',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: senderIsMe ? Colors.black : Colors.black),
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
          color: senderIsMe ? Colors.black : Colors.black,
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
        child: Column(
          crossAxisAlignment:
              (senderIsMe) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Text(senderName,
                style: const TextStyle(fontWeight: FontWeight.normal)),
            Container(
              padding: const EdgeInsets.all(16.0),
              constraints: const BoxConstraints(
                maxWidth: 300,
              ),
              decoration: (senderIsMe)
                  ? BoxDecoration(
                      border: Border.all(),
                      color: Colors.transparent,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(40.0),
                        topLeft: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0),
                      ),
                    )
                  : BoxDecoration(
                      border: Border.all(),
                      color: changeColor
                          ? Colors.grey.withOpacity(0.5)
                          : Colors.transparent,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      ),
                    ),
              margin: const EdgeInsets.all(8),
              child: messageWidget(),
            ),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        //children: this.senderIsMe ? myMessage(context) : otherMessage(context),
        children: message(context),
      ),
    );
  }
}
