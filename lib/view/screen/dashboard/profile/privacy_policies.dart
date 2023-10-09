import 'package:flutter/material.dart';
import 'package:instant_pay/utilities/colors/color_utils.dart';
import 'package:instant_pay/utilities/font/font_utils.dart';

class PrivacyPoliciesScreen extends StatelessWidget {
  const PrivacyPoliciesScreen({super.key});

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
          'Privacy Policies',
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
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Information Collection and Use :'.toUpperCase(),
                    style: FontUtils.h18(
                        fontColor: ColorUtils.themeColor.oxff101523,
                        fontWeight: FWT.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '''
At Instant Pay : LOAN GUIDE APP, we understand the importance of protecting our users' personal information. Therefore, we only collect the necessary information from our users to provide guidance for different types of loans and to help them calculate interest rates and charges. 
            
However, we do not store this information on our server or any other platform. 
            
We use this information solely for the purpose of providing loan guidance to our users and ensuring that we offer the best possible service to them. 
            
We value the trust of our users and take their privacy seriously. 
            
Therefore, we guarantee that their personal information is safe with us and will not be used for any other purposes other than to provide loan guidance.''',
                    style: FontUtils.h14(
                        fontColor: ColorUtils.themeColor.oxff101523,
                        fontWeight: FWT.medium),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Security :'.toUpperCase(),
                    style: FontUtils.h18(
                        fontColor: ColorUtils.themeColor.oxff101523,
                        fontWeight: FWT.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '''
We understand that privacy is a top priority for our users, and we take all necessary steps to ensure that their information is safe and secure. 

Our app uses the latest security protocols to protect our users' data from unauthorized access, disclosure, alteration, or destruction.

We have implemented measures to prevent any unauthorized access to our users' data, and we regularly review our security procedures to ensure that we are up to date with the latest security protocols. 

We also restrict access to our users' data to only those employees or contractors who need it to provide our loan guidance service. 

At Instant Pay : LOAN GUIDE APP, our users' trust is essential to us, and we are committed to ensuring that their data is always secure with us.''',
                    style: FontUtils.h14(
                        fontColor: ColorUtils.themeColor.oxff101523,
                        fontWeight: FWT.medium),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Changes to This Privacy Policy :'.toUpperCase(),
                    style: FontUtils.h18(
                        fontColor: ColorUtils.themeColor.oxff101523,
                        fontWeight: FWT.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '''
We may update our Privacy Policy from time to time. 

Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Privacy Policy.

This policy is effective as of 2023-04-20''',
                    style: FontUtils.h14(
                        fontColor: ColorUtils.themeColor.oxff101523,
                        fontWeight: FWT.medium),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Contact Us :'.toUpperCase(),
                    style: FontUtils.h18(
                        fontColor: ColorUtils.themeColor.oxff101523,
                        fontWeight: FWT.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '''
If you have any questions or suggestions about my Privacy Policy, do not hesitate to contact me at vimeshlunagariya07@gmail.com.''',
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
