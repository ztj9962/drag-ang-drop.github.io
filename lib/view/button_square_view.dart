import 'package:alicsnet_app/page/page_theme.dart';
import 'package:alicsnet_app/util/hexcolor_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ButtonSquareView extends StatelessWidget {
  //final Color backgroundColor;
  final String mainText;
  final String subTextBottomLeft;
  final String subTextBottomRight;
  final Function()? onTapFunction;

  const ButtonSquareView(
      {Key? key,
      //required this.backgroundColor,
      required this.mainText,
      required this.subTextBottomLeft,
      required this.subTextBottomRight,
      this.onTapFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
        child: GestureDetector(
          onTap: onTapFunction,
          child: Container(
            padding: const EdgeInsets.all(8),
            height: 200,
            //width: 300,
            decoration: BoxDecoration(
              color: PageTheme.app_theme_blue,
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: HexColor('#aaaaaa').withOpacity(0.6),
                    offset: const Offset(1.1, 4.0),
                    blurRadius: 8.0),
              ],
              gradient: LinearGradient(
                colors: <HexColor>[
                  HexColor('#FF08579B'),
                  HexColor('#aaaaaa'),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: <Widget>[
                /*Expanded(
                  flex: 2,
                  child: SizedBox(
                    width: 72,
                    height: 72,
                    child: SvgPicture.asset(imagePath),
                  ),
                ),*/
                Expanded(
                  flex: 8,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AutoSizeText(
                          mainText,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            letterSpacing: 1.0,
                            color: Color(0xFFFEFEFE),
                          ),
                          maxLines: 2,
                        ),
                        Expanded(child: Padding(padding: EdgeInsets.all(30))),
                        Row(
                          children: [
                            Expanded(
                              child: AutoSizeText(
                                subTextBottomLeft,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  letterSpacing: 1.0,
                                  color: Color(0xFFFEFEFE),
                                ),
                                maxLines: 2,
                              ),
                            ),
                            Expanded(
                              child: AutoSizeText(
                                subTextBottomRight,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  letterSpacing: 1.0,
                                  color: Color(0xFFFEFEFE),
                                ),
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          thickness: 2,
                          color: PageTheme.nearlyWhite,
                        ),
                        Align(
                            alignment: Alignment.bottomRight,
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: PageTheme.nearlyWhite,
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
