import 'package:flutter/material.dart';
import 'package:alicsnet_app/page/page_theme.dart';

class TitleView extends StatelessWidget {
  final String titleTxt;
  final Color titleColor;
  final String subTxt;
  final Function()? subFunction;
  final bool subVisivle;

  const TitleView({Key? key,
    required this.titleTxt,
    this.titleColor = const Color(0xFF000000),
    this.subTxt = "",
    this.subFunction,
    this.subVisivle = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              titleTxt,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: PageTheme.fontName,
                fontWeight: FontWeight.w500,
                fontSize: 20,
                letterSpacing: 0.5,
                color: titleColor,
              ),
            ),
          ),
          Visibility(
              visible: subVisivle,
              child:  InkWell(
                highlightColor: Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                onTap: subFunction,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Row(
                    children: <Widget>[
                      Text(
                        subTxt,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontFamily: PageTheme.fontName,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          letterSpacing: 0.5,
                          color: PageTheme.nearlyDarkBlue,
                        ),
                      ),
                      const SizedBox(
                        height: 38,
                        width: 26,
                        child: Icon(
                          Icons.arrow_forward,
                          color: PageTheme.darkText,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }
}