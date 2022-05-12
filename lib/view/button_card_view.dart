import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ButtonCardView extends StatelessWidget {
  final String imagePath;
  final Color backgroundColor;
  final String titleTxt;
  final String descripTxt;
  final Function()? onTapFunction;

  const ButtonCardView({Key? key,
    required this.imagePath,
    required this.backgroundColor,
    required this.titleTxt,
    required this.descripTxt,
    this.onTapFunction
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
            //height: 100,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    width: 72,
                    height: 72,
                    child: SvgPicture.asset(imagePath),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child:
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AutoSizeText(
                          titleTxt,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            letterSpacing: 1.0,
                            color: Color(0xFFFEFEFE),
                          ),
                          maxLines: 1,
                        ),
                        AutoSizeText(
                          descripTxt,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            letterSpacing: 1.0,
                            color: Color(0xFFFEFEFE),
                          ),
                          maxLines: 2,
                        )

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