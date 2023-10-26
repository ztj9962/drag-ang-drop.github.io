import 'package:alicsnet_app/page/page_theme.dart';
import 'package:alicsnet_app/util/hexcolor_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ButtonSquareView extends StatelessWidget {
  //final Color backgroundColor;
  final Color widgetColor;
  final String mainText;
  final String subTextBottomLeft;
  final String subTextBottomRight;
  final Color borderColor;
  final Function()? onTapFunction;
  final String? prefixText;
  final String? centerText;
  final String? subCenterText;

  const ButtonSquareView({
    Key? key,
    //required this.backgroundColor,
    required this.mainText,
    required this.subTextBottomLeft,
    required this.subTextBottomRight,
    required this.widgetColor,
    required this.borderColor,
    this.prefixText,
    this.onTapFunction,
    this.centerText,
    this.subCenterText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
        child: GestureDetector(
          onTap: onTapFunction,
          child: Container(
            padding: const EdgeInsets.all(8),
            height: 120,
            //width: 300,
            decoration: BoxDecoration(
              color: Colors.amberAccent,
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              border: Border.all(color: borderColor),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: HexColor('#aaaaaa').withOpacity(0.6),
                    offset: const Offset(1.1, 4.0),
                    blurRadius: 8.0),
              ],
              gradient: LinearGradient(
                colors: [widgetColor, widgetColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
                      children: [
                        (prefixText != null) ? AutoSizeText(prefixText!,style: TextStyle(fontSize: 30),) : Container(),
                        (centerText != null) ? Padding(padding: EdgeInsets.all(5)) : Container(),
                        (centerText != null) ? Expanded(
                          flex: (subTextBottomRight != '') ? 7 : 9,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                centerText!,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  letterSpacing: 1.0,
                                  color: PageTheme.vocabulary_practice_index_text,
                                ),
                                maxLines: 2,
                              ),
                              (subCenterText != null) ? AutoSizeText(
                                subCenterText!,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                  letterSpacing: 1.0,
                                  color: PageTheme.vocabulary_practice_index_text,
                                ),
                                maxLines: 2,
                              ) : Container(),
                            ],
                          ),
                        ) : Container(),
                        Expanded(
                          flex: (centerText != null) ? 1 : 7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: AutoSizeText(
                                  mainText,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    letterSpacing: 1.0,
                                    color: PageTheme.vocabulary_practice_index_text,
                                  ),
                                  maxLines: 2,
                                ),
                              ),
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: AutoSizeText(
                                        subTextBottomLeft,
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          letterSpacing: 1.0,
                                          color: PageTheme.vocabulary_practice_index_text,
                                        ),
                                        maxLines: 2,
                                      ),
                                    ),
                                  /*
                                  */

                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: AutoSizeText(
                            subTextBottomRight,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              letterSpacing: 1.0,
                              color: PageTheme.vocabulary_practice_index_text,
                            ),
                            maxLines: 1,
                          ),
                        ),
                        Expanded(
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: HexColor('#414046'),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }
}
