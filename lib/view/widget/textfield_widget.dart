import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instant_pay/utilities/colors/color_utils.dart';
import 'package:instant_pay/utilities/font/font_utils.dart';

typedef OnTap = String? Function(String? value);
typedef OnChange = String? Function(String? value);

class TextFieldWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? lable;
  final bool? obSecureText;
  final OnTap? validators;
  final OnChange? onChange;
  final VoidCallback? onTap;
  final bool? isReadOnly;
  final double? width;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? textInputFormatter;
  const TextFieldWidget({
    Key? key,
    this.controller,
    this.hintText = '',
    this.prefixIcon,
    this.suffixIcon,
    this.lable = '',
    this.obSecureText = false,
    this.validators,
    this.onTap,
    this.isReadOnly = false,
    this.textInputFormatter = const [],
    this.width,
    this.onChange,
    this.textInputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SizedBox(
      width: width ?? screenSize.width * 0.92,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 3, left: 5),
            child: Text(
              lable!,
              style: FontUtils.h14(
                  fontColor: ColorUtils.themeColor.oxff383838,
                  fontWeight: FWT.semiBold),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: TextFormField(
                onTap: onTap,
                keyboardType: textInputType ?? TextInputType.emailAddress,
                validator: validators,
                controller: controller,
                obscureText: obSecureText!,
                readOnly: isReadOnly!,
                inputFormatters: textInputFormatter!,
                onChanged: onChange,
                decoration: InputDecoration(
                  // isDense: true,
                  fillColor: ColorUtils.themeColor.oxffFFFFFF,
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: ColorUtils.themeColor.oxff383838,
                      width: 2.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: ColorUtils.themeColor.oxffE6E6E6,
                      width: 2.5,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: ColorUtils.themeColor.oxffE6E6E6,
                      width: 2.5,
                    ),
                  ),
                  hintText: hintText,
                  hintStyle: FontUtils.h16(
                      fontColor: ColorUtils.themeColor.oxff858494,
                      fontWeight: FWT.medium),
                  prefixIcon: prefixIcon,
                  suffixIcon: suffixIcon,
                  errorStyle: FontUtils.h12(
                    fontColor: Colors.red[700],
                  ),
                ),
                autofocus: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
