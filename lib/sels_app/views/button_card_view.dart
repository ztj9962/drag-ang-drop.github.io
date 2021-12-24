import 'package:flutter/material.dart';
import 'package:sels_app/sels_app/sels_app_theme.dart';

class ButtonCardView extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;
  final String imagePath;// 'assets/sels_app/dinner.png',
  final String titleTxt;// 'Health',
  final String descripTxt;// 'Health',
  final Function()? onTapFunction;

  const ButtonCardView({Key? key, this.animationController, this.animation, required this.imagePath, required this.titleTxt, required this.descripTxt, this.onTapFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - animation!.value), 0.0),
            child: Column(
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
                          decoration: BoxDecoration(
                            color: SELSAppTheme.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                bottomLeft: Radius.circular(8.0),
                                bottomRight: Radius.circular(8.0),
                                topRight: Radius.circular(8.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: SELSAppTheme.grey.withOpacity(0.4),
                                  offset: Offset(1.1, 1.1),
                                  blurRadius: 10.0),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.topLeft,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                child: SizedBox(
                                  height: 74,
                                  child: AspectRatio(
                                    aspectRatio: 1.714,
                                    child: Image.asset(
                                        "assets/sels_app/back.png"),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 100,
                                          right: 16,
                                          top: 16,
                                        ),
                                        child: Text(
                                          titleTxt,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontFamily:
                                            SELSAppTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            letterSpacing: 0.0,
                                            color:
                                            SELSAppTheme.nearlyDarkBlue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 100,
                                      bottom: 12,
                                      top: 4,
                                      right: 16,
                                    ),
                                    child: Text(
                                      descripTxt,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: SELSAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10,
                                        letterSpacing: 0.0,
                                        color: SELSAppTheme.grey
                                            .withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: -8,
                        left: 8,
                        child: SizedBox(
                          width: 80,
                          height: 80,
                          child: Image.asset(imagePath),
                        ),
                      )
                    ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
