import 'package:flutter/material.dart';
import 'package:instant_pay/utilities/colors/color_utils.dart';
import 'package:instant_pay/utilities/font/font_utils.dart';

class TermsAndConditionScreen extends StatelessWidget {
  const TermsAndConditionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: ColorUtils.themeColor.oxffFFFFFF,
            )),
        title: Text(
          'Terms and Conditions',
          style: FontUtils.h18(
            fontColor: ColorUtils.themeColor.oxffFFFFFF,
            fontWeight: FWT.semiBold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: ColorUtils.themeColor.oxff000000),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Use of the App :'.toUpperCase(),
                    style: FontUtils.h18(
                        fontColor: ColorUtils.themeColor.oxff101523,
                        fontWeight: FWT.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '''
You may use the App for personal, non-commercial purposes only. You agree not to use the App for any illegal, fraudulent, or unauthorized purpose. 

You also agree not to use the App to engage in any activity that could harm the App, its users, or any third party.''',
                    style: FontUtils.h14(
                        fontColor: ColorUtils.themeColor.oxff101523,
                        fontWeight: FWT.medium),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Information Accuracy :'.toUpperCase(),
                    style: FontUtils.h18(
                        fontColor: ColorUtils.themeColor.oxff101523,
                        fontWeight: FWT.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '''
The information provided by Instant Pay : LOAN GUIDE APP is for general informational purposes only and should not be considered as legal, financial, or professional advice. 

While we strive to ensure the accuracy of the information, we cannot guarantee that it is error-free, complete, or up-to-date. 

Therefore, we recommend that you consult with a financial or legal professional before making any decisions based on the information provided by the App.''',
                    style: FontUtils.h14(
                        fontColor: ColorUtils.themeColor.oxff101523,
                        fontWeight: FWT.medium),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Privacy Policy :'.toUpperCase(),
                    style: FontUtils.h18(
                        fontColor: ColorUtils.themeColor.oxff101523,
                        fontWeight: FWT.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '''
Please review our Privacy Policy, which explains how we collect, use, and disclose information from our users.''',
                    style: FontUtils.h14(
                        fontColor: ColorUtils.themeColor.oxff101523,
                        fontWeight: FWT.medium),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
