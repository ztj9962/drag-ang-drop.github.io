
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';


class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeAnimation(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    var _tween = TimelineTween<Prop>()
    ..addScene(
        curve: Curves.easeOut,
        begin :  const  Duration (seconds :  0 ),
        duration :   Duration (milliseconds: (500*delay).round()))
        .animate(Prop.y,tween: Tween(begin: -30.0,end: 0.0))
    ..addScene(
        curve: Curves.easeOut,
        begin :  const  Duration (seconds :  0 ),
        duration :  const  Duration (milliseconds: 500))
        .animate(Prop.opacity, tween: Tween(begin: 0.0,end:1.0));


    return PlayAnimation<TimelineValue<Prop>>(
        tween: _tween,
        duration: _tween.duration, // define duration
        child: child,
        builder: (context, child, value) {
          return Opacity(opacity: value.get(Prop.opacity),
          child: Transform.translate(
              // Get animated offset
              offset: Offset(0, value.get(Prop.y)),
          child: child,));

        });
  }
}

class opacityAnimation extends StatelessWidget{
  final double delay;
  final Widget child;
  opacityAnimation(this.delay,this.child);
  @override
  Widget build(BuildContext context) {
    var _tween = TimelineTween<Prop>()
      ..addScene(
          curve: Curves.easeOut,
          begin :  const  Duration (seconds :  0 ),
          duration :  const  Duration (milliseconds: 400))
          .animate(Prop.opacity, tween: Tween(begin: 0.0,end:1.0));


    // TODO: implement build
    return PlayAnimation<TimelineValue<Prop>>(
        tween: _tween,
        duration: _tween.duration, // define duration
        child: child,
        builder: (context, child, value) {
          return Opacity(opacity: value.get(Prop.opacity),child: child,);

        });
  }

}