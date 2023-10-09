import 'package:flutter/material.dart';
import 'package:quick_loan/utilities/colors/color_utils.dart';
import 'package:quick_loan/utilities/font/font_utils.dart';
import 'package:quick_loan/view/widget/bounce_click_widget.dart';

class CenterTextButtonBorderWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final Widget? title;
  final TextStyle? style;
  final VoidCallback? onTap;
  final List<Color>? gradientColor;
  final double? elevation;
  const CenterTextButtonBorderWidget({
    Key? key,
    this.height,
    this.width,
    this.title,
    this.style,
    this.gradientColor,
    this.onTap,
    this.elevation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return BounceClickWidget(
      onTap: onTap,
      child: Card(
        elevation: elevation ?? 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        child: Container(
          height: height ?? 54,
          width: width ?? screenSize.width * 0.92,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: Colors.transparent,
            border:
                Border.all(color: ColorUtils.themeColor.oxff673AB7, width: 2),
          ),
          child: Center(
            child: title,
          ),
        ),
      ),
    );
  }
}
