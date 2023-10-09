import 'package:action_broadcast/action_broadcast.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:instant_pay/utilities/assets/asset_utils.dart';
import 'package:instant_pay/utilities/colors/color_utils.dart';
import 'package:instant_pay/utilities/font/font_utils.dart';
import 'package:instant_pay/utilities/routes/route_utils.dart';
import 'package:instant_pay/utilities/storage/storage.dart';
import 'package:instant_pay/view/screen/dashboard/home/model/available_ads_response.dart';
import 'package:instant_pay/view/screen/help/question_answer_screen.dart';
import 'package:instant_pay/view/widget/ads_widget/interstitial_ads_widget.dart';
import 'package:instant_pay/view/widget/ads_widget/load_ads_by_api.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  String screenName = "HelpScreen";
  bool isFacebookAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowFacebookAds) ?? false;
  bool isADXAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowADXAds) ?? false;
  bool isAdmobAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowAdmobAds) ?? false;
  bool isAdShow = StorageUtils.prefs.getBool(StorageKeyUtils.isAddShowInApp) ?? false;
  // List<String> availableAdsList = [];
  MyAdsIdClass myAdsIdClass = MyAdsIdClass();
  late StreamSubscription receiver;

  bool isCheckScreen = StorageUtils.prefs.getBool(StorageKeyUtils.isCheckScreenForAdInApp) ?? false;

  @override
  void initState() {
    initReceiver();

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final provider = Provider.of<InterstitialAdsWidgetProvider>(context, listen: false);

      myAdsIdClass = await LoadAdsByApi().isAvailableAds(context: context, screenName: screenName);
      setState(() {});
      // print("ABC __> $availableAdsList");
      if (myAdsIdClass.availableAdsList.contains("Native")) {
        // if (isFacebookAdsShow) {
        //   _showFBNativeAd();
        // }
        // if (isAdmobAdsShow || isADXAdsShow) {
        //   loadAdxNativeAd();
        // }
        ///New Code
        if (isCheckScreen) {
          _showFBNativeAd(isCalledFrom: 'isCheckScreen');
        } else {
          if (myAdsIdClass.isFacebook && isFacebookAdsShow) {
            _showFBNativeAd(isCalledFrom: 'else isCheckScreen ');
          }
          if (myAdsIdClass.isGoogle && isADXAdsShow) {
            loadAdxNativeAd();
          }
        }
      }
      if (myAdsIdClass.availableAdsList.contains("Interstitial")) {
        print('screenName $screenName === isCheckScreen -- $isCheckScreen === myAdsIdClass.isFacebook -- ${myAdsIdClass.isFacebook} === isFacebookAdsShow -- $isFacebookAdsShow === myAdsIdClass.isGoogle -- ${myAdsIdClass.isGoogle} === isADXAdsShow -- $isADXAdsShow');
        if (isCheckScreen) {
          provider.loadFBInterstitialAd(myAdsIdClass: myAdsIdClass, screenName: screenName, fbID: myAdsIdClass.facebookInterstitialId, googleID: myAdsIdClass.googleInterstitialId);
        } else {
          print("myAdsIdClass.isFacebook && isFacebookAdsShow interstitial screenName --> $screenName --> ${myAdsIdClass.isFacebook} $isFacebookAdsShow");
          if (myAdsIdClass.isFacebook && isFacebookAdsShow) {
            provider.loadFBInterstitialAd(myAdsIdClass: myAdsIdClass, screenName: screenName, fbID: myAdsIdClass.facebookInterstitialId, googleID: myAdsIdClass.googleInterstitialId);
          }
          if (myAdsIdClass.isGoogle && isADXAdsShow) {
            provider.loadAdxInterstitialAd(myAdsIdClass: myAdsIdClass, screenName: screenName, context: context, fbInterID: myAdsIdClass.facebookInterstitialId, googleInterID: myAdsIdClass.googleInterstitialId);
          }
        }
      }
    });
  }

  Future initReceiver() async {
    receiver = registerReceiver(['LoadAd']).listen((intent) async {
      print('$screenName Data ----> ${intent.extras}');
      switch (intent.action) {
        case 'LoadAd':
          final provider = Provider.of<InterstitialAdsWidgetProvider>(context, listen: false);
          myAdsIdClass = await LoadAdsByApi().isAvailableAds(context: context, screenName: screenName);
          setState(() {});
          if (myAdsIdClass.availableAdsList.contains("Interstitial")) {
            print('screenName $screenName === isCheckScreen -- $isCheckScreen === myAdsIdClass.isFacebook -- ${myAdsIdClass.isFacebook} === isFacebookAdsShow -- $isFacebookAdsShow === myAdsIdClass.isGoogle -- ${myAdsIdClass.isGoogle} === isADXAdsShow -- $isADXAdsShow');
            if (isCheckScreen) {
              provider.loadFBInterstitialAd(myAdsIdClass: myAdsIdClass, screenName: screenName, fbID: myAdsIdClass.facebookInterstitialId, googleID: myAdsIdClass.googleInterstitialId);
            } else {
              print("myAdsIdClass.isFacebook && isFacebookAdsShow in receiver interstitial screenName --> $screenName --> ${myAdsIdClass.isFacebook} $isFacebookAdsShow");
              if (myAdsIdClass.isFacebook && isFacebookAdsShow) {
                provider.loadFBInterstitialAd(myAdsIdClass: myAdsIdClass, screenName: screenName, fbID: myAdsIdClass.facebookInterstitialId, googleID: myAdsIdClass.googleInterstitialId);
              }
              if (myAdsIdClass.isGoogle && isADXAdsShow) {
                provider.loadAdxInterstitialAd(myAdsIdClass: myAdsIdClass, screenName: screenName, context: context, fbInterID: myAdsIdClass.facebookInterstitialId, googleInterID: myAdsIdClass.googleInterstitialId);
              }
            }
          }
          break;
        default:
      }
    });
  }

  Widget fbNativeAd = const SizedBox();

  // _showFBNativeAd() {
  //   setState(() {
  //     fbNativeAd = loadFbNativeAd(myAdsIdClass.facebookNativeId);
  //   });
  //   updatePrefsResponse(adType: 'Native');
  // }
  _showFBNativeAd({required String isCalledFrom}) {
    bool isFailedTwiceToLoadFbAdId = StorageUtils.prefs.getBool('${StorageKeyUtils.isFailedTwiceToLoadFbAdId}${myAdsIdClass.facebookNativeId}') ?? false;

    if (myAdsIdClass.facebookNativeId.isEmpty || isFailedTwiceToLoadFbAdId) {
      loadAdxNativeAd(isCalledFrom: isCalledFrom);
    } else {
      setState(() {
        fbNativeAd = loadFbNativeAd(myAdsIdClass.facebookNativeId);
      });
      // updatePrefsResponse(adType: 'Native');
    }
  }

  updatePrefsResponse({required String adType}) {
    Timer(const Duration(seconds: 1), () {
      isFacebookAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowFacebookAds) ?? false;
      isADXAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowADXAds) ?? false;
      isAdmobAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowAdmobAds) ?? false;
      isAdShow = StorageUtils.prefs.getBool(StorageKeyUtils.isAddShowInApp) ?? false;
      setState(() {});
      if (isAdmobAdsShow) {
        setState(() {
          fbNativeAd = const SizedBox();
        });
        if (adType == "Native") {
          loadAdxNativeAd();
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    receiver.cancel();
    if (nativeAd != null) {
      nativeAd!.dispose();
    }
  }

  NativeAd? nativeAd;
  bool _nativeAdIsLoaded = false;

  loadAdxNativeAd({String isCalledFrom = 'init'}) async {
    print('Screen name loadNativeAd() ---> $screenName isCalledFrom --> $isCalledFrom ');

    String nativeAdId = myAdsIdClass.googleNativeId;
    // AdsUnitId().getGoogleNativeAdId();
    if (nativeAdId != '') {
      setState(() {
        nativeAd = NativeAd(
          adUnitId: nativeAdId,
          factoryId: 'listTileMedium',
          request: const AdRequest(),
          nativeTemplateStyle: NativeTemplateStyle(templateType: TemplateType.medium),
          listener: NativeAdListener(
            onAdLoaded: (ad) {
              setState(() {
                _nativeAdIsLoaded = true;
                nativeAd = ad as NativeAd;
              });
            },
            onAdFailedToLoad: (ad, error) {
              ad.dispose();
              // print('Ad load failed ---------->>>>>>> (code=${error.code} message=${error.message})');
            },
          ),
        );
        nativeAd!.load();
      });
    }
  }

  Widget loadFbNativeAd(String adId, {String isCalledFrom = 'init'}) {
    print('Screen name loadFbNativeAd() ---> $screenName isCalledFrom -->$isCalledFrom ');

    String nativeAdId = adId;
    // AdsUnitId().getFacebookNativeAdId();
    if (nativeAdId == '') {
      return const SizedBox();
    }

    if (kDebugMode) {
      nativeAdId = 'IMG_16_9_APP_INSTALL#$adId';
      // debugPrint('ID - - - - $nativeAdId');
    }

    return FacebookNativeAd(
      placementId: nativeAdId, // nativeAdId,
      adType: NativeAdType.NATIVE_AD_VERTICAL,
      width: double.infinity,
      height: 300,
      backgroundColor: const Color(0xFFFFE6C5),
      titleColor: Colors.black,
      descriptionColor: Colors.black,
      buttonColor: const Color(0xff447D58),
      buttonTitleColor: Colors.white,
      buttonBorderColor: const Color(0xff447D58),
      listener: (result, value) {
        // print('---=- =-= -= -= -= - $result $value');

        if (result == NativeAdResult.ERROR) {
          // loadFBInterstitialAd();
          StorageUtils.prefs.setBool(StorageKeyUtils.isShowFacebookAds, false);
          StorageUtils.prefs.setBool(StorageKeyUtils.isShowADXAds, true);
          StorageUtils.prefs.setBool(StorageKeyUtils.isShowAdmobAds, true);
          bool isFailedTwiceToLoadFbAdId = StorageUtils.prefs.getBool('${StorageKeyUtils.isFailedTwiceToLoadFbAdId}$adId') ?? false;

          if (!isFailedTwiceToLoadFbAdId) {
            StorageUtils.prefs.setBool('${StorageKeyUtils.isFailedTwiceToLoadFbAdId}$adId', true);
            loadAdxNativeAd(isCalledFrom: 'fbNativeFunction');
          }
        }
      },
      keepExpandedWhileLoading: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: ColorUtils.themeColor.oxffFFFFFF)),
        title: Text(
          'Help',
          style: FontUtils.h18(fontColor: ColorUtils.themeColor.oxffFFFFFF, fontWeight: FWT.semiBold),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                Share.share('Check out this loan APP :\nhttps://play.google.com/store/apps/details?id=com.loan.fundmentor_aa_credit_aa_kredit_loan_guide_instant_loan_smartcoin_personal_app_navi_loan_guide_app_instant_personal_loan_advisor_quick_loan');
              },
              icon: const Icon(Icons.ios_share_outlined)),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
          const SizedBox(height: 10),
            fbNativeAd,
            nativeAd == null || _nativeAdIsLoaded == false
                ? const SizedBox()
                : Container(
                    color: Colors.transparent,
                    height: 275,
                    alignment: Alignment.center,
                    child: AdWidget(ad: nativeAd!),
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'How may we assist you?',
                  style: FontUtils.h16(fontColor: ColorUtils.themeColor.oxff101523, fontWeight: FWT.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                children: List.generate(
                  helpMap.length,
                  (index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          final provider = Provider.of<InterstitialAdsWidgetProvider>(context, listen: false);
                          receiver.cancel();

                          provider.showFbOrAdxOrAdmobInterstitialAd(
                            myAdsIdClass: myAdsIdClass,
                            availableAds: myAdsIdClass.availableAdsList,
                            RouteUtils.questionAnswerScreen,
                            context,
                            googleInterID: myAdsIdClass.googleInterstitialId,
                            fbInterID: myAdsIdClass.facebookInterstitialId,
                            arguments: QuestionAnswerScreenArguments(
                              appBarTitle: helpMap[index]['lable'],
                              queMap: helpMap[index]['ques_ans'],
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: ColorUtils.themeColor.oxff101523, width: 2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                helpMap[index]['img_url'],
                                height: 50,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 18),
                                child: Text(
                                  helpMap[index]['lable'],
                                  textAlign: TextAlign.center,
                                  style: FontUtils.h12(
                                    fontColor: ColorUtils.themeColor.oxff101523,
                                    fontWeight: FWT.semiBold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> helpMap = [
    {
      'img_url': AssetUtils.creditLimitImprove,
      'lable': 'Credit Limit Improvement',
      'ques_ans': [
        {
          'que': 'What is credit limit enhancement?',
          'ans': 'Credit limit enhancement is a process by which a lender increases a borrower\'s credit limit, allowing them to access more credit.',
        },
        {
          'que': 'How do I apply for a credit limit enhancement?',
          'ans': 'To apply for a credit limit enhancement, you usually need to contact your lender and provide information about your income, credit history, and other relevant details. The lender will then review your application and decide whether to approve the credit limit increase.',
        },
        {
          'que': 'What are the benefits of a credit limit enhancement?',
          'ans': 'The main benefit of a credit limit enhancement is that it allows you to access more credit, which can be useful if you need to make large purchases or have unexpected expenses. Additionally, having a higher credit limit can improve your credit score by reducing your credit utilization ratio.',
        },
        {
          'que': 'What are the requirements for a credit limit enhancement?',
          'ans': 'The requirements for a credit limit enhancement may vary depending on the lender, but generally you need to have a good credit history, a steady income, and a low debt-to-income ratio. You may also need to have an existing account with the lender and a good payment history.',
        },
        {
          'que': 'How often can I apply for a credit limit enhancement?',
          'ans': 'The frequency with which you can apply for a credit limit enhancement may depend on the lender\'s policies, but typically you can only apply after a certain period of time has passed since your last application or credit limit increase. Check with your lender for specific details.',
        },
        {
          'que': 'What should I do if my credit limit enhancement application is denied?',
          'ans': 'If your credit limit enhancement application is denied, you can ask the lender for the reasons why and work to address any issues that may have contributed to the denial, such as paying down debt or improving your credit score. You may also want to consider applying with a different lender.',
        },
      ],
    },
    {
      'img_url': AssetUtils.loanInquiry,
      'lable': 'Loan Product Inquiry',
      'ques_ans': [
        {
          'que': 'What is a loan product inquiry?',
          'ans': 'A loan product inquiry is a process by which a borrower seeks information about different types of loans available from lenders, such as interest rates, repayment terms, and eligibility requirements.',
        },
        {
          'que': 'What types of loans are available for inquiry?',
          'ans': 'There are many types of loans available for inquiry, including personal loans, student loans, home loans, auto loans, business loans, and more.',
        },
        {
          'que': 'How do I inquire about loan products?',
          'ans': 'You can inquire about loan products by contacting lenders directly, either by phone, email, or visiting their website. Some lenders also offer online comparison tools that allow you to compare different loan products side by side.',
        },
        {
          'que': 'What information do I need to provide to inquire about loan products?',
          'ans': 'To inquire about loan products, you may need to provide information about your income, credit history, and other personal details. The specific information required may vary depending on the lender and the type of loan product.',
        },
        {
          'que': 'What should I consider when comparing loan products?',
          'ans': 'When comparing loan products, you should consider the interest rate, repayment terms, fees and charges, eligibility requirements, and any other relevant details that may affect your ability to repay the loan.',
        },
        {
          'que': 'What are the eligibility requirements for different loan products?',
          'ans': 'The eligibility requirements for different loan products may vary depending on the lender and the type of loan. Some common requirements may include a minimum credit score, a certain level of income or employment history, and a certain level of debt-to-income ratio.',
        },
        {
          'que': 'How do I choose the right loan product for my needs?',
          'ans': 'To choose the right loan product for your needs, you should consider your personal financial situation, your ability to repay the loan, and the specific features of each loan product. You may also want to consult with a financial advisor or other expert to help you make an informed decision.',
        },
      ],
    },
    {
      'img_url': AssetUtils.profileVerification,
      'lable': 'Profile Verification',
      'ques_ans': [
        {
          'que': 'What is profile verification for loan apps?',
          'ans': 'Profile verification is a process by which a loan app verifies the identity and financial information of a borrower to ensure that they meet the eligibility requirements for a loan.',
        },
        {
          'que': 'How does profile verification work for loan apps?',
          'ans': 'The specific process for profile verification may vary depending on the loan app, but typically it involves providing personal information, such as name, address, and social security number, as well as financial information, such as income, employment history, and bank account details. The loan app may also require additional documentation, such as a copy of a driver\'s license or utility bill.',
        },
        {
          'que': 'Why is profile verification necessary for loan apps?',
          'ans': 'Profile verification is necessary for loan apps to protect against fraud and ensure that borrowers meet the eligibility requirements for a loan. By verifying a borrower\'s identity and financial information, the loan app can reduce the risk of lending to someone who may default on the loan or engage in other fraudulent activity.',
        },
        {
          'que': 'How long does profile verification take for loan apps?',
          'ans': 'The length of time for profile verification may vary depending on the loan app and the complexity of the borrower\'s financial situation. Some loan apps may be able to complete verification within a few hours, while others may take several days.',
        },
        {
          'que': 'What happens if my profile verification is not approved?',
          'ans': 'If your profile verification is not approved, you may not be eligible for a loan through the loan app. You may need to provide additional information or documentation to complete the verification process, or you may need to seek a loan from a different lender.',
        },
        {
          'que': 'How can I ensure that my profile verification is approved?',
          'ans': 'To ensure that your profile verification is approved, you should provide accurate and complete information and documentation. You should also ensure that you meet the eligibility requirements for the loan, such as having a certain level of income or credit score. If you have any questions or concerns, you should contact the loan app\'s customer support for assistance.',
        },
      ],
    },
    {
      'img_url': AssetUtils.loanRepay,
      'lable': 'Loan Repayment',
      'ques_ans': [
        {
          'que': 'What is loan repayment?',
          'ans': 'Loan repayment is the process of paying back money borrowed from a lender, typically with interest, according to the terms of the loan agreement.',
        },
        {
          'que': 'How do I make loan repayments?',
          'ans': 'The specific process for making loan repayments may vary depending on the lender and the type of loan, but typically you can make payments online, by phone, or by mail. Some lenders may also allow you to set up automatic payments from your bank account.',
        },
        {
          'que': 'How often do I need to make loan repayments?',
          'ans': 'The frequency of loan repayments may vary depending on the lender and the type of loan, but typically you will need to make payments monthly, bi-weekly, or weekly.',
        },
        {
          'que': 'How much do I need to repay each month?',
          'ans': 'The amount you need to repay each month will depend on the loan amount, interest rate, and repayment term specified in the loan agreement. You can typically find this information in your loan documents or by contacting your lender.',
        },
        {
          'que': 'What happens if I miss a loan repayment?',
          'ans': 'If you miss a loan repayment, you may be charged late fees and may incur additional interest charges. Your credit score may also be negatively impacted, which can make it harder to obtain credit in the future. If you continue to miss repayments, the lender may take legal action to recover the funds owed.',
        },
        {
          'que': 'Can I pay off my loan early?',
          'ans': 'Some lenders allow you to pay off your loan early without penalty, while others may charge a fee for early repayment. You should check your loan agreement or contact your lender to determine if there are any penalties for early repayment.',
        },
        {
          'que': 'What happens if I pay off my loan early?',
          'ans': 'If you pay off your loan early, you will save money on interest charges and may be able to improve your credit score. You may also be able to obtain credit more easily in the future.',
        },
      ],
    },
    {
      'img_url': AssetUtils.loanDisbursal,
      'lable': 'Loan Disbursal',
      'ques_ans': [
        {
          'que': 'What is loan disbursal?',
          'ans': 'Loan disbursal is the process of transferring funds from a lender to a borrower after the loan has been approved.',
        },
        {
          'que': 'How long does it take for loan disbursal?',
          'ans': 'The time taken for loan disbursal depends on the type of loan and the lender. For personal loans, it may take a few hours to a few days, whereas for home loans or business loans, it may take several weeks.',
        },
        {
          'que': 'What are the documents required for loan disbursal?',
          'ans': 'The documents required for loan disbursal vary depending on the type of loan and the lender. Common documents include proof of identity and address, income proof, bank statements, and property documents if applicable.',
        },
        {
          'que': 'Can loan disbursal be rejected after approval?',
          'ans': 'Yes, loan disbursal can be rejected even after approval if the borrower fails to meet the terms and conditions of the loan or if there is a change in their financial situation.',
        },
        {
          'que': 'Is loan disbursal taxable?',
          'ans': 'No, loan disbursal is not taxable as it is a loan and not income. However, the interest paid on the loan may be subject to tax depending on the borrower\'s income and tax laws in their country.',
        },
      ],
    },
    {
      'img_url': AssetUtils.notes,
      'lable': 'Didn\'t find your query?',
      'ques_ans': [
        {
          'que': 'What should I do if I didn\'t find my query in the loan guide app?',
          'ans': 'If you didn\'t find your query in the loan guide app, you can try using the search function to look for specific keywords related to your query. Alternatively, you can contact the app\'s customer support team for assistance.',
        },
        {
          'que': 'How can I contact the loan guide app\'s customer support team?',
          'ans': 'The loan guide app may have a dedicated customer support section within the app, where you can find contact details such as email addresses, phone numbers, or live chat support. You can also try visiting the app developer\'s website or social media pages for contact information.',
        },
        {
          'que': 'What information should I provide when contacting the loan guide app\'s customer support team?',
          'ans': 'When contacting the loan guide app\'s customer support team, it is helpful to provide details about your query, such as the type of loan you are interested in, your credit score, your income, and any other relevant information. This will enable the customer support team to provide more accurate and personalized assistance.',
        },
        {
          'que': 'How long does it take for the loan guide app\'s customer support team to respond to queries?',
          'ans': 'The response time for the loan guide app\'s customer support team may vary depending on their workload and the complexity of your query. However, most customer support teams aim to respond within 24-48 hours.',
        },
        {
          'que': 'Can the loan guide app\'s customer support team provide financial advice or recommend specific lenders?',
          'ans': 'The loan guide app\'s customer support team may be able to provide general information and guidance on loan-related topics. However, they are not financial advisors and cannot provide personalized financial advice. Additionally, they may not be able to recommend specific lenders, as this could be seen as a conflict of interest.',
        },
      ],
    },
  ];
}
