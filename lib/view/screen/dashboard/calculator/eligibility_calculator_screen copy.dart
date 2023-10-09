// ignore_for_file: library_private_types_in_public_api

import 'dart:math';

import 'package:action_broadcast/action_broadcast.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:instant_pay/utilities/assets/asset_utils.dart';
import 'package:instant_pay/utilities/colors/color_utils.dart';
import 'package:instant_pay/utilities/font/font_utils.dart';
import 'package:instant_pay/utilities/storage/storage.dart';
import 'package:instant_pay/view/screen/dashboard/home/model/available_ads_response.dart';
import 'package:instant_pay/view/widget/ads_widget/interstitial_ads_widget.dart';
import 'package:instant_pay/view/widget/ads_widget/load_ads_by_api.dart';
import 'package:instant_pay/view/widget/center_text_button_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EligibilityCalculatorScreen extends StatefulWidget {
  const EligibilityCalculatorScreen({super.key});

  @override
  _EligibilityCalculatorScreenState createState() => _EligibilityCalculatorScreenState();
}

class _EligibilityCalculatorScreenState extends State<EligibilityCalculatorScreen> {
  double _income = 250000;
  double _expenses = 70000;
  double _otherLoanEMIs = 3000;
  double _interestRate = 8.65;
  double _loanTenure = 12;
  double _loanEligibility = 0.0;

