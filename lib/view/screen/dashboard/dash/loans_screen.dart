import 'package:action_broadcast/action_broadcast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:instant_pay/l10n/locale_keys.g.dart';
import 'package:instant_pay/utilities/assets/asset_utils.dart';
import 'package:instant_pay/utilities/colors/color_utils.dart';
import 'package:instant_pay/utilities/font/font_utils.dart';
import 'package:instant_pay/utilities/storage/storage.dart';
import 'package:instant_pay/view/screen/dashboard/dash/insurance_scrren.dart';
import 'package:instant_pay/view/screen/dashboard/home/loan_short_description_screen.dart';
import 'package:instant_pay/view/screen/dashboard/home/model/available_ads_response.dart';
import 'package:instant_pay/view/widget/ads_widget/interstitial_ads_widget.dart';
import 'package:instant_pay/view/widget/ads_widget/load_ads_by_api.dart';
import 'package:instant_pay/view/widget/bounce_click_widget.dart';
import 'package:provider/provider.dart';

import '../../../../utilities/routes/route_utils.dart';

class LoansScreen extends StatefulWidget {
  const LoansScreen({super.key});

  @override
  State<LoansScreen> createState() => _LoansScreenState();
}

class _LoansScreenState extends State<LoansScreen> {
  // DashboardMoreLoans
  String screenName = "DashboardMoreLoans";
  bool isFacebookAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowFacebookAds) ?? false;
  bool isADXAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowADXAds) ?? false;
  bool isAdmobAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowAdmobAds) ?? false;
  bool isAdShow = StorageUtils.prefs.getBool(StorageKeyUtils.isAddShowInApp) ?? false;
  bool isCheckScreen = StorageUtils.prefs.getBool(StorageKeyUtils.isCheckScreenForAdInApp) ?? false;

  // List<String> availableAdsList = [];
  MyAdsIdClass myAdsIdClass = MyAdsIdClass();
  late StreamSubscription receiver;
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

    if (adxNativeAd != null) {
      adxNativeAd!.dispose();
    }
  }

  NativeAd? adxNativeAd;
  bool _isAdxNativeAdLoaded = false;

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

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Expanded(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
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
            ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: loansDataList.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: BounceClickWidget(
                    onTap: () {
                      final provider = Provider.of<InterstitialAdsWidgetProvider>(context, listen: false);
                      receiver.cancel();

                      provider.showFbOrAdxOrAdmobInterstitialAd(
                        myAdsIdClass: myAdsIdClass,
                        availableAds: myAdsIdClass.availableAdsList,
                        RouteUtils.dashboardMoreLoansScreen,
                        context,
                        arguments: loansDataList[index].arguments,
                        fbInterID: myAdsIdClass.facebookInterstitialId,
                        googleInterID: myAdsIdClass.googleInterstitialId,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[350]!),
                        borderRadius: BorderRadius.circular(12),
                        color: ColorUtils.themeColor.oxffFFFFFF,
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: screenSize.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.accents[index % Colors.accents.length].withOpacity(0.3),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        loansDataList[index].name!.toUpperCase(),
                                        style: FontUtils.h16(
                                          fontColor: ColorUtils.themeColor.oxff000000,
                                          fontWeight: FWT.bold,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                    ),
                                    Image(
                                      image: AssetImage(loansDataList[index].img!),
                                      height: 50,
                                      width: 50,
                                    ),
                                  ],
                                ),
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
          ],
        ),
      ),
    );
  }

  List<LoansInsuranceDetailsData> loansDataList = [
    LoansInsuranceDetailsData(
      name: LocaleKeys.studentLoans.tr(),
      img: AssetUtils.icStudentLoan,
      shortDescription: LocaleKeys.studentLoansSubTitle.tr(),
      arguments: LoanDescriptionArguments(
        loanName: LocaleKeys.studentLoans.tr(),
        isAdvantage: true,
        titleList: parseStringToList(LocaleKeys.studentLoansTitleList.tr()),
        titleOverViewList: parseStringToList(LocaleKeys.studentLoansTitleOverViewList.tr()),
        takePoints: parseStringToList(LocaleKeys.studentLoansTakePoints.tr()),
        take: parseStringToList(LocaleKeys.studentLoansTake.tr()),
      ),
    ),
    LoansInsuranceDetailsData(
      name: LocaleKeys.aadharLoans.tr(),
      img: AssetUtils.icAadharLoans,
      shortDescription: LocaleKeys.aadharLoansSubTitle.tr(),
      arguments: LoanDescriptionArguments(
        loanName: LocaleKeys.aadharLoans.tr(),
        isAdvantage: true,
        titleList: parseStringToList(LocaleKeys.aadharLoansTitleList.tr()),
        titleOverViewList: parseStringToList(LocaleKeys.aadharLoansTitleOverViewList.tr()),
        takePoints: parseStringToList(LocaleKeys.aadharLoansTakePoints.tr()),
        take: parseStringToList(LocaleKeys.aadharLoansTake.tr()),
      ),
    ),
    LoansInsuranceDetailsData(
      name: LocaleKeys.educationLoans.tr(),
      img: AssetUtils.icEducationLoans,
      shortDescription: LocaleKeys.educationLoansSubTitle.tr(),
      arguments: LoanDescriptionArguments(
        loanName: LocaleKeys.educationLoans.tr(),
        isAdvantage: true,
        titleList: parseStringToList(LocaleKeys.studentLoansTitleList.tr()),
        titleOverViewList: parseStringToList(LocaleKeys.studentLoansTitleOverViewList.tr()),
        takePoints: parseStringToList(LocaleKeys.studentLoansTakePoints.tr()),
        take: parseStringToList(LocaleKeys.studentLoansTake.tr()),
      ),
    ),
    LoansInsuranceDetailsData(
      name: LocaleKeys.carLoans.tr(),
      img: AssetUtils.icCarLoans,
      shortDescription: LocaleKeys.carLoansSubTitle.tr(),
      arguments: LoanDescriptionArguments(
        loanName: LocaleKeys.carLoans.tr(),
        isAdvantage: true,
        titleList: parseStringToList(LocaleKeys.carLoansTitleList.tr()),
        titleOverViewList: parseStringToList(LocaleKeys.carLoansTitleOverViewList.tr()),
        takePoints: parseStringToList(LocaleKeys.carLoansTakePoints.tr()),
        take: parseStringToList(LocaleKeys.carLoansTake.tr()),
      ),
    ),
    LoansInsuranceDetailsData(
      name: LocaleKeys.goldLoans.tr(),
      img: AssetUtils.icGoldLoans,
      shortDescription: LocaleKeys.goldLoansSubTitle.tr(),
      arguments: LoanDescriptionArguments(
        loanName: LocaleKeys.goldLoans.tr(),
        isAdvantage: true,
        titleList: parseStringToList(LocaleKeys.goldLoansTitleList.tr()),
        titleOverViewList: parseStringToList(LocaleKeys.goldLoansTitleOverViewList.tr()),
        takePoints: parseStringToList(LocaleKeys.goldLoansTakePoints.tr()),
        take: parseStringToList(LocaleKeys.goldLoansTake.tr()),
      ),
    ),
    LoansInsuranceDetailsData(
      name: LocaleKeys.paydayLoans.tr(),
      img: AssetUtils.icPaydayLoans,
      shortDescription: LocaleKeys.paydayLoansSubTitle.tr(),
      arguments: LoanDescriptionArguments(
        loanName: LocaleKeys.paydayLoans.tr(),
        isAdvantage: true,
        titleList: parseStringToList(LocaleKeys.paydayLoansTitleList.tr()),
        titleOverViewList: parseStringToList(LocaleKeys.paydayLoansTitleOverViewList.tr()),
        takePoints: parseStringToList(LocaleKeys.paydayLoansTakePoints.tr()),
        take: parseStringToList(LocaleKeys.paydayLoansTake.tr()),
      ),
    ),
  ];
}

List<String> parseStringToList(String inputString) {
  List<String> resultList = inputString.substring(1, inputString.length - 2).split("','");
  return resultList;
}
