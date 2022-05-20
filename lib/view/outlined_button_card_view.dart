import 'package:alicsnet_app/page/page_theme.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OutlinedButtonCardView extends StatelessWidget {
  final String imagePath;
  final Color backgroundColor;
  final Color textColor;
  final String titleText;
  final AutoSizeGroup? titleTextSizeGroup;
  final AutoSizeGroup? descripTextSizeGroup;
  final String descripText;
  final Function()? onTapFunction;

  const OutlinedButtonCardView({Key? key,
    required this.imagePath,
    this.backgroundColor = PageTheme.app_theme_blue,
    this.textColor = PageTheme.app_theme_blue,
    required this.titleText,
    required this.descripText,
    this.titleTextSizeGroup,
    this.descripTextSizeGroup,
    this.onTapFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: GestureDetector(
          onTap: onTapFunction,
          child: Container(
            padding: const EdgeInsets.all(8),
            //height: 100,
            decoration: BoxDecoration(
              border: Border.all(
                color: backgroundColor,
                width: 2,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    width: 96,
                    height: 96,
                    child: SvgPicture.asset(imagePath),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child:
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AutoSizeText(
                          titleText,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            letterSpacing: 1.0,
                            color: textColor,
                          ),
                          group: titleTextSizeGroup,
                          maxLines: 1,
                        ),
                        AutoSizeText(
                          descripText,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            letterSpacing: 1.0,
                            color: textColor,
                          ),
                          group: descripTextSizeGroup,
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