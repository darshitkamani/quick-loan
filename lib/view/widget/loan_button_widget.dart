import 'package:flutter/material.dart';
import 'package:instant_pay/utilities/colors/color_utils.dart';
import 'package:instant_pay/utilities/font/font_utils.dart';
import 'package:instant_pay/view/widget/bounce_click_widget.dart';

class LoanButtonWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final String? title;
  final TextStyle? style;
  final VoidCallback? onTap;
  final List<Color>? gradientColor;
  final Widget? titleWidget;
  final double? elevation;
  final bool? isFromHome;
  const LoanButtonWidget(
      {super.key,
      this.height,
      this.width,
      this.title,
      this.style,
      this.onTap,
      this.gradientColor,
      this.elevation,
      this.titleWidget,
      this.isFromHome = false});

  @override
  Widget build(BuildContext context) {
    return BounceClickWidget(
      onTap: onTap,
      child: Card(
        elevation: elevation ?? 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        child: isFromHome ?? false
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    titleWidget ?? const SizedBox(),
                    const SizedBox(width: 10),
                    Text(
                      title ?? '',
                      textAlign: TextAlign.center,
                      style: style ??
                          FontUtils.h14(
                            fontColor: ColorUtils.themeColor.oxff000000,
                            fontWeight: FWT.bold,
                          ),
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  titleWidget ?? const SizedBox(),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      title ?? '',
                      textAlign: TextAlign.center,
                      style: style ??
                          FontUtils.h10(
                            fontColor: ColorUtils.themeColor.oxff000000,
                            fontWeight: FWT.bold,
                          ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
