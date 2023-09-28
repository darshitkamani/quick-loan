import 'package:flutter/material.dart';

class VisibleAdsCircularWidget extends StatelessWidget {
  final bool isVisible;
  final Widget child;
  const VisibleAdsCircularWidget(
      {super.key, required this.isVisible, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Visibility(
          visible: isVisible,
          child: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black.withOpacity(.5),
            child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircularProgressIndicator(color: Colors.white)]),
          ),
        )
      ],
    );
  }
}