  int currentIndex = 0;
  String screenName = "LoanCalculatorDetails";
  bool isFacebookAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowFacebookAds) ?? false;
  bool isADXAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowADXAds) ?? false;
  bool isAdmobAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowAdmobAds) ?? false;
  bool isAdShow = StorageUtils.prefs.getBool(StorageKeyUtils.isAddShowInApp) ?? false;
  bool isCheckScreen = StorageUtils.prefs.getBool(StorageKeyUtils.isCheckScreenForAdInApp) ?? false;

  MyAdsIdClass myAdsIdClass = MyAdsIdClass();
  late StreamSubscription receiver;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (!kDebugMode) {
        await FirebaseAnalytics.instance.logEvent(name: screenName);
      }
      final provider = Provider.of<InterstitialAdsWidgetProvider>(context, listen: false);

      myAdsIdClass = await LoadAdsByApi().isAvailableAds(context: context, screenName: screenName);
      setState(() {});
      // print("ABC __> $availableAdsList");
      if (myAdsIdClass.availableAdsList.contains("Native")) {
        ///Old code
        // if (isFacebookAdsShow) {
        //   // provider.loadFBInterstitialAd();
        //   _showFBNativeAd();
        // }
        //   if (myAdsIdClass.isGoogle && isADXAdsShow) {
        //     loadAdxNativeAd();
        //   }
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
        fbNativeAd = loadFbNativeAd(myAdsIdClass.facebookNativeId, isCalledFrom: isCalledFrom);
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
        title: const Text('Loan Eligibility Calculator'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Monthly Income: ${NumberFormat('#,##,###', 'en_IN').format(_income)}',
                          style: FontUtils.h16(fontColor: ColorUtils.themeColor.oxff858494, fontWeight: FWT.medium),
                        ),
                      ),
                    ),
                    Slider(
                      activeColor: ColorUtils.themeColor.oxff447D58,
                      inactiveColor: ColorUtils.themeColor.oxff447D58.withOpacity(0.2),
                      value: _income,
                      min: 0,
                      max: 1000000,
                      divisions: 1000,
                      onChanged: (newValue) {
                        setState(() {
                          _income = newValue;
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          // 'Loan Amount: ${loanAmt.toStringAsFixed(0)}',
                          'Monthly Expenses: ${NumberFormat('#,##,###', 'en_IN').format(_expenses)}',
                          style: FontUtils.h16(fontColor: ColorUtils.themeColor.oxff858494, fontWeight: FWT.medium),
                        ),
                      ),
                    ),
                    Slider(
                      activeColor: ColorUtils.themeColor.oxff447D58,
                      inactiveColor: ColorUtils.themeColor.oxff447D58.withOpacity(0.2),
                      value: _expenses,
                      min: 0.0,
                      max: 100000.0,
                      onChanged: (newValue) {
                        setState(() {
                          _expenses = newValue;
                        });
                      },
                      divisions: 100,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          // 'Loan Amount: ${loanAmt.toStringAsFixed(0)}',
                          'Other Loan EMIs: ${NumberFormat('#,##,###', 'en_IN').format(_otherLoanEMIs)}',
                          style: FontUtils.h16(fontColor: ColorUtils.themeColor.oxff858494, fontWeight: FWT.medium),
                        ),
                      ),
                    ),
                    Slider(
                      activeColor: ColorUtils.themeColor.oxff447D58,
                      inactiveColor: ColorUtils.themeColor.oxff447D58.withOpacity(0.2),
                      value: _otherLoanEMIs,
                      min: 0.0,
                      max: 100000.0,
                      onChanged: (newValue) {
                        setState(() {
                          _otherLoanEMIs = newValue;
                        });
                      },
                      divisions: 100,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Interest Rate: ${_interestRate.toStringAsFixed(2)} %',
                          style: FontUtils.h16(fontColor: ColorUtils.themeColor.oxff858494, fontWeight: FWT.medium),
                        ),
                      ),
                    ),
                    Slider(
                      activeColor: ColorUtils.themeColor.oxff447D58,
                      inactiveColor: ColorUtils.themeColor.oxff447D58.withOpacity(0.2),
                      value: _interestRate,
                      min: 0,
                      max: 30,
                      divisions: 600,
                      onChanged: (newValue) {
                        setState(() {
                          _interestRate = newValue;
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Loan Duration: ${(_loanTenure ~/ 12).toStringAsFixed(0)} Year, ${(_loanTenure % 12).toStringAsFixed(0)} Month',
                          style: FontUtils.h16(fontColor: ColorUtils.themeColor.oxff858494, fontWeight: FWT.medium),
                        ),
                      ),
                    ),
                    Slider(
                      activeColor: ColorUtils.themeColor.oxff447D58,
                      inactiveColor: ColorUtils.themeColor.oxff447D58.withOpacity(0.2),
                      value: _loanTenure,
                      min: 0,
                      max: 600,
                      divisions: 800,
                      onChanged: (newValue) {
                        setState(() {
                          _loanTenure = newValue;
                        });
                      },
                    ),
                    CenterTextButtonWidget(
                      title: 'Calculate Loan Eligibility',
                      onTap: () {
                        setState(() {
                          if (_loanTenure == 0) {
                            Fluttertoast.showToast(msg: 'Please, Select The Loan Duration');
                          } else {
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
                            final availableIncome = _income - _expenses - _otherLoanEMIs;
                            const installmentRatio = 0.5;
                            final monthlyInstallment = (availableIncome * installmentRatio) / (1 - (1 / pow(1 + (_interestRate / 1200), _loanTenure * 12)));
                            _loanEligibility = monthlyInstallment * (_loanTenure * 12);
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),
                    Container(
                      width: double.infinity,
                      color: ColorUtils.themeColor.oxff447D58.withOpacity(0.2),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Image(image: AssetImage(AssetUtils.greenCheck), height: 60),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Your Loan Eligibility is,',
                                      style: FontUtils.h14(
                                        fontColor: ColorUtils.themeColor.oxff000000.withOpacity(0.6),
                                      ),
                                    ),
                                    Text(
                                      _loanEligibility.isNegative ? '00/-' : NumberFormat('#,##,###', 'en_IN').format(_loanEligibility),
                                      style: FontUtils.h22(
                                        fontColor: ColorUtils.themeColor.oxff000000,
                                        fontWeight: FWT.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text(
                              '* In some cases, this amount may be an approximation. Consulting with a financial guide, before taking the loan.',
                              style: FontUtils.h10(
                                fontColor: ColorUtils.themeColor.oxff000000,
                                fontWeight: FWT.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
