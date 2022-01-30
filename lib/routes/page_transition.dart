import 'package:flutter/material.dart';

class CustomFadePageTransitionsBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return DualTransitionBuilder(
      animation: animation,
      forwardBuilder: (_, animation, child) => _FadeEnterAnimation(
        animation: animation,
        child: child,
      ),
      reverseBuilder: (_, animation, child) => _FadeExitAnimation(
        animation: animation,
        child: child,
        reverse: true,
      ),
      child: DualTransitionBuilder(
        animation: ReverseAnimation(secondaryAnimation),
        forwardBuilder: (_, animation, child) => _FadeEnterAnimation(
          animation: animation,
          child: child,
          reverse: true,
        ),
        reverseBuilder: (_, animation, child) => _FadeExitAnimation(
          animation: animation,
          child: child,
        ),
        child: child,
      ),
    );
  }
}

class _FadeEnterAnimation extends StatelessWidget {
  _FadeEnterAnimation({
    Key? key,
    required this.animation,
    this.reverse = false,
    this.child,
  }) : super(key: key);

  final Animation<double> animation;
  final Widget? child;
  final bool reverse;

  static final List<TweenSequenceItem<double>>
      fastOutExtraSlowInTweenSequenceItems = <TweenSequenceItem<double>>[
    TweenSequenceItem<double>(
      tween: Tween<double>(begin: 0.0, end: 0.4)
          .chain(CurveTween(curve: Curves.easeInCubic)),
      weight: 0.166666,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(begin: 0.4, end: 1.0)
          .chain(CurveTween(curve: Curves.easeOutCubic)),
      weight: 1.0 - 0.166666,
    ),
  ];
  static final TweenSequence<double> _scaleCurveSequence =
      TweenSequence<double>(fastOutExtraSlowInTweenSequenceItems);

  static final Animatable<double> _fadeInTransition = Tween<double>(
    begin: 0.0,
    end: 1.00,
  ).chain(CurveTween(curve: Curves.linear));

  static final Animatable<double> _scaleDownTransition = Tween<double>(
    begin: 1.15,
    end: 1.00,
  ).chain(_scaleCurveSequence);

  static final Animatable<double> _scaleUpTransition = Tween<double>(
    begin: 0.85,
    end: 1.00,
  ).chain(_scaleCurveSequence);

  // static final Animatable<double?> _scrimOpacityTween = Tween<double?>(
  //   begin: 0.0,
  //   end: 0.60,
  // ).chain(CurveTween(curve: Curves.linear));

  @override
  Widget build(BuildContext context) {
    // double opacity = 0;

    // if (!reverse && animation.status != AnimationStatus.completed) {
    //   opacity = _scrimOpacityTween.evaluate(animation)!;
    // }

    final Animation<double> _fadeTransition = reverse
        ? kAlwaysCompleteAnimation
        : _fadeInTransition.animate(animation);

    final Animation<double> _scaleTransition =
        (reverse ? _scaleDownTransition : _scaleUpTransition)
            .animate(animation);

    return FadeTransition(
      opacity: _fadeTransition,
      child: ScaleTransition(
        scale: _scaleTransition,
        child: child,
      ),
    );
  }
}

class _FadeExitAnimation extends StatelessWidget {
  const _FadeExitAnimation({
    Key? key,
    required this.animation,
    this.reverse = false,
    this.child,
  }) : super(key: key);
  final Animation<double> animation;
  final bool reverse;
  final Widget? child;
  static final List<TweenSequenceItem<double>>
      fastOutExtraSlowInTweenSequenceItems = <TweenSequenceItem<double>>[
    TweenSequenceItem<double>(
      tween: Tween<double>(begin: 0.0, end: 0.4)
          .chain(CurveTween(curve: Curves.easeInCubic)),
      weight: 0.166666,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(begin: 0.4, end: 1.0)
          .chain(CurveTween(curve: Curves.easeOutCubic)),
      weight: 1.0 - 0.166666,
    ),
  ];
  static final TweenSequence<double> _scaleCurveSequence =
      TweenSequence<double>(fastOutExtraSlowInTweenSequenceItems);

  static final Animatable<double> _fadeOutTransition = Tween<double>(
    begin: 1.0,
    end: 0.0,
  ).chain(CurveTween(curve: Curves.linear));

  static final Animatable<double> _scaleUpTransition = Tween<double>(
    begin: 1.00,
    end: 1.10,
  ).chain(_scaleCurveSequence);

  static final Animatable<double> _scaleDownTransition = Tween<double>(
    begin: 1.00,
    end: 0.90,
  ).chain(_scaleCurveSequence);

  @override
  Widget build(BuildContext context) {
    final Animation<double> _fadeTransition = reverse
        ? _fadeOutTransition.animate(animation)
        : kAlwaysCompleteAnimation;
    final Animation<double> _scaleTransition =
        (reverse ? _scaleDownTransition : _scaleUpTransition)
            .animate(animation);
    return FadeTransition(
      opacity: _fadeTransition,
      child: ScaleTransition(
        scale: _scaleTransition,
        child: child,
      ),
    );
  }
}
