import 'package:flutter/material.dart';

class RotatePageRoute extends PageRouteBuilder {
  final Widget page;
  RotatePageRoute({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var tween = Tween<double>(
            begin: 0.5,
            end: 1.0,
          ).chain(CurveTween(curve: Curves.easeInOut));
          return RotationTransition(
            turns: animation.drive(tween),
            child: child,
          );
        },
      );
}

class ScalePageRoute extends PageRouteBuilder {
  final Widget page;
  ScalePageRoute({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var tween = Tween<double>(
            begin: 0.5,
            end: 1.0,
          ).chain(CurveTween(curve: Curves.easeInOut));
          return ScaleTransition(scale: animation.drive(tween), child: child);
        },
      );
}

class FadePageRoute extends PageRouteBuilder {
  final Widget page;
  FadePageRoute({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var tween = Tween<double>(
            begin: 0.5,
            end: 1.0,
          ).chain(CurveTween(curve: Curves.easeIn));
          return FadeTransition(opacity: animation.drive(tween), child: child);
        },
      );
}

class SlidePageRoute extends PageRouteBuilder {
  final Widget page;
  SlidePageRoute({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(1.0, 0.0); // Bắt đầu từ ngoài phải
          var end = Offset.zero; // Kết thúc tại vị trí bình thường
          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: Curves.easeInOut));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      );
}

class CombinedPageRoute extends PageRouteBuilder {
  final Widget page;

  CombinedPageRoute({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // 1️⃣ Hiệu ứng trượt (Slide)
          var slideTween = Tween<Offset>(
            begin: Offset(1, 0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeInOut));

          // 2️⃣ Hiệu ứng mờ dần (Fade)
          var fadeTween = Tween<double>(
            begin: 0.5,
            end: 1.0,
          ).chain(CurveTween(curve: Curves.easeIn));

          // 3️⃣ Hiệu ứng phóng to (Scale)
          var scaleTween = Tween<double>(
            begin: 0.5,
            end: 1.0,
          ).chain(CurveTween(curve: Curves.easeInOut));

          // 4️⃣ Hiệu ứng xoay (Rotation)
          var rotateTween = Tween<double>(
            begin: 0.5,
            end: 1.0,
          ).chain(CurveTween(curve: Curves.easeInOut));

          return SlideTransition(
            position: animation.drive(slideTween),
            child: FadeTransition(
              opacity: animation.drive(fadeTween),
              child: ScaleTransition(
                scale: animation.drive(scaleTween),
                child: RotationTransition(
                  turns: animation.drive(rotateTween),
                  child: child,
                ),
              ),
            ),
          );
        },
      );
}

class SecondaryAnimatedRoute extends PageRouteBuilder {
  final Widget page;

  SecondaryAnimatedRoute({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Màn hình mới: Trượt vào
          var slideTween = Tween<Offset>(
            begin: Offset(1, 0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeInOut));

          // Màn hình cũ: Mờ dần và thu nhỏ
          var fadeTween = Tween<double>(
            begin: 1.0,
            end: 0.0,
          ).chain(CurveTween(curve: Curves.easeOut));
          var scaleTween = Tween<double>(
            begin: 1.0,
            end: 0.8,
          ).chain(CurveTween(curve: Curves.easeOut));

          return Stack(
            children: [
              // Màn hình cũ với hiệu ứng secondaryAnimation
              FadeTransition(
                opacity: secondaryAnimation.drive(fadeTween),
                child: ScaleTransition(
                  scale: secondaryAnimation.drive(scaleTween),
                  child: child,
                ),
              ),
              // Màn hình mới xuất hiện với hiệu ứng Slide
              SlideTransition(
                position: animation.drive(slideTween),
                child: child,
              ),
            ],
          );
        },
      );
}
