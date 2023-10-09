import 'dart:math';

import 'package:action_broadcast/action_broadcast.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:instant_pay/utilities/colors/color_utils.dart';
import 'package:instant_pay/utilities/font/font_utils.dart';
import 'package:instant_pay/utilities/storage/storage.dart';
import 'package:instant_pay/utilities/validators/validators.dart';
import 'package:instant_pay/view/screen/dashboard/home/model/available_ads_response.dart';
import 'package:instant_pay/view/widget/ads_widget/interstitial_ads_widget.dart';
import 'package:instant_pay/view/widget/ads_widget/load_ads_by_api.dart';
import 'package:instant_pay/view/widget/center_text_button_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EMILoanCalculatorScreen extends StatefulWidget {
  const EMILoanCalculatorScreen({super.key});

  @override
  State<EMILoanCalculatorScreen> createState() => _EMILoanCalculatorScreenState();
}

class _EMILoanCalculatorScreenState extends State<EMILoanCalculatorScreen> with Validators {
  // TextEditingController loanAmtController = TextEditingController();
  // TextEditingController interestRateController = TextEditingController();
  // TextEditingController loanTermInMonthsController = TextEditingController();

  double loanAmt = 3500000;
  double loanMonth = 120;
  double interestRt = 8.50;

  double monthlyPayment = 0;
  double yearlyInterest = 0;
  double monthlyInterest = 0;
  double totalPayableInterest = 0;
  double finalPayableAmount = 0;

