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
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
              left: 24, right: 24, top: 0, bottom: 0),
          child: GestureDetector(
            onTap: onTapFunction,
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    ),
                    child: Stack(
                      alignment: Alignment.topLeft,
                      children: <Widget>[
                        Positioned(
                          top: 4,
                          left: 16,
                          child: SizedBox(
                            width: 72,
                            height: 72,
                            child: SvgPicture.asset(imagePath),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 120,
                                    top: 16,
                                  ),
                                  child: Text(
                                    titleTxt,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      letterSpacing: 1.0,
                                      color: Color(0xFFFEFEFE),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 120,
                                top: 4,
                              ),
                              child: Text(
                                descripTxt,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  letterSpacing: 1.0,
                                  color: Color(0xFFFEFEFE),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}