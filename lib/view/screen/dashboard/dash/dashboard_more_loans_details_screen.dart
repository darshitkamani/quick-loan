import 'package:action_broadcast/action_broadcast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:instant_pay/l10n/locale_keys.g.dart';
import 'package:instant_pay/utilities/colors/color_utils.dart';
import 'package:instant_pay/utilities/font/font_utils.dart';
import 'package:instant_pay/utilities/routes/route_utils.dart';
import 'package:instant_pay/utilities/storage/storage.dart';
import 'package:instant_pay/view/screen/dashboard/home/loan_short_description_screen.dart';
import 'package:instant_pay/view/screen/dashboard/home/model/available_ads_response.dart';
import 'package:instant_pay/view/widget/ads_widget/interstitial_ads_widget.dart';
import 'package:instant_pay/view/widget/ads_widget/load_ads_by_api.dart';
import 'package:instant_pay/view/widget/center_text_button_widget.dart';
import 'package:provider/provider.dart';

class DashboardMoreLoansDetailsScreen extends StatefulWidget {
  final LoanDescriptionArguments arguments;
  const DashboardMoreLoansDetailsScreen({super.key, required this.arguments});

  @override
  State<DashboardMoreLoansDetailsScreen> createState() => _DashboardMoreLoansDetailsScreenState();
}

class _DashboardMoreLoansDetailsScreenState extends State<DashboardMoreLoansDetailsScreen> {
  String screenName = "DashboardMoreLoanDetails";
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
    super.initState();
    initReceiver();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (!kDebugMode) {
        await FirebaseAnalytics.instance.logEvent(name: screenName);
      }
      final provider = Provider.of<InterstitialAdsWidgetProvider>(context, listen: false);

      myAdsIdClass = await LoadAdsByApi().isAvailableAds(context: context, screenName: screenName);
      setState(() {});
      if (myAdsIdClass.availableAdsList.contains("Native")) {
        // if (isFacebookAdsShow) {
        //   _showFBNativeAd();
        // }
        // if (isAdmobAdsShow || isADXAdsShow) {
        //   loadAdxNativeAd();
        //   loadAdxNativeAd1();
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
            loadAdxNativeAd1();
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
  Widget fbNativeAd1 = const SizedBox();
  _showFBNativeAd({required String isCalledFrom}) {
    bool isFailedTwiceToLoadFbAdId = StorageUtils.prefs.getBool('${StorageKeyUtils.isFailedTwiceToLoadFbAdId}${myAdsIdClass.facebookNativeId}') ?? false;

    if (myAdsIdClass.facebookNativeId.isEmpty || isFailedTwiceToLoadFbAdId) {
      loadAdxNativeAd(isCalledFrom: isCalledFrom);
      loadAdxNativeAd1(isCalledFrom: isCalledFrom);
    } else {
      setState(() {
        fbNativeAd = loadFbNativeAd(myAdsIdClass.facebookNativeId);
        fbNativeAd1 = loadFbNativeAd(myAdsIdClass.facebookNativeId);
      });
      // updatePrefsResponse(adType: 'Native');
    }
  }

  // _showFBNativeAd() {
  //   setState(() {
  //     fbNativeAd = loadFbNativeAd(myAdsIdClass.facebookNativeId);
  //     fbNativeAd1 = loadFbNativeAd(myAdsIdClass.facebookNativeId);
  //   });
  //   updatePrefsResponse(adType: 'Native');
  // }

  updatePrefsResponse({required String adType}) {
    Timer(const Duration(seconds: 1), () {
      isFacebookAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowFacebookAds) ?? false;
      isADXAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowADXAds) ?? false;
      isAdmobAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowAdmobAds) ?? false;
      isAdShow = StorageUtils.prefs.getBool(StorageKeyUtils.isAddShowInApp) ?? false;
      setState(() {});
      if (isAdmobAdsShow) {
        setState(() {
          fbNativeAd1 = const SizedBox();
          fbNativeAd = const SizedBox();
        });
        if (adType == "Native") {
          loadAdxNativeAd();
          loadAdxNativeAd1();
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    receiver.cancel();
    if (adxNativeAd != null) {
      adxNativeAd!.dispose();
    }
    if (adxNativeAd1 != null) {
      adxNativeAd1!.dispose();
    }
  }

  NativeAd? adxNativeAd;
  bool _isAdxNativeAdLoaded = false;
  NativeAd? adxNativeAd1;
  bool _isAdxNativeAdLoaded1 = false;

  loadAdxNativeAd({String isCalledFrom = 'init'}) async {
    print('Screen name loadNativeAd() ---> $screenName isCalledFrom --> $isCalledFrom ');

    String nativeAdId = myAdsIdClass.googleNativeId;
    // AdsUnitId().getGoogleNativeAdId();
    if (nativeAdId != '') {
      setState(() {
        adxNativeAd = NativeAd(
          adUnitId: nativeAdId,
          factoryId: 'listTileMedium',
          request: const AdRequest(),
          listener: NativeAdListener(
            onAdLoaded: (ad) {
              setState(() {
                _isAdxNativeAdLoaded = true;
                adxNativeAd = ad as NativeAd;
              });
            },
            onAdFailedToLoad: (ad, error) {
              ad.dispose();
            },
          ),
        );
        adxNativeAd!.load();
      });
    }
  }

  loadAdxNativeAd1({String isCalledFrom = 'init'}) async {
    print('Screen name loadNativeAd1() ---> $screenName isCalledFrom --> $isCalledFrom ');

    String nativeAdId = myAdsIdClass.googleNativeId;
    // AdsUnitId().getGoogleNativeAdId();
    if (nativeAdId != '') {
      setState(() {
        adxNativeAd1 = NativeAd(
          adUnitId: nativeAdId,
          factoryId: 'listTileMedium',
          request: const AdRequest(),
          listener: NativeAdListener(
            onAdLoaded: (ad) {
              setState(() {
                _isAdxNativeAdLoaded1 = true;
                adxNativeAd1 = ad as NativeAd;
              });
            },
            onAdFailedToLoad: (ad, error) {
              ad.dispose();
            },
          ),
        );
        adxNativeAd1!.load();
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
            loadAdxNativeAd1(isCalledFrom: 'fbNativeFunction');
          }
        }
      },
      keepExpandedWhileLoading: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorUtils.themeColor.oxff447D58,
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
          widget.arguments.loanName ?? '',
          style: FontUtils.h16(
            fontColor: ColorUtils.themeColor.oxffFFFFFF,
            fontWeight: FWT.semiBold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                const SizedBox(height: 10),
                  fbNativeAd1,
                  adxNativeAd1 == null || _isAdxNativeAdLoaded1 == false
                      ? const SizedBox()
                      : Container(
                          color: Colors.transparent,
                          height: 275,
                          alignment: Alignment.center,
                          child: AdWidget(ad: adxNativeAd1!),
                        ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.arguments.titleList!.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[350]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: screenSize.width,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  ),
                                  color: Colors.grey[350],
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                    child: Text(
                                      widget.arguments.titleList![index],
                                      style: FontUtils.h16(
                                        fontColor: ColorUtils.themeColor.oxff000000,
                                        fontWeight: FWT.medium,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    Text(
                                      widget.arguments.titleOverViewList![index],
                                      style: FontUtils.h14(
                                        fontColor: ColorUtils.themeColor.oxff000000,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  //         widget.arguments.loanName == 'Student Loans'
                  //             ? Column(
                  //                 children: [
                  //                   CenterTextButtonBorderWidget(
                  //                     title: Text(
                  //                       'How to Apply?',
                  //                       style: FontUtils.h16(
                  //                         fontWeight: FWT.bold,
                  //                         fontColor: ColorUtils.themeColor.oxff447D58,
                  //                       ),
                  //                     ),
                  //                     onTap: () {
                  //                       final provider = Provider.of<InterstitialAdsWidgetProvider>(context, listen: false);
                  //                       if (receiver != null) {
                  //   receiver.cancel();
                  // }
                  //                       provider.showFbOrAdxOrAdmobInterstitialAd(
                  //                         availableAds: myAdsIdClass.availableAdsList,
                  //                         RouteUtils.loanApplyScreen,
                  //                         context,
                  //                         fbInterID: myAdsIdClass.facebookInterstitialId,
                  //                         googleInterID: myAdsIdClass.googleInterstitialId,
                  //                         arguments: LoanDescriptionArguments(
                  //                           loanName: 'Student Loans Apply Guide',
                  //                           titleList: [
                  //                             'Complete the FAFSA',
                  //                             'Review your financial aid award letter',
                  //                             'Accept or decline your loans',
                  //                             'Apply for private loans',
                  //                             'Submit any additional documentation',
                  //                           ],
                  //                           titleOverViewList: [
                  //                             '''⁍ The first step in applying for federal student loans is to complete the Free Application for Federal Student Aid (FAFSA) online.
                  // ⁍ The FAFSA determines your eligibility for federal student aid, including grants, work-study, and loans.
                  // ⁍ Be sure to complete the FAFSA as soon as possible after October 1 of the year before you plan to attend school.''',
                  //                             '''⁍ After you complete the FAFSA, your school will send you a financial aid award letter outlining the types and amounts of financial aid you are eligible to receive.
                  // ⁍ This may include federal loans as well as grants and work-study.''',
                  //                             '''⁍ If you decide to accept federal loans, you will need to complete a Master Promissory Note (MPN) and complete entrance counseling.
                  // ⁍ The MPN is a legal document that outlines the terms and conditions of the loan, while entrance counseling explains your rights and responsibilities as a borrower.''',
                  //                             '''⁍ If you need additional funding beyond what is available through federal loans, you may consider applying for private loans.
                  // ⁍ Private loans may have different eligibility requirements and application processes than federal loans. You can research and compare private loans from different lenders to find the best option for your needs.''',
                  //                             '''⁍ Your school may require additional documentation to process your loans, such as proof of enrollment or income verification.
                  // ⁍ Be sure to submit any requested documentation as soon as possible to avoid delays in the disbursement of your loans.''',
                  //                           ],
                  //                           imgList: [
                  //                             AssetUtils.icStudentLoan1,
                  //                             AssetUtils.icStudentLoan2,
                  //                             AssetUtils.icStudentLoan3,
                  //                             AssetUtils.icStudentLoan4,
                  //                             AssetUtils.icStudentLoan5,
                  //                           ],
                  //                         ),
                  //                       );
                  //                     },
                  //                   ),
                  //                   const SizedBox(height: 10),
                  //                 ],
                  //               )
                  //             : const SizedBox(),
                  const SizedBox(height: 10),
                  fbNativeAd,
                  adxNativeAd == null || _isAdxNativeAdLoaded == false
                      ? const SizedBox()
                      : Container(
                          color: Colors.transparent,
                          height: 275,
                          alignment: Alignment.center,
                          child: AdWidget(ad: adxNativeAd!),
                        ),
                  CenterTextButtonWidget(
                    title: LocaleKeys.NEXT.tr(),
                    onTap: () {
                      if (widget.arguments.isAdvantage == true) {
                        final provider = Provider.of<InterstitialAdsWidgetProvider>(context, listen: false);
                        receiver.cancel();

                        provider.showFbOrAdxOrAdmobInterstitialAd(
                          myAdsIdClass: myAdsIdClass,
                          availableAds: myAdsIdClass.availableAdsList,
                          RouteUtils.loanAdvantageScreen,
                          context,
                          arguments: widget.arguments,
                          fbInterID: myAdsIdClass.facebookInterstitialId,
                          googleInterID: myAdsIdClass.googleInterstitialId,
                        );
                      } else {
                        final provider = Provider.of<InterstitialAdsWidgetProvider>(context, listen: false);
                        receiver.cancel();

                        provider.showFbOrAdxOrAdmobInterstitialAd(
                          availableAds: myAdsIdClass.availableAdsList,
                          RouteUtils.clarificationScreen,
                          context,
                          myAdsIdClass: myAdsIdClass,
                          fbInterID: myAdsIdClass.facebookInterstitialId,
                          googleInterID: myAdsIdClass.googleInterstitialId,
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class InsuranceDetailsScreenArguments {
//   final String? loanName;
//   final List<String>? imgList;
//   final List<String>? titleList;
//   final List<String>? titleOverViewList;
//   final bool? isAdvantage;
//   final List<String>? takePoints;
//   final List<String>? take;
//   InsuranceDetailsScreenArguments({
//     this.loanName,
//     this.titleList,
//     this.titleOverViewList,
//     this.imgList,
//     this.isAdvantage = false,
//     this.take,
//     this.takePoints,
//   });
// }