  int currentIndex = 0;
  final _formKey = GlobalKey<FormState>();
  String screenName = "LoanCalculatorDetails";
  bool isFacebookAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowFacebookAds) ?? false;
  bool isADXAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowADXAds) ?? false;
  bool isAdmobAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowAdmobAds) ?? false;
  bool isAdShow = StorageUtils.prefs.getBool(StorageKeyUtils.isAddShowInApp) ?? false;

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

  Widget fbNativeAd = const SizedBox();
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

  // _showFBNativeAd() {
  //   setState(() {
  //     fbNativeAd = loadFbNativeAd(myAdsIdClass.facebookNativeId);
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
          fbNativeAd = const SizedBox();
        });
        if (adType == "Native") {
          loadAdxNativeAd();
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

    String nativeAdId = myAdsIdClass.googleNativeId; // AdsUnitId().getGoogleNativeAdId();
    if (nativeAdId != '') {
      setState(() {
        nativeAd = NativeAd(
          adUnitId: nativeAdId,
          factoryId: 'listTileMedium',
          request: const AdRequest(),
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

  @override
  Widget build(BuildContext context) {
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
          'Loan EMI Calculator',
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
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Form(
                  key: _formKey,
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
                      const SizedBox(height: 20),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Loan Amount: ${NumberFormat('#,##,###', 'en_IN').format(loanAmt)}',
                            style: FontUtils.h16(fontColor: ColorUtils.themeColor.oxff858494, fontWeight: FWT.medium),
                          ),
                        ),
                      ),
                      Slider(
                        value: loanAmt,
                        min: 0,
                        max: 100000000,
                        divisions: 1000,
                        activeColor: ColorUtils.themeColor.oxff447D58,
                        onChanged: (value) {
                          setState(() {
                            loanAmt = value;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Interest Rate: ${interestRt.toStringAsFixed(2)} %',
                            style: FontUtils.h16(fontColor: ColorUtils.themeColor.oxff858494, fontWeight: FWT.medium),
                          ),
                        ),
                      ),
                      Slider(
                        value: interestRt,
                        min: 0,
                        max: 30,
                        divisions: 600,
                        activeColor: ColorUtils.themeColor.oxff447D58,
                        onChanged: (value) {
                          setState(() {
                            interestRt = value;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Loan Duration: ${(loanMonth ~/ 12).toStringAsFixed(0)} Year, ${(loanMonth % 12).toStringAsFixed(0)} Month',
                            style: FontUtils.h16(fontColor: ColorUtils.themeColor.oxff858494, fontWeight: FWT.medium),
                          ),
                        ),
                      ),
                      Slider(
                        value: loanMonth,
                        min: 0,
                        max: 600,
                        divisions: 800,
                        activeColor: ColorUtils.themeColor.oxff447D58,
                        onChanged: (value) {
                          setState(() {
                            loanMonth = value;
                          });
                        },
                      ),
                      const SizedBox(height: 10),

                      CenterTextButtonWidget(
                        title: 'Calculate',
                        onTap: () {
                          // print(
                          //     "currentIndex != 0 && currentIndex % 5 == 0 ${currentIndex != 0 && currentIndex % 5 == 0}");
                          if (currentIndex != 0 && currentIndex % 2 == 0) {
                            final provider = Provider.of<InterstitialAdsWidgetProvider>(context, listen: false);

                            provider.showFbOrAdxOrAdmobInterstitialAd(
                              'POP',
                              context,
                              myAdsIdClass: myAdsIdClass,
                              availableAds: myAdsIdClass.availableAdsList,
                              fbInterID: myAdsIdClass.facebookInterstitialId,
                              googleInterID: myAdsIdClass.googleInterstitialId,
                            );
                          }
                          setState(() {
                            currentIndex = currentIndex + 1;
                          });
                          double loanAmount = loanAmt;
                          double interestRate = interestRt;
                          double loanTermInMonths = loanMonth;
                          double monthlyInterestRate = (interestRate / 12) / 100;
                          double numerator = monthlyInterestRate * pow(1 + monthlyInterestRate, loanTermInMonths);
                          double denominator = pow(1 + monthlyInterestRate, loanTermInMonths) - 1;
                          setState(() {
                            monthlyPayment = loanAmount * (numerator / denominator);
                            yearlyInterest = monthlyInterestRate * 12 * 100;
                            monthlyInterest = monthlyInterestRate * loanAmount;
                            totalPayableInterest = (monthlyPayment * loanTermInMonths) - loanAmount;
                            finalPayableAmount = monthlyPayment * loanTermInMonths;
                          });
                        },
                      ),

                      const SizedBox(height: 10),
                      const Divider(thickness: 2),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Monthly Payment',
                              style: FontUtils.h16(
                                fontColor: ColorUtils.themeColor.oxff858494,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              monthlyPayment.toStringAsFixed(2).toString(),
                              style: FontUtils.h16(
                                fontColor: ColorUtils.themeColor.oxff858494,
                                fontWeight: FWT.semiBold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(thickness: 2),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Monthly Interest',
                              style: FontUtils.h16(
                                fontColor: ColorUtils.themeColor.oxff858494,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              monthlyInterest.toStringAsFixed(2).toString(),
                              style: FontUtils.h16(
                                fontColor: ColorUtils.themeColor.oxff858494,
                                fontWeight: FWT.semiBold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(thickness: 2),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Yearly Interest Rate',
                              style: FontUtils.h16(
                                fontColor: ColorUtils.themeColor.oxff858494,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              yearlyInterest.toStringAsFixed(2).toString(),
                              style: FontUtils.h16(
                                fontColor: ColorUtils.themeColor.oxff858494,
                                fontWeight: FWT.semiBold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(thickness: 2),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Loan Term In Month',
                              style: FontUtils.h16(
                                fontColor: ColorUtils.themeColor.oxff858494,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              // loanMonth.toString(),
                              '${(loanMonth ~/ 12).toStringAsFixed(0)} Year, ${(loanMonth % 12).toStringAsFixed(0)} Month',
                              style: FontUtils.h16(
                                fontColor: ColorUtils.themeColor.oxff858494,
                                fontWeight: FWT.semiBold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(thickness: 2),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Total Payable Interest',
                              style: FontUtils.h16(
                                fontColor: ColorUtils.themeColor.oxff858494,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              totalPayableInterest.toStringAsFixed(2).toString(),
                              style: FontUtils.h16(
                                fontColor: ColorUtils.themeColor.oxff858494,
                                fontWeight: FWT.semiBold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(thickness: 2),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Final Payable Amount',
                              style: FontUtils.h16(
                                fontColor: ColorUtils.themeColor.oxff858494,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              finalPayableAmount.toStringAsFixed(2).toString(),
                              style: FontUtils.h16(
                                fontColor: ColorUtils.themeColor.oxff858494,
                                fontWeight: FWT.semiBold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(thickness: 2),
                      // CenterTextButtonBorderWidget(
                      //   title: Icon(
                      //     Icons.home,
                      //     color: ColorUtils.themeColor.oxff447D58,
                      //     size: 35,
                      //   ),
                      //   onTap: () {
                      //     final provider = Provider.of<InterstitialAdsWidgetProvider>(context, listen: false);
                      //     provider.showInterstitialAd(RouteUtils.dashScreen, context);
                      //   },
                      // ),
                      // const SizedBox(height: 10),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
