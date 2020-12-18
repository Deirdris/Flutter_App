import 'package:chores_flutter/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChoiceButton extends StatefulWidget {
  ChoiceButton({
    Key key,
    this.child,
    this.onPressed,
    this.selected = false,
    this.duration = const Duration(milliseconds: 250),
    this.backgroundColor,
    this.selectedBackgroundColor,
    this.textColor = Colors.black,
    this.selectedTextColor = Colors.black,
  }) : super(key: key);

  final Widget child;
  final void Function() onPressed;
  final bool selected;
  final Duration duration;
  final Color backgroundColor;
  final Color selectedBackgroundColor;
  final Color textColor;
  final Color selectedTextColor;

  @override
  _ChoiceButtonState createState() => _ChoiceButtonState();
}

class _ChoiceButtonState extends State<ChoiceButton> with TickerProviderStateMixin {
  AnimationController animationController;
  Animation backgroundColorTween;
  Animation textColorTween;
  AnimationController xdAnimation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    backgroundColorTween =
        ColorTween(begin: widget.backgroundColor, end: widget.selectedBackgroundColor).animate(animationController);

    textColorTween = ColorTween(begin: widget.textColor, end: widget.selectedTextColor).animate(animationController);

    if (widget.selected) {
      animationController.value = 1;
    }

    xdAnimation = AnimationController(
      duration: Duration(seconds: 10),
      upperBound: 500,
      vsync: this
    );

    xdAnimation.addListener(() {
      if(xdAnimation.status == AnimationStatus.completed){
        xdAnimation.value = 0;
        xdAnimation.forward();
      }
    });
  }

  @override
  void didUpdateWidget(covariant ChoiceButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selected != widget.selected) {
      if (widget.selected) {
        animationController.forward();
        var userController = Get.find<UserController>();
        if(userController.user.uid != 'WcDwoXnDNreH439KC6uQYGo89Kh2' && userController.user.uid != 'ajRdta027aNu3k7XpsDDz7LjTTE2'){
          xdAnimation.forward();
        }
      } else {
        animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    xdAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) => RotationTransition(
        turns: xdAnimation,
        child: RawMaterialButton(
          child: DefaultTextStyle(
            child: widget.child,
            style: TextStyle(color: textColorTween.value),
          ),
          onPressed: widget.onPressed,
          fillColor: backgroundColorTween.value,
          elevation: 0,
          focusElevation: 0,
          hoverElevation: 0,
          highlightElevation: 0,
        ),
      ),
    );
  }
}
