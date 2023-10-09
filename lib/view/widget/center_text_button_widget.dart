import 'package:flutter/material.dart';
import 'package:instant_pay/utilities/colors/color_utils.dart';
import 'package:instant_pay/utilities/font/font_utils.dart';
import 'package:instant_pay/view/widget/bounce_click_widget.dart';

class CenterTextButtonWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final String? title;
  final TextStyle? style;
  final VoidCallback? onTap;
  final List<Color>? gradientColor;
  final double? elevation;
  const CenterTextButtonWidget({
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        child: Container(
          height: height ?? 54,
          width: width ?? screenSize.width * 0.92,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: ColorUtils.themeColor.oxff447D58,
          ),
          child: Center(
            child: Text(
              title ?? '',
              style: style ??
                  FontUtils.h14(
                      fontColor: ColorUtils.themeColor.oxffFFFFFF,
                      fontWeight: FWT.bold),
            ),
          ),
        ),
      ),
    );
  }
}
