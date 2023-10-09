import 'package:flutter/material.dart';
import 'package:instant_pay/utilities/colors/color_utils.dart';
import 'package:instant_pay/utilities/font/font_utils.dart';
import 'package:instant_pay/view/widget/bounce_click_widget.dart';

class ProfileButtonWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final String? title;
  final TextStyle? style;
  final VoidCallback? onTap;
  final List<Color>? gradientColor;
  final Widget? titleWidget;
  final double? elevation;
  final Widget? trailWidget;
  const ProfileButtonWidget(
      {super.key,
      this.height,
      this.width,
      this.title,
      this.style,
      this.onTap,
      this.gradientColor,
      this.elevation,
      this.titleWidget,
      this.trailWidget});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return BounceClickWidget(
      onTap: onTap,
      child: Card(
        elevation: elevation ?? 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        child: Container(
          height: height ?? 54,
          width: width ?? screenSize.width * 0.90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: ColorUtils.themeColor.oxffFFFFFF,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                titleWidget ?? const SizedBox(),
                const SizedBox(width: 10),
                Text(
                  title ?? '',
                  style: style ??
                      FontUtils.h16(
                        fontColor: ColorUtils.themeColor.oxff101523,
                        fontWeight: FWT.medium,
                      ),
                ),
                const Spacer(),
                trailWidget ??
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ColorUtils.themeColor.oxff447D58,
                    )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
