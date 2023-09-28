import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieAdWidget extends StatelessWidget {
  final String lottieURL;
  const LottieAdWidget({super.key, required this.lottieURL});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      lottieURL,
      height: 40,
    );
  }
}
