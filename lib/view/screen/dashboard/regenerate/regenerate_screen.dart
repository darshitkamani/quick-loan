import 'package:action_broadcast/action_broadcast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:instant_pay/l10n/locale_keys.g.dart';
import 'package:instant_pay/utilities/assets/asset_utils.dart';
import 'package:instant_pay/utilities/colors/color.dart';
import 'package:instant_pay/utilities/font/font_utils.dart';
import 'package:instant_pay/utilities/routes/routes.dart';
import 'package:instant_pay/utilities/storage/storage.dart';
import 'package:instant_pay/utilities/strings/strings_utils.dart';
import 'package:instant_pay/view/screen/dashboard/dashboard_screen.dart';
import 'package:instant_pay/view/screen/dashboard/home/loan_short_description_screen.dart';
import 'package:instant_pay/view/screen/dashboard/home/model/available_ads_response.dart';
import 'package:instant_pay/view/widget/ads_widget/interstitial_ads_widget.dart';
import 'package:instant_pay/view/widget/ads_widget/load_ads_by_api.dart';
import 'package:instant_pay/view/widget/loan_button_widget.dart';
import 'package:provider/provider.dart';

class RegenerateScreen extends StatefulWidget {
  const RegenerateScreen({super.key});

  @override
  State<RegenerateScreen> createState() => _RegenerateScreenState();
}

class _RegenerateScreenState extends State<RegenerateScreen> {
  String screenName = "RegenerateScreen";
  bool isFacebookAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowFacebookAds) ?? false;
  bool isADXAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowADXAds) ?? false;
  bool isAdmobAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowAdmobAds) ?? false;
  bool isAdShow = StorageUtils.prefs.getBool(StorageKeyUtils.isAddShowInApp) ?? false;
  // List<String> availableAdsList = [];

  MyAdsIdClass myAdsIdClass = MyAdsIdClass();
  late StreamSubscription receiver;

  bool isCheckScreen = StorageUtils.prefs.getBool(StorageKeyUtils.isCheckScreenForAdInApp) ?? false;

  NativeAd? adxNativeAd;
  bool adxNativeAdLoaded = false;

  NativeAd? adxNativeAd1;
  bool adxNativeAdLoaded1 = false;

  Widget fbNativeAd = const SizedBox();

  bool isLoadingAdsWidget = false;
  @override
  void initState() {
    super.initState();
    initReceiver();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (!kDebugMode) {
        await FirebaseAnalytics.instance.logEvent(name: screenName);
      }
      setState(() {
        isLoadingAdsWidget = true;
      });
      Timer.periodic(const Duration(seconds: 2), (timer) {
        setState(() {
          isLoadingAdsWidget = false;
          timer.cancel();
        });
      });
      final provider = Provider.of<InterstitialAdsWidgetProvider>(context, listen: false);

      myAdsIdClass = await LoadAdsByApi().isAvailableAds(context: context, screenName: screenName);
      setState(() {});
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

  loadAdxNativeAd({String isCalledFrom = 'init'}) async {
    print('Screen name loadNativeAd() ---> $screenName isCalledFrom --> $isCalledFrom ');

    String nativeAdId = myAdsIdClass.googleNativeId; //  AdsUnitId().getGoogleNativeAdId();
    if (nativeAdId != '') {
      setState(() {
        adxNativeAd = NativeAd(
          adUnitId: nativeAdId,
          factoryId: 'listTileMedium',
          request: const AdRequest(),
          listener: NativeAdListener(
            onAdLoaded: (ad) {
              // print("Adddd  is Loadede");
              setState(() {
                adxNativeAdLoaded = true;
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

  @override
  void dispose() {
    receiver.cancel();
    if (adxNativeAd != null) {
      adxNativeAd!.dispose();
    }
    if (adxNativeAd1 != null) {
      adxNativeAd1!.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<dynamic, dynamic>> loanProductsNameList = [
      {"name": LocaleKeys.businessLoan.tr()},
      {"name": LocaleKeys.instantLoan.tr()},
      {"name": LocaleKeys.cashLoan.tr()},
      {"name": LocaleKeys.newHomeLoan.tr()},
      {"name": LocaleKeys.homeConstructionLoan.tr()},
      {"name": LocaleKeys.loanAgainstProperty.tr()},
      {"name": LocaleKeys.securedBusinessLoan.tr()},
      {"name": LocaleKeys.groupLoans.tr()},
    ];
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) {
          return const DashboardScreen();
        }), (route) => false);
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) {
                    return const DashboardScreen();
                  }), (route) => false);
                },
                icon: const Icon(Icons.arrow_back_ios_new_outlined)),
            backgroundColor: ColorUtils.themeColor.oxff447D58,
            centerTitle: true,
            title: Text(
              LocaleKeys.ExploreLoans.tr(),
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
                  child: Column(
                    children: [
                    const SizedBox(height: 10),
                      fbNativeAd,
                      (adxNativeAdLoaded && adxNativeAd != null)
                          ? Container(
                              color: Colors.transparent,
                              height: 275,
                              alignment: Alignment.center,
                              child: AdWidget(ad: adxNativeAd!),
                            )
                          : const SizedBox(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 2,
                          ),
                          itemCount: loanProductsList.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return LoanButtonWidget(
                              title: loanProductsNameList[index]['name'],
                              titleWidget: Image(
                                image: AssetImage(loanProductsList[index]['img']),
                                height: 60,
                              ),
                              onTap: () {
                                getLoanDetails(loanProductsList[index]['name']!);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          )),
    );
  }

  List<Map<dynamic, dynamic>> loanProductsList = [
    {
      'img': AssetUtils.k_group,
      "name": groupLoans,
    },
    {
      'img': AssetUtils.k_cash,
      "name": cashLoan,
    },
    {
      'img': AssetUtils.k_homeLoan,
      "name": newHomeLoan,
    },
    {
      'img': AssetUtils.k_secured,
      "name": securedBusinessLoan,
    },
    {
      'img': AssetUtils.k_home,
      "name": homeConstructionLoan,
    },
    {
      'img': AssetUtils.k_business,
      "name": businessLoan,
    },
    {
      'img': AssetUtils.k_instant,
      "name": instantLoan,
    },
    {
      'img': AssetUtils.k_loan,
      "name": loanAgainstProperty,
    },
  ];

  getLoanDetails(String loanName) {
    receiver.cancel();
    final provider = Provider.of<InterstitialAdsWidgetProvider>(context, listen: false);
    switch (loanName) {
      case cashLoan:
        return provider.showFbOrAdxOrAdmobInterstitialAd(
          myAdsIdClass: myAdsIdClass,
          availableAds: myAdsIdClass.availableAdsList,
          RouteUtils.loanShortDescriptionScreen,
          context,
          googleInterID: myAdsIdClass.googleInterstitialId,
          fbInterID: myAdsIdClass.facebookInterstitialId,
          arguments: LoanDescriptionArguments(
            imgURl: AssetUtils.icCashLoanPng,
            loanName: LocaleKeys.cashLoan.tr(),
            subTitle: LocaleKeys.cashLoanSubTitle.tr(),
            eligibilityCriteria: LocaleKeys.cashLoanEligibilityCriteria.tr(),
            documents: LocaleKeys.cashLoanDocuments.tr(),
            tenureDescription: LocaleKeys.cashLoanTenureDescription.tr(),
            interest: LocaleKeys.cashLoanInterest.tr(),
            loanAmount: LocaleKeys.cashLoanLoanAmount.tr(),
            processingFees: LocaleKeys.cashLoanProcessingFees.tr(),
            buttonLable: LocaleKeys.cashLoanButtonLable.tr(),
            lable1: LocaleKeys.cashLoanLable1.tr(),
            description1: LocaleKeys.cashLoanDescription1.tr(),
            lable2: LocaleKeys.cashLoanLable2.tr(),
            description2: LocaleKeys.cashLoanDescription2.tr(),
            lable3: LocaleKeys.cashLoanLable3.tr(),
            description3: LocaleKeys.cashLoanDescription3.tr(),
            lable4: LocaleKeys.cashLoanLable4.tr(),
            description4: LocaleKeys.cashLoanDescription4.tr(),
            takePoints: parseStringToList(LocaleKeys.cashLoanTakePoints.tr()),
            take: parseStringToList(LocaleKeys.cashLoanTake.tr()),
            notTakePoints: parseStringToList(LocaleKeys.cashLoanNotTakePoints.tr()),
            notTake: parseStringToList(LocaleKeys.cashLoanNotTake.tr()),
          ),
        );

      case businessLoan:
        return provider.showFbOrAdxOrAdmobInterstitialAd(
          myAdsIdClass: myAdsIdClass,
          availableAds: myAdsIdClass.availableAdsList,
          RouteUtils.loanShortDescriptionScreen,
          context,
          googleInterID: myAdsIdClass.googleInterstitialId,
          fbInterID: myAdsIdClass.facebookInterstitialId,
          arguments: LoanDescriptionArguments(
            imgURl: AssetUtils.icBusinessLoan,
            loanName: LocaleKeys.businessLoan.tr(),
            subTitle: LocaleKeys.businessLoanSubTitle.tr(),
            eligibilityCriteria: LocaleKeys.businessLoanEligibilityCriteria.tr(),
            documents: LocaleKeys.businessLoanDocuments.tr(),
            tenureDescription: LocaleKeys.businessLoanTenureDescription.tr(),
            interest: LocaleKeys.businessLoanInterest.tr(),
            loanAmount: LocaleKeys.businessLoanLoanAmount.tr(),
            processingFees: LocaleKeys.businessLoanProcessingFees.tr(),
            buttonLable: LocaleKeys.businessLoanButtonLable.tr(),
            lable1: LocaleKeys.businessLoanLable1.tr(),
            description1: LocaleKeys.businessLoanDescription1.tr(),
            lable2: LocaleKeys.businessLoanLable2.tr(),
            description2: LocaleKeys.businessLoanDescription2.tr(),
            lable3: LocaleKeys.businessLoanLable3.tr(),
            description3: LocaleKeys.businessLoanDescription3.tr(),
            lable4: LocaleKeys.businessLoanLable4.tr(),
            description4: LocaleKeys.businessLoanDescription4.tr(),
            takePoints: parseStringToList(LocaleKeys.businessLoanTakePoints.tr()),
            take: parseStringToList(LocaleKeys.businessLoanTake.tr()),
            notTakePoints: parseStringToList(LocaleKeys.businessLoanNotTakePoints.tr()),
            notTake: parseStringToList(LocaleKeys.businessLoanNotTake.tr()),
          ),
        );

      case newHomeLoan:
        return provider.showFbOrAdxOrAdmobInterstitialAd(
          myAdsIdClass: myAdsIdClass,
          availableAds: myAdsIdClass.availableAdsList,
          RouteUtils.loanShortDescriptionScreen,
          context,
          googleInterID: myAdsIdClass.googleInterstitialId,
          fbInterID: myAdsIdClass.facebookInterstitialId,
          arguments: LoanDescriptionArguments(
            imgURl: AssetUtils.newHomeLoan,
            loanName: LocaleKeys.newHomeLoan.tr(),
            subTitle: LocaleKeys.newHomeLoanSubTitle.tr(),
            eligibilityCriteria: LocaleKeys.newHomeLoanEligibilityCriteria.tr(),
            documents: LocaleKeys.newHomeLoanDocuments.tr(),
            tenureDescription: LocaleKeys.newHomeLoanTenureDescription.tr(),
            interest: LocaleKeys.newHomeLoanInterest.tr(),
            loanAmount: LocaleKeys.newHomeLoanLoanAmount.tr(),
            processingFees: LocaleKeys.newHomeLoanProcessingFees.tr(),
            buttonLable: LocaleKeys.newHomeLoanButtonLable.tr(),
            lable1: LocaleKeys.newHomeLoanLable1.tr(),
            description1: LocaleKeys.newHomeLoanDescription1.tr(),
            lable2: LocaleKeys.newHomeLoanLable2.tr(),
            description2: LocaleKeys.newHomeLoanDescription2.tr(),
            lable3: LocaleKeys.newHomeLoanLable3.tr(),
            description3: LocaleKeys.newHomeLoanDescription3.tr(),
            lable4: LocaleKeys.newHomeLoanLable4.tr(),
            description4: LocaleKeys.newHomeLoanDescription4.tr(),
            takePoints: parseStringToList(LocaleKeys.newHomeLoanTakePoints.tr()),
            take: parseStringToList(LocaleKeys.newHomeLoanTake.tr()),
            notTakePoints: parseStringToList(LocaleKeys.newHomeLoanNotTakePoints.tr()),
            notTake: parseStringToList(LocaleKeys.newHomeLoanNotTake.tr()),
          ),
        );

      case homeConstructionLoan:
        return provider.showFbOrAdxOrAdmobInterstitialAd(
          myAdsIdClass: myAdsIdClass,
          availableAds: myAdsIdClass.availableAdsList,
          RouteUtils.loanShortDescriptionScreen,
          context,
          googleInterID: myAdsIdClass.googleInterstitialId,
          fbInterID: myAdsIdClass.facebookInterstitialId,
          arguments: LoanDescriptionArguments(
            imgURl: AssetUtils.icHomeConstructionLoan,
            loanName: LocaleKeys.homeConstructionLoan.tr(),
            subTitle: LocaleKeys.homeConstructionLoanSubTitle.tr(),
            eligibilityCriteria: LocaleKeys.homeConstructionLoanEligibilityCriteria.tr(),
            documents: LocaleKeys.homeConstructionLoanDocuments.tr(),
            tenureDescription: LocaleKeys.homeConstructionLoanTenureDescription.tr(),
            interest: LocaleKeys.homeConstructionLoanInterest.tr(),
            loanAmount: LocaleKeys.homeConstructionLoanLoanAmount.tr(),
            processingFees: LocaleKeys.homeConstructionLoanProcessingFees.tr(),
            buttonLable: LocaleKeys.homeConstructionLoanButtonLable.tr(),
            lable1: LocaleKeys.homeConstructionLoanLable1.tr(),
            description1: LocaleKeys.homeConstructionLoanDescription1.tr(),
            lable2: LocaleKeys.homeConstructionLoanLable2.tr(),
            description2: LocaleKeys.homeConstructionLoanDescription2.tr(),
            lable3: LocaleKeys.homeConstructionLoanLable3.tr(),
            description3: LocaleKeys.homeConstructionLoanDescription3.tr(),
            lable4: LocaleKeys.homeConstructionLoanLable4.tr(),
            description4: LocaleKeys.homeConstructionLoanDescription4.tr(),
            takePoints: parseStringToList(LocaleKeys.homeConstructionLoanTakePoints.tr()),
            take: parseStringToList(LocaleKeys.homeConstructionLoanTake.tr()),
            notTakePoints: parseStringToList(LocaleKeys.homeConstructionLoanNotTakePoints.tr()),
            notTake: parseStringToList(LocaleKeys.homeConstructionLoanNotTake.tr()),
          ),
        );

      case loanAgainstProperty:
        return provider.showFbOrAdxOrAdmobInterstitialAd(
          myAdsIdClass: myAdsIdClass,
          availableAds: myAdsIdClass.availableAdsList,
          RouteUtils.loanShortDescriptionScreen,
          context,
          googleInterID: myAdsIdClass.googleInterstitialId,
          fbInterID: myAdsIdClass.facebookInterstitialId,
          arguments: LoanDescriptionArguments(
            imgURl: AssetUtils.icLoanAgainstPropertyLoan,
            loanName: LocaleKeys.loanAgainstProperty.tr(),
            subTitle: LocaleKeys.loanAgainstPropertyLoanSubTitle.tr(),
            eligibilityCriteria: LocaleKeys.loanAgainstPropertyLoanEligibilityCriteria.tr(),
            documents: LocaleKeys.loanAgainstPropertyLoanDocuments.tr(),
            tenureDescription: LocaleKeys.loanAgainstPropertyLoanTenureDescription.tr(),
            interest: LocaleKeys.loanAgainstPropertyLoanInterest.tr(),
            loanAmount: LocaleKeys.loanAgainstPropertyLoanLoanAmount.tr(),
            processingFees: LocaleKeys.loanAgainstPropertyLoanProcessingFees.tr(),
            buttonLable: LocaleKeys.loanAgainstPropertyLoanButtonLable.tr(),
            lable1: LocaleKeys.loanAgainstPropertyLoanLable1.tr(),
            description1: LocaleKeys.loanAgainstPropertyLoanDescription1.tr(),
            lable2: LocaleKeys.loanAgainstPropertyLoanLable2.tr(),
            description2: LocaleKeys.loanAgainstPropertyLoanDescription2.tr(),
            lable3: LocaleKeys.loanAgainstPropertyLoanLable3.tr(),
            description3: LocaleKeys.loanAgainstPropertyLoanDescription3.tr(),
            lable4: LocaleKeys.loanAgainstPropertyLoanLable4.tr(),
            description4: LocaleKeys.loanAgainstPropertyLoanDescription4.tr(),
            takePoints: parseStringToList(LocaleKeys.loanAgainstPropertyLoanTakePoints.tr()),
            take: parseStringToList(LocaleKeys.loanAgainstPropertyLoanTake.tr()),
            notTakePoints: parseStringToList(LocaleKeys.loanAgainstPropertyLoanNotTakePoints.tr()),
            notTake: parseStringToList(LocaleKeys.loanAgainstPropertyLoanNotTake.tr()),
          ),
        );

      case securedBusinessLoan:
        return provider.showFbOrAdxOrAdmobInterstitialAd(
          myAdsIdClass: myAdsIdClass,
          availableAds: myAdsIdClass.availableAdsList,
          RouteUtils.loanShortDescriptionScreen,
          context,
          googleInterID: myAdsIdClass.googleInterstitialId,
          fbInterID: myAdsIdClass.facebookInterstitialId,
          arguments: LoanDescriptionArguments(
            imgURl: AssetUtils.icSecuredLoan1,
            loanName: LocaleKeys.securedBusinessLoan.tr(),
            subTitle: LocaleKeys.securedBusinessLoanSubTitle.tr(),
            eligibilityCriteria: LocaleKeys.securedBusinessLoanEligibilityCriteria.tr(),
            documents: LocaleKeys.securedBusinessLoanDocuments.tr(),
            tenureDescription: LocaleKeys.securedBusinessLoanTenureDescription.tr(),
            interest: LocaleKeys.securedBusinessLoanInterest.tr(),
            loanAmount: LocaleKeys.securedBusinessLoanLoanAmount.tr(),
            processingFees: LocaleKeys.securedBusinessLoanProcessingFees.tr(),
            buttonLable: LocaleKeys.securedBusinessLoanButtonLable.tr(),
            lable1: LocaleKeys.securedBusinessLoanLable1.tr(),
            description1: LocaleKeys.securedBusinessLoanDescription1.tr(),
            lable2: LocaleKeys.securedBusinessLoanLable2.tr(),
            description2: LocaleKeys.securedBusinessLoanDescription2.tr(),
            lable3: LocaleKeys.securedBusinessLoanLable3.tr(),
            description3: LocaleKeys.securedBusinessLoanDescription3.tr(),
            lable4: LocaleKeys.securedBusinessLoanLable4.tr(),
            description4: LocaleKeys.securedBusinessLoanDescription4.tr(),
            takePoints: parseStringToList(LocaleKeys.securedBusinessLoanTakePoints.tr()),
            take: parseStringToList(LocaleKeys.securedBusinessLoanTake.tr()),
            notTakePoints: parseStringToList(LocaleKeys.securedBusinessLoanNotTakePoints.tr()),
            notTake: parseStringToList(LocaleKeys.securedBusinessLoanNotTake.tr()),
          ),
        );

      case personalLoan:
        return provider.showFbOrAdxOrAdmobInterstitialAd(
          myAdsIdClass: myAdsIdClass,
          availableAds: myAdsIdClass.availableAdsList,
          RouteUtils.loanShortDescriptionScreen,
          context,
          googleInterID: myAdsIdClass.googleInterstitialId,
          fbInterID: myAdsIdClass.facebookInterstitialId,
          arguments: LoanDescriptionArguments(
            imgURl: AssetUtils.icPersonalLoanImage,
            loanName: LocaleKeys.personalLoan.tr(),
            subTitle: LocaleKeys.personalLoanSubTitle.tr(),
            eligibilityCriteria: LocaleKeys.personalLoanEligibilityCriteria.tr(),
            documents: LocaleKeys.personalLoanDocuments.tr(),
            tenureDescription: LocaleKeys.personalLoanTenureDescription.tr(),
            interest: LocaleKeys.personalLoanInterest.tr(),
            loanAmount: LocaleKeys.personalLoanLoanAmount.tr(),
            processingFees: LocaleKeys.personalLoanProcessingFees.tr(),
            buttonLable: LocaleKeys.personalLoanButtonLable.tr(),
            lable1: LocaleKeys.personalLoanLable1.tr(),
            description1: LocaleKeys.personalLoanDescription1.tr(),
            lable2: LocaleKeys.personalLoanLable2.tr(),
            description2: LocaleKeys.personalLoanDescription2.tr(),
            lable3: LocaleKeys.personalLoanLable3.tr(),
            description3: LocaleKeys.personalLoanDescription3.tr(),
            lable4: LocaleKeys.personalLoanLable4.tr(),
            description4: LocaleKeys.personalLoanDescription4.tr(),
            takePoints: parseStringToList(LocaleKeys.personalLoanTakePoints.tr()),
            take: parseStringToList(LocaleKeys.personalLoanTake.tr()),
            notTakePoints: parseStringToList(LocaleKeys.personalLoanNotTakePoints.tr()),
            notTake: parseStringToList(LocaleKeys.personalLoanNotTake.tr()),
          ),
        );

      case instantLoan:
        return provider.showFbOrAdxOrAdmobInterstitialAd(
          myAdsIdClass: myAdsIdClass,
          availableAds: myAdsIdClass.availableAdsList,
          RouteUtils.loanShortDescriptionScreen,
          context,
          googleInterID: myAdsIdClass.googleInterstitialId,
          fbInterID: myAdsIdClass.facebookInterstitialId,
          arguments: LoanDescriptionArguments(
            imgURl: AssetUtils.icInstantPng,
            loanName: LocaleKeys.instantLoan.tr(),
            subTitle: LocaleKeys.instantLoanSubTitle.tr(),
            eligibilityCriteria: LocaleKeys.instantLoanEligibilityCriteria.tr(),
            documents: LocaleKeys.instantLoanDocuments.tr(),
            tenureDescription: LocaleKeys.instantLoanTenureDescription.tr(),
            interest: LocaleKeys.instantLoanInterest.tr(),
            loanAmount: LocaleKeys.instantLoanLoanAmount.tr(),
            processingFees: LocaleKeys.instantLoanProcessingFees.tr(),
            buttonLable: LocaleKeys.instantLoanButtonLable.tr(),
            lable1: LocaleKeys.instantLoanLable1.tr(),
            description1: LocaleKeys.instantLoanDescription1.tr(),
            lable2: LocaleKeys.instantLoanLable2.tr(),
            description2: LocaleKeys.instantLoanDescription2.tr(),
            lable3: LocaleKeys.instantLoanLable3.tr(),
            description3: LocaleKeys.instantLoanDescription3.tr(),
            lable4: LocaleKeys.instantLoanLable4.tr(),
            description4: LocaleKeys.instantLoanDescription4.tr(),
            takePoints: parseStringToList(LocaleKeys.instantLoanTakePoints.tr()),
            take: parseStringToList(LocaleKeys.instantLoanTake.tr()),
            notTakePoints: parseStringToList(LocaleKeys.instantLoanNotTakePoints.tr()),
            notTake: parseStringToList(LocaleKeys.instantLoanNotTake.tr()),
          ),
        );

      case levelUpLoans:
        return provider.showFbOrAdxOrAdmobInterstitialAd(
          myAdsIdClass: myAdsIdClass,
          availableAds: myAdsIdClass.availableAdsList,
          RouteUtils.loanShortDescriptionScreen,
          context,
          googleInterID: myAdsIdClass.googleInterstitialId,
          fbInterID: myAdsIdClass.facebookInterstitialId,
          arguments: LoanDescriptionArguments(
            imgURl: AssetUtils.icLevelUpLoanPng,
            loanName: LocaleKeys.levelUpLoans.tr(),
            subTitle: LocaleKeys.levelUpLoansSubTitle.tr(),
            eligibilityCriteria: LocaleKeys.levelUpLoansEligibilityCriteria.tr(),
            documents: LocaleKeys.levelUpLoansDocuments.tr(),
            tenureDescription: LocaleKeys.levelUpLoansTenureDescription.tr(),
            interest: LocaleKeys.levelUpLoansInterest.tr(),
            loanAmount: LocaleKeys.levelUpLoansLoanAmount.tr(),
            processingFees: LocaleKeys.levelUpLoansProcessingFees.tr(),
            buttonLable: LocaleKeys.levelUpLoansButtonLable.tr(),
            lable1: LocaleKeys.levelUpLoansLable1.tr(),
            description1: LocaleKeys.levelUpLoansDescription1.tr(),
            lable2: LocaleKeys.levelUpLoansLable2.tr(),
            description2: LocaleKeys.levelUpLoansDescription2.tr(),
            lable3: LocaleKeys.levelUpLoansLable3.tr(),
            description3: LocaleKeys.levelUpLoansDescription3.tr(),
            lable4: LocaleKeys.levelUpLoansLable4.tr(),
            description4: LocaleKeys.levelUpLoansDescription4.tr(),
            takePoints: parseStringToList(LocaleKeys.levelUpLoansTakePoints.tr()),
            take: parseStringToList(LocaleKeys.levelUpLoansTake.tr()),
            notTakePoints: parseStringToList(LocaleKeys.levelUpLoansNotTakePoints.tr()),
            notTake: parseStringToList(LocaleKeys.levelUpLoansNotTake.tr()),
          ),
        );

      case digitalGoldGuidance:
        return provider.showFbOrAdxOrAdmobInterstitialAd(
          myAdsIdClass: myAdsIdClass,
          availableAds: myAdsIdClass.availableAdsList,
          RouteUtils.dashboardMoreLoansScreen,
          context,
          googleInterID: myAdsIdClass.googleInterstitialId,
          fbInterID: myAdsIdClass.facebookInterstitialId,
          arguments: LoanDescriptionArguments(
            loanName: LocaleKeys.digitalGoldGuidance.tr(),
            titleList: parseStringToList(LocaleKeys.digitalGoldGuidanceTitleList.tr()),
            titleOverViewList: parseStringToList(LocaleKeys.digitalGoldGuidanceTitleOverViewList.tr()),
          ),
        );

      case mutualFundsGuidance:
        return provider.showFbOrAdxOrAdmobInterstitialAd(
          myAdsIdClass: myAdsIdClass,
          availableAds: myAdsIdClass.availableAdsList,
          RouteUtils.dashboardMoreLoansScreen,
          context,
          googleInterID: myAdsIdClass.googleInterstitialId,
          fbInterID: myAdsIdClass.facebookInterstitialId,
          arguments: LoanDescriptionArguments(
            loanName: LocaleKeys.mutualFundsGuidance.tr(),
            titleList: parseStringToList(LocaleKeys.mutualFundsGuidanceTitleList.tr()),
            titleOverViewList: parseStringToList(LocaleKeys.mutualFundsGuidanceTitleOverViewList.tr()),
          ),
        );

      case groupLoans:
        return provider.showFbOrAdxOrAdmobInterstitialAd(
          myAdsIdClass: myAdsIdClass,
          availableAds: myAdsIdClass.availableAdsList,
          RouteUtils.loanShortDescriptionScreen,
          googleInterID: myAdsIdClass.googleInterstitialId,
          fbInterID: myAdsIdClass.facebookInterstitialId,
          context,
          arguments: LoanDescriptionArguments(
            imgURl: AssetUtils.icGroupLoan,
            loanName: LocaleKeys.levelUpLoans.tr(),
            subTitle: LocaleKeys.levelUpLoansSubTitle.tr(),
            eligibilityCriteria: LocaleKeys.levelUpLoansEligibilityCriteria.tr(),
            documents: LocaleKeys.levelUpLoansDocuments.tr(),
            tenureDescription: LocaleKeys.levelUpLoansTenureDescription.tr(),
            interest: LocaleKeys.levelUpLoansInterest.tr(),
            loanAmount: LocaleKeys.levelUpLoansLoanAmount.tr(),
            processingFees: LocaleKeys.levelUpLoansProcessingFees.tr(),
            buttonLable: LocaleKeys.levelUpLoansButtonLable.tr(),
            lable1: LocaleKeys.levelUpLoansLable1.tr(),
            description1: LocaleKeys.levelUpLoansDescription1.tr(),
            lable2: LocaleKeys.levelUpLoansLable2.tr(),
            description2: LocaleKeys.levelUpLoansDescription2.tr(),
            lable3: LocaleKeys.levelUpLoansLable3.tr(),
            description3: LocaleKeys.levelUpLoansDescription3.tr(),
            lable4: LocaleKeys.levelUpLoansLable4.tr(),
            description4: LocaleKeys.levelUpLoansDescription4.tr(),
            takePoints: parseStringToList(LocaleKeys.levelUpLoansTakePoints.tr()),
            take: parseStringToList(LocaleKeys.levelUpLoansTake.tr()),
            notTakePoints: parseStringToList(LocaleKeys.levelUpLoansNotTakePoints.tr()),
            notTake: parseStringToList(LocaleKeys.levelUpLoansNotTake.tr()),
          ),
        );
      default:
    }
  }

  List<String> parseStringToList(String inputString) {
    List<String> resultList = inputString.substring(1, inputString.length - 2).split("','");
    return resultList;
  }

//   getLoanDetails(String loanName) {
//     if (receiver != null) {
  //   receiver.cancel();
  // }

//     final provider =
//         Provider.of<InterstitialAdsWidgetProvider>(context, listen: false);
//     switch (loanName) {
//       case cashLoan:
//         return provider.showFbOrAdxOrAdmobInterstitialAd(
//           availableAds: myAdsIdClass.availableAdsList,
//           RouteUtils.loanShortDescriptionScreen,
//           context,
//           googleInterID: myAdsIdClass.googleInterstitialId,
//           fbInterID: myAdsIdClass.facebookInterstitialId,
//           arguments: LoanDescriptionArguments(
//             sortDescriptionAppBarTitle: cashLoan,
//             loanName: cashLoan,
//             subTitle:
//                 '''○ A cash loan is a type of loan where the borrower receives the money in cash, usually from a bank or lender.

// ○ The loan is typically repaid over a specified period of time with interest.

// ○ A cash loan, also known as a cash advance or payday loan, is a short-term loan designed to provide borrowers with immediate cash in times of urgent financial need. It is typically a small loan amount that is repaid within a short period, usually on the borrower's next payday.

// ○ Cash loans are commonly offered by specialized lenders, both in physical storefronts and online platforms. The application process is often quick and straightforward, with minimal documentation and credit checks.

// ○ Borrowers are typically required to provide proof of income, identification, and a post-dated check or authorization to withdraw funds from their bank account.
// ''',
//             eligibilityCriteria: '''○ Age - 18 Years Old

// ○ Income - source of income, such as a Job or Business

// ○ Credit history - A higher credit history

// ○ Bank account - Valid bank account with their name''',
//             documents:
//                 '''○ ID proof - Aadhaar card, passport, driving license, etc.

// ○ Address proof (electricity bill, phone bill, etc.

// ○ Income proof (salary slips, bank statements, etc.

// ○ Passport-sized photographs''',
//             tenureDescription:
//                 '''○ A short tenures, usually ranging from a few weeks to a few months

// ○ The tenure or repayment period for cash loans is typically short due to their nature as short-term loans. Cash loans are designed to provide borrowers with immediate funds to cover their urgent financial needs until their next payday. As a result, the repayment period for cash loans is usually very brief, typically ranging from a few weeks to a few months.

// ○ The exact tenure of a cash loan can vary depending on the lender and the specific terms and conditions of the loan agreement. It is common for the repayment date to be aligned with the borrower's next payday. This means that the loan is expected to be repaid in full, including the principal amount and any applicable interest or fees, on the borrower's next income receipt.

// ''',
//             interest: '''○ Approximately 10% to 24% per annum''',
//             loanAmount: '''○ Based on borrower needs and eligibility''',
//             processingFees: '''○ Approximately 2% to 3% of the loan amount''',
//             fullDescriptionAppBarTitle: cashLoan,
//             buttonLable: 'Know More about Cash Loan',
//             imgURl: AssetUtils.icCashLoanPng,
//             lable1: 'What is concept of a Cash Loan?',
//             description1:
//                 '''○ A cash loan, also known as a payday loan or a short-term loan, is a type of borrowing where the lender provides the borrower with a small amount of cash, typically up to a few thousand dollars, to be repaid within a short period, usually within a month or two.

// ○ Cash loans are often unsecured, meaning they do not require collateral or a credit check, but they come with high interest rates and fees.

// ○ They are typically used by individuals who need quick cash to cover unexpected expenses, such as car repairs or medical bills, and who cannot wait until their next paycheck.

// ○ It's important to carefully consider the terms and conditions of a cash loan before borrowing, as high interest rates and fees can quickly add up and make it difficult to repay the loan on time.

// ○ It's also important to explore other options for borrowing or financial assistance, such as personal loans or assistance programs, before turning to a cash loan.''',
//             lable2: 'Highlights and Advantages:',
//             description2:
//                 '''○ Quick access to cash: One of the main advantages of cash loans is that they provide borrowers with quick access to cash when they need it the most. In many cases, borrowers can receive funds within 24 hours of applying for a loan.

// ○ Easy application process: Applying for a cash loan is usually a simple and straightforward process. Many lenders offer online applications, making it easy for borrowers to apply from the comfort of their own homes.

// ○ No collateral required: Unlike other types of loans, such as secured loans, cash loans typically do not require collateral. This means that borrowers don't have to put up any assets as security to obtain a loan.

// ○ Flexible repayment options: Many cash loan lenders offer flexible repayment options, allowing borrowers to choose a repayment plan that works best for them. This can include options such as installment payments or deferred payments.

// ○ No credit check required: In some cases, cash loan lenders may not require a credit check to approve a loan. This can make it easier for borrowers with poor credit histories to obtain a loan.

// ○ Helps cover unexpected expenses: Cash loans can be a useful tool for covering unexpected expenses, such as car repairs or medical bills. They can provide borrowers with the funds they need to pay for these expenses without having to rely on credit cards or other forms of debt.''',
//             lable3: 'Risks and considerations:',
//             description3:
//                 '''○ High interest rates: Cash loans typically come with high interest rates and fees, which can add up quickly if the loan is not repaid promptly. Borrowers should carefully consider the total cost of the loan, including interest and fees, before agreeing to the terms.

// ○ Short repayment periods: Cash loans are usually short-term loans, with repayment periods ranging from a few weeks to a few months. This can make it difficult for borrowers to repay the loan on time, especially if they are facing other financial challenges.

// ○ Risk of default: If a borrower is unable to repay a cash loan on time, they may face additional fees and charges, and their credit score may be negatively impacted. In some cases, the lender may take legal action to collect the debt, which can result in wage garnishment or other consequences.

// ○ Potential for repeat borrowing: Because cash loans are often easy to obtain, some borrowers may find themselves repeatedly borrowing to cover their expenses, leading to a cycle of debt.

// ○ Alternative options may be available: Before taking out a cash loan, borrowers should consider other options, such as borrowing from friends or family, negotiating with creditors, or seeking assistance from non-profit organizations.''',
//             lable4: 'TERMS & CONDITIONS:',
//             description4:
//                 '''○ The terms and conditions of a cash loan typically include information such as the loan amount, interest rate, repayment period, fees and charges, consequences of default or late payments, and the lender's policies on renewals, extensions, and early repayment.

// ○ It's important for borrowers to carefully read and understand the terms and conditions before agreeing to a loan.''',
//             takePoints: [
//               'Emergency expenses',
//               'Convenience',
//               'Build credit',
//               'Large purchases',
//               'Debt consolidation',
//             ],
//             take: [
//               'A cash loan can be helpful for covering unexpected expenses, such as car repairs, medical bills, or home repairs.',
//               'Cash loans are often easy to apply for and can provide quick access to funds.',
//               'If someone has a low credit score or no credit history, taking out a cash loan and repaying it on time can help build their credit.',
//               'A cash loan can be a good option for making large purchases, such as buying a car or paying for a home renovation.',
//               'A cash loan can be used to consolidate high-interest debt into a single, more manageable loan.',
//             ],
//             notTakePoints: [
//               'High interest rates',
//               'Risk of debt cycle',
//               'Additional fees',
//               'Impact on credit score',
//               'Alternative options',
//             ],
//             notTake: [
//               'Cash loans often have high interest rates, which can make them expensive to repay over time.',
//               'If someone is unable to repay the loan on time, they could fall into a cycle of debt and financial hardship.',
//               'Some cash loans may have additional fees, such as origination fees or prepayment penalties, which can add to the cost of the loan.',
//               'If someone is unable to repay the loan on time, it could negatively impact their credit score.',
//               'Depending on the specific situation, there may be alternative options to a cash loan, such as borrowing from family or friends, negotiating with creditors, or using savings.',
//             ],
//           ),
//         );

//       case businessLoan:
//         return provider.showFbOrAdxOrAdmobInterstitialAd(
//           availableAds: myAdsIdClass.availableAdsList,
//           RouteUtils.loanShortDescriptionScreen,
//           context,
//           googleInterID: myAdsIdClass.googleInterstitialId,
//           fbInterID: myAdsIdClass.facebookInterstitialId,
//           arguments: LoanDescriptionArguments(
//             sortDescriptionAppBarTitle: businessLoan,
//             loanName: businessLoan,
//             subTitle:
//                 '''A business loan is a type of financing that provides funds to businesses for various purposes, such as expansion, inventory purchases, or working capital.

// The loan terms and amount are typically based on the borrower's creditworthiness, business history, and the lender's requirements.

// A business loan is a financial product designed to provide funds to businesses for various purposes. It is typically offered by banks, financial institutions, or alternative lenders.''',
//             eligibilityCriteria: '''○ Age - 18 Years Old

// ○ Income - source of income, such as a Job or Business

// ○ Credit history - A higher credit history

// ○ Bank account - Valid bank account with their name''',
//             documents: '''○ Business plan

// ○ Business financial statements (balance sheet, income statement, cash flow statement)

// ○ Personal financial statements of business owners

// ○ Tax returns for the business and business owners

// ○ Business registration documents (articles of incorporation, partnership agreement, etc.)

// ○ Bank statements for the business

// ○ Accounts receivable and payable statements

// ○ Sales and revenue projections

// ○ Business licenses and permits

// ○ Collateral documentation (if required)

// ○ Legal documentation (such as contracts or leases)''',
//             tenureDescription:
//                 '''○ A short tenures, usually ranging from a few months to a few years
// ○ Short-Term Business Loans: These loans usually have a tenure of 1 year or less. They are suitable for fulfilling short-term working capital needs, managing cash flow gaps, purchasing inventory, or meeting immediate business expenses.

// ○ Medium-Term Business Loans: These loans typically have a tenure ranging from 1 to 5 years. They are commonly used for purchasing equipment, expanding operations, implementing technology upgrades, or financing medium-term business projects.

// ○ Long-Term Business Loans: These loans have a tenure exceeding 5 years, sometimes up to 10 years or more. They are suitable for major business expansions, acquiring assets or properties, undertaking large-scale projects, or financing long-term business strategies.

// ''',
//             interest: '''○ Approximately 10% to 30% per annum''',
//             loanAmount: '''○ Based on borrower needs and eligibility
// ○ Lenders offer Business Loans ranging from Rs. 50,000 to Rs. 50,00,000 or more.''',
//             processingFees: '''○ Approximately 0.5% to 3% of the loan amount''',
//             fullDescriptionAppBarTitle: businessLoan,
//             buttonLable: 'Know More about Business Loan',
//             imgURl: AssetUtils.icBusinessLoan,
//             lable1: 'What is concept of a Business Loan?',
//             description1:
//                 '''○ A business loan is a type of loan that is specifically designed for businesses to access financing to cover their expenses, expand their operations, or invest in new opportunities. Business loans are typically offered by banks, credit unions, or online lenders and can be secured or unsecured.

// ○ Secured business loans require collateral, such as property, equipment, or inventory, to secure the loan. If the borrower is unable to repay the loan, the lender can seize the collateral to recover their losses. Unsecured business loans do not require collateral, but may have higher interest rates and stricter eligibility requirements.

// ○ Business loans can come in various forms, including term loans, lines of credit, and invoice financing. Term loans are typically used for a specific purpose, such as purchasing equipment or funding a new project, and are repaid over a set period of time with interest.

// ○ Lines of credit provide businesses with access to a revolving credit line, which they can use as needed to cover expenses. Invoice financing allows businesses to receive an advance on their outstanding invoices, which can help them manage their cash flow.''',
//             lable2: 'Highlights and Advantages:',
//             description2:
//                 '''○ Flexibility: Business loans offer a wide range of options, including term loans, lines of credit, and invoice financing, that can be tailored to a business's specific needs.

// ○ Access to capital: Business loans provide businesses with access to the capital they need to invest in growth opportunities, expand their operations, or cover unexpected expenses.

// ○ Low-interest rates: Business loans often have lower interest rates than other types of financing, such as credit cards or merchant cash advances, which can help businesses save money on interest charges.

// ○ Improve cash flow: Business loans can help businesses manage their cash flow by providing them with the capital they need to cover expenses while waiting for payments from customers.

// ○ Build credit: By taking out and repaying a business loan on time, businesses can build their credit and improve their eligibility for future financing.

// ○ Retain ownership: Unlike equity financing, which requires businesses to give up a portion of ownership in exchange for funding, business loans allow businesses to retain full ownership.

// ○ Tax benefits: Interest payments on business loans are tax-deductible, which can help businesses save money on their taxes.''',
//             lable3: 'Risks and considerations:',
//             description3:
//                 '''○ Risk of default: Taking on debt means that a business is obligated to repay the loan, even if their cash flow or revenue takes a hit. Failure to repay the loan can result in default, which can damage the business's credit score and ability to obtain future financing.

// ○ High-interest rates: While business loans generally offer lower interest rates than other types of financing, such as credit cards, they can still have higher rates than other forms of financing, such as equity financing.

// ○ Collateral requirements: Some business loans may require collateral, such as property or equipment, to secure the loan. If the business is unable to repay the loan, they risk losing the collateral.

// ○ Fees and charges: Business loans may come with fees and charges, such as origination fees, prepayment penalties, and application fees, that can increase the cost of borrowing.

// ○ Impact on cash flow: Repaying a business loan can have an impact on a business's cash flow, which can affect their ability to cover other expenses and invest in growth opportunities.

// ○ Eligibility requirements: Business loans may have strict eligibility requirements, such as minimum credit scores or revenue thresholds, that can make it difficult for some businesses to qualify.

// ○ Dependence on debt: Relying too heavily on debt financing can put a business at risk of over-leveraging, which can limit their ability to obtain future financing and make it more difficult to manage their debt.''',
//             lable4: 'TERMS & CONDITIONS:',
//             description4:
//                 '''○ Loan amount: The loan amount is the total amount of money the lender will provide to the business.

// ○ Interest rate: The interest rate is the percentage of the loan amount that the business will pay back to the lender in addition to the principal amount.

// ○ Repayment term: The repayment term is the length of time the business will have to repay the loan.

// ○ Collateral requirements: Some loans may require the business to provide collateral, such as property or equipment, to secure the loan.

// ○ Fees and charges: Business loans may come with fees and charges, such as origination fees, prepayment penalties, and application fees.

// ○ Eligibility requirements: Lenders may have strict eligibility requirements, such as minimum credit scores or revenue thresholds, that businesses must meet in order to qualify for a loan.

// ○ Use of funds: Some lenders may require businesses to specify how they plan to use the loan funds.

// ○ Default and collection: The terms and conditions of the loan will outline the consequences of defaulting on the loan and the steps the lender can take to collect the debt.

// ○ Early repayment: The terms and conditions will also specify whether or not the loan can be repaid early, and if so, whether there are any penalties or fees associated with early repayment.''',
//             take: [
//               'If your business is growing and you need additional funds to expand your operations, a business loan can provide the necessary capital.',
//               'If your business is experiencing cash flow issues and you need money to cover expenses like payroll, rent, or inventory, a business loan can help provide the necessary cash flow.',
//               'If your business needs to purchase expensive equipment or machinery, a business loan can help cover the costs.',
//               'If your business experiences seasonal fluctuations in revenue, a business loan can help provide the necessary funds during slow periods.',
//               'If there are investment opportunities that can help your business grow, but you don\'t have the necessary capital, a business loan can help finance these opportunities.',
//             ],
//             takePoints: [
//               'Expansion',
//               'Working capital',
//               'Equipment purchase',
//               'Seasonal fluctuations',
//               'Investment opportunities',
//             ],
//             notTakePoints: [
//               'High interest rates',
//               'Debt burden',
//               'Risk of default',
//               'Collateral requirements',
//               'Alternative funding sources',
//             ],
//             notTake: [
//               'Business loans can have high interest rates, which can add up to a significant amount of money over time. It\'s important to carefully consider the costs of the loan before taking it.',
//               'Taking on too much debt can be a burden on your business and make it difficult to repay the loan. It\'s important to ensure that your business has the cash flow to make loan payments.',
//               'If your business is unable to repay the loan, it can negatively impact your credit score and make it difficult to obtain future loans or financing.',
//               'Some business loans require collateral, which can put your business assets at risk if you are unable to repay the loan.',
//               'There may be alternative funding sources available, such as crowdfunding or angel investors, that can provide the necessary capital without the risks associated with business loans.',
//             ],
//           ),
//         );

//       case newHomeLoan:
//         return provider.showFbOrAdxOrAdmobInterstitialAd(
//           availableAds: myAdsIdClass.availableAdsList,
//           RouteUtils.loanShortDescriptionScreen,
//           context,
//           googleInterID: myAdsIdClass.googleInterstitialId,
//           fbInterID: myAdsIdClass.facebookInterstitialId,
//           arguments: LoanDescriptionArguments(
//             sortDescriptionAppBarTitle: newHomeLoan,
//             loanName: newHomeLoan,
//             subTitle:
//                 '''○ A New Home Loan is a financial product designed for individuals who want to purchase a new house or apartment.

// ○ This loan is suitable for first-time home buyers, as well as those looking to upgrade their current living situation.

// ○ Home Loans offer the flexibility of long repayment tenure and can be secured or unsecured based on the borrower's creditworthiness.

// ○ The borrower needs to pay an interest rate on the borrowed amount, which is spread over the tenure of the loan.

// ○ A new home loan, also known as a mortgage or housing loan, is a financial product designed to assist individuals or families in purchasing a new residential property. It is one of the most common ways for individuals to finance the purchase of a home.

// ○ When applying for a new home loan, borrowers work with banks, financial institutions, or specialized mortgage lenders. The loan amount is typically based on the property's value, the borrower's creditworthiness, and their ability to make a down payment. The lender evaluates the borrower's financial situation, income, credit history, and other factors to determine their eligibility and the loan terms.

// ''',
//             eligibilityCriteria: '''○ The borrower should be an Indian citizen

// ○ The minimum age of the borrower should be 21 years and the maximum age should be 65 years

// ○ The borrower should have a stable source of income and a good credit score

// ○ The borrower should have a minimum work experience of 2 years''',
//             documents:
//                 '''○ Income proof, such as salary slips or income tax returns

// ○ Identity and address proof, such as Aadhar Card, PAN Card, Voter ID, or Passport

// ○ Property documents, such as sale deed, agreement of sale, or construction agreement

// ○ Bank statements for the past 6 to 12 months

// ○ Employment proof, such as appointment letter, experience letter, or company ID card''',
//             tenureDescription:
//                 '''○ A short tenures, usually ranging from a 5 to 30 years

// ○ The borrower can choose the tenure based on their repayment capacity and financial goals.''',
//             interest: '''○ Approximately 6% to 12%. per annum''',
//             loanAmount: '''○ Based on borrower needs and eligibility

// ○ Generally, lenders offer Home Loans ranging from Rs. 1 lakh to Rs. 10 crores or more, depending on the property value and repayment capacity of the borrower.''',
//             processingFees:
//                 '''○ New Home Loan may vary depending on the lender and the loan amount

// ○ Approximately from 0.5% to 1% of the loan amount''',
//             fullDescriptionAppBarTitle: newHomeLoan,
//             buttonLable: 'Know More about New Home Loan',
//             imgURl: AssetUtils.newHomeLoan,
//             lable1: 'What is concept of a New Home Loan?',
//             description1:
//                 '''○ A New Home Loan is a type of loan that is used to finance the purchase of a new home.

// ○ It is a long-term loan that is typically repaid over a period of 15 to 30 years, and is secured by the property being purchased.

// ○ The loan is provided by a lender, such as a bank or mortgage company, and the terms and conditions of the loan will vary depending on the lender and the borrower's creditworthiness.

// ○ In order to qualify for a New Home Loan, the borrower will typically need to have a good credit score, a steady income, and a down payment. The down payment is typically a percentage of the purchase price of the home, and is paid upfront by the borrower.

// ○ The higher the down payment, the lower the loan amount and monthly payments will be.''',
//             lable2: 'Highlights and Advantages:',
//             description2:
//                 '''○ Affordable financing: A New Home Loan allows borrowers to finance the purchase of a new home with a relatively low down payment and a long repayment term. This can make home ownership more affordable and accessible to a wider range of people.

// ○ Fixed interest rates: Many New Home Loans offer fixed interest rates, which means that the interest rate on the loan will not change over the life of the loan. This provides borrowers with stability and predictability in their monthly payments.

// ○ Tax benefits: Homeowners may be eligible for certain tax benefits, such as deducting mortgage interest and property taxes from their taxable income. These tax benefits can help reduce the overall cost of homeownership.

// ○ Building equity: With each mortgage payment, homeowners build equity in their home. Equity is the difference between the home's market value and the outstanding mortgage balance. Building equity can provide homeowners with a valuable asset that can be used in the future, such as for home improvements or as collateral for other loans.

// ○ Ownership: Perhaps the most significant advantage of a New Home Loan is the opportunity to own a home. Homeownership provides individuals and families with stability, security, and a sense of pride in their community.''',
//             lable3: 'Risks and considerations:',
//             description3:
//                 '''○ Interest rate risk: Interest rates on home loans can fluctuate over time, which means that if you have a variable rate loan, your repayments may increase if rates go up. You should consider the impact of rising interest rates on your ability to repay the loan.

// ○ Credit risk: If you default on your home loan repayments, you risk damaging your credit score, which can affect your ability to access credit in the future.

// ○ Property value risk: If the value of your property decreases, you may end up owing more on your home loan than your property is worth. This is known as negative equity and can make it difficult to sell or refinance your property.

// ○ Fees and charges: Home loans may come with a range of fees and charges, including application fees, ongoing fees, and exit fees. These fees can add up over time and increase the overall cost of your loan.

// ○ Affordability: It's important to ensure that you can afford the repayments on your new home loan. You should consider your income, expenses, and other financial commitments before taking out a new loan.

// ○ Loan features: Different home loans come with different features, such as offset accounts, redraw facilities, and fixed or variable interest rates. It's important to understand the features of the loan you are considering and how they might impact your financial situation.

// ○ Lender reputation: Before choosing a lender, it's important to do your research and ensure that the lender has a good reputation for customer service, transparency, and ethical lending practices.''',
//             lable4: 'TERMS & CONDITIONS:',
//             description4:
//                 '''○ Interest rate: This is the rate at which the lender will charge you interest on the loan. It may be a fixed rate or a variable rate, and may be subject to change over time.

// ○ Loan term: This is the length of time over which you will repay the loan. Home loans typically have terms of 15-30 years.

// ○ Repayment schedule: This is the schedule of repayments that you will make to the lender. It may be weekly, fortnightly, or monthly.

// ○ Fees and charges: Home loans may come with a range of fees and charges, including application fees, ongoing fees, and exit fees. These fees can vary depending on the lender and the loan product.

// ○ Loan amount: This is the amount of money that you are borrowing from the lender.

// ○ Security: The lender will require security for the loan, which is usually the property that you are purchasing. This means that if you default on the loan, the lender may be able to sell the property to recover the outstanding debt.

// ○ Prepayment penalties: Some lenders may charge a penalty if you pay off the loan early, or make additional repayments above the minimum required.

// ○ Insurance: The lender may require you to take out home insurance to protect the property and the loan.

// ○ Default: The terms and conditions will outline the consequences of defaulting on the loan, which may include foreclosure or legal action.''',
//             take: [
//               'If you\'re renting a home or apartment, taking out a home loan can help you become a homeowner and build equity in a property.',
//               'Home loan interest rates are currently low, which can make it an attractive time to take out a loan.',
//               'Homeowners can deduct mortgage interest from their taxes, which can provide significant tax benefits.',
//               'A home can also be seen as an investment opportunity, as its value may appreciate over time, allowing you to build wealth.',
//               'Taking out a home loan can provide funds to make necessary home improvements or repairs, which can increase the value of your property.',
//             ],
//             takePoints: [
//               'Home Ownership',
//               'Low interest rates',
//               'Tax benefits',
//               'Investment opportunity',
//               'Home improvement',
//             ],
//             notTakePoints: [
//               'Affordability',
//               'Long-term commitment',
//               'Risk of default',
//               'Maintenance costs',
//               'Alternative housing options',
//             ],
//             notTake: [
//               'Before taking out a home loan, it\'s important to ensure that you can afford the monthly payments. This will depend on your income, expenses, and other financial obligations.',
//               'A home loan is a long-term commitment, usually spanning several decades. It\'s important to consider whether you\'re ready for this level of commitment before taking out a loan.',
//               'If you\'re unable to make your mortgage payments, you may be at risk of defaulting on your loan. This can result in foreclosure and the loss of your home.',
//               'As a homeowner, you\'ll be responsible for maintenance and repairs on your property. It\'s important to consider these costs when deciding whether or not to take out a home loan.',
//               'There may be alternative housing options available, such as renting or downsizing, that can provide a more affordable and flexible housing solution.',
//             ],
//           ),
//         );

//       case homeConstructionLoan:
//         return provider.showFbOrAdxOrAdmobInterstitialAd(
//           availableAds: myAdsIdClass.availableAdsList,
//           RouteUtils.loanShortDescriptionScreen,
//           context,
//           googleInterID: myAdsIdClass.googleInterstitialId,
//           fbInterID: myAdsIdClass.facebookInterstitialId,
//           arguments: LoanDescriptionArguments(
//             sortDescriptionAppBarTitle: homeConstructionLoan,
//             loanName: homeConstructionLoan,
//             subTitle:
//                 '''○ A Home Construction Loan is a type of loan that is designed to help individuals finance the construction of their dream home.

// ○ This loan is suitable for individuals who own a piece of land and want to build a house on it.

// ○ The loan amount is disbursed in stages, as per the construction progress, and is secured against the property being constructed.

// ○ The borrower needs to pay an interest rate on the borrowed amount, which is spread over the tenure of the loan.

// ○ A new home construction loan is a type of financing specifically designed to fund the construction of a new residential property. It provides borrowers with the necessary funds to build their dream home from the ground up.

// ○ When applying for a new home construction loan, borrowers work with banks, financial institutions, or specialized construction lenders. The loan amount is based on the estimated cost of construction, including materials, labor, permits, and other related expenses. The lender assesses the borrower's financial situation, creditworthiness, and the construction plans to determine eligibility and loan terms.

// ''',
//             eligibilityCriteria: '''○ The borrower should be an Indian citizen

// ○ The borrower should own the land on which the construction is to be done

// ○ The borrower should have a stable source of income and a good credit score

// ○ The borrower should have a minimum work experience of 2 years

// ○ The property should have a clear title and necessary approvals from the local authorities''',
//             documents:
//                 '''○ Income proof, such as salary slips or income tax returns

// ○ Identity and address proof, such as Aadhar Card, PAN Card, Voter ID, or Passport

// ○ Property documents, such as sale deed, land records, or construction agreement

// ○ Building plan and layout approval from the local authorities

// ○ Bank statements for the past 6 to 12 months

// ○ Employment proof, such as appointment letter, experience letter, or company ID card''',
//             tenureDescription:
//                 '''○ A short tenures, usually ranging from 10 to 30 years.

// ○ The borrower can choose the tenure based on their repayment capacity and financial goals.

// ○ The tenure or repayment period for a new home construction loan can vary depending on the lender and the specific terms of the loan agreement. Unlike traditional home loans that typically have long repayment tenures of 15 to 30 years, the tenure for a new home construction loan is typically shorter and more flexible.
// ''',
//             interest: '''○ Approximately 7% to 12% per annum''',
//             loanAmount: '''○ Based on borrower needs and eligibility
// ○ Generally, lenders offer Home Construction Loans ranging from Rs. 1 lakh to Rs. 10 crores or more''',
//             processingFees:
//                 '''○ Approximately ranging from 0.5% to 1% of the loan amount''',
//             fullDescriptionAppBarTitle: homeConstructionLoan,
//             buttonLable: 'Know More about Home Construction Loan',
//             imgURl: AssetUtils.icHomeConstructionLoan,
//             lable1: 'What is concept of a Home Construction Loan?',
//             description1:
//                 '''○ A Home Construction Loan is a type of loan that is designed to help finance the construction of a new home or the renovation of an existing home. This type of loan is typically used by borrowers who are building their own home or working with a builder to construct a new property.

// ○ The loan is generally divided into two stages: the construction phase and the repayment phase. During the construction phase, the borrower can access funds as needed to pay for the construction costs, such as materials and labor. The amount of funds available will depend on the value of the property being built and the estimated cost of the construction.

// ○ Once construction is complete, the loan enters the repayment phase, during which time the borrower makes regular repayments to pay off the loan. The repayment period can vary depending on the lender and the loan agreement, but is typically between 15-30 years.''',
//             lable2: 'Highlights and Advantages:',
//             description2:
//                 '''○ Access to funds as needed: With a Home Construction Loan, borrowers can access funds as needed during the construction phase, which can help to manage the costs of building a new home or renovating an existing property.

// ○ Interest-only payments: During the construction phase, borrowers only pay interest on the funds they have used, which can help to manage cash flow.

// ○ Flexible repayment terms: Home Construction Loans offer flexible repayment terms, allowing borrowers to choose a repayment period that suits their financial situation.

// ○ Lower interest rates: Home Construction Loans may offer lower interest rates than other types of construction financing, such as credit cards or personal loans.

// ○ Customizable loan terms: Borrowers can customize the loan terms to meet their specific needs, such as the amount of the loan, the repayment period, and the interest rate.

// ○ Improved property value: Building a new home or renovating an existing property can improve the value of the property, which can be beneficial for the borrower in the long term.

// ○ Tailored to the project: Home Construction Loans are tailored to the specific project, which means that the lender will consider the unique features of the property and the construction plan when determining the loan amount and repayment terms.''',
//             lable3: 'Risks and considerations:',
//             description3:
//                 '''○ Construction delays: Construction projects can be subject to delays and unexpected expenses, which can result in cost overruns and delays in repayment.

// ○ Cost overruns: Building or renovating a property can be expensive, and costs can quickly escalate beyond the estimated budget. This can result in the borrower having to take on additional debt or repayments that are higher than anticipated.

// ○ Interest rate increases: Interest rates on Home Construction Loans can be variable, which means that they can fluctuate over time. This can result in higher repayments than anticipated.

// ○ Property value: The value of the property may not increase as expected, which can impact the borrower's ability to sell the property in the future or refinance the loan.

// ○ Building quality: Poor construction quality can result in defects and other issues with the property, which can impact the value of the property and the borrower's ability to sell it in the future.

// ○ Loan terms and fees: Home Construction Loans can be complex, with a range of fees and charges that can vary depending on the lender and the loan product. It's important to carefully review the loan terms and conditions before agreeing to the loan.

// ○ Default risk: If the borrower defaults on the loan, the lender may be able to sell the property to recover the outstanding debt. This can result in the borrower losing their home and damaging their credit rating.''',
//             lable4: 'TERMS & CONDITIONS:',
//             description4:
//                 '''○ Loan amount: The maximum amount that the borrower can borrow will depend on the lender and the property being built or renovated. Typically, the loan amount is based on the value of the property and the estimated cost of the construction.

// ○ Interest rate: The interest rate on a Home Construction Loan can be variable or fixed, and may be higher than other types of home loans. It's important to carefully review the interest rate and understand how it will impact the repayments over the life of the loan.

// ○ Repayment period: The repayment period can vary depending on the lender and the loan product, but is typically between 15-30 years. It's important to choose a repayment period that suits the borrower's financial situation and ability to make repayments.

// ○ Payment schedule: The payment schedule will depend on the lender and the loan product, but may be interest-only during the construction phase, and principal and interest during the repayment phase.

// ○ Fees and charges: Home Construction Loans can come with a range of fees and charges, including application fees, valuation fees, and construction progress inspection fees. It's important to carefully review the fees and charges and understand how they will impact the cost of the loan.

// ○ Security: The lender will require security for the loan, which is usually the property being built or renovated. This means that if the borrower defaults on the loan, the lender may be able to sell the property to recover the outstanding debt.

// ○ Construction plan: The lender may require a detailed construction plan that outlines the scope of the project, the estimated cost, and the timeline for completion. The lender may also require regular progress inspections to ensure that the construction is progressing according to plan.''',
//             takePoints: [
//               'Customization',
//               'Brand-new property',
//               'Lower mortgage rates',
//               'Energy-efficient features',
//               'Increased property value',
//             ],
//             take: [
//               'A home construction loan can provide funds to build a custom home that meets your specific needs and preferences.',
//               'With a construction loan, you\'ll be building a new home from scratch, which means that everything will be brand new and tailored to your liking',
//               'A newly constructed home may qualify for lower mortgage rates, which can save you money over the life of the loan',
//               'A new home can be built with energy-efficient features that can save you money on utilities in the long run',
//               'A new home may have a higher resale value than an older home, which can potentially provide a return on investment if you decide to sell in the future',
//             ],
//             notTakePoints: [
//               'Higher costs',
//               'Time-consuming',
//               'Risk of delays',
//               'Difficulty obtaining financing',
//               'Uncertainty',
//             ],
//             notTake: [
//               'Building a new home can be more expensive than buying an existing home, and a construction loan may have higher interest rates and fees than a traditional mortgage.',
//               'The construction process can be lengthy and may require you to live in temporary housing while your new home is being built.',
//               'There may be unforeseen delays in the construction process, which can result in additional costs and frustrations.',
//               'Construction loans can be more difficult to obtain than traditional mortgages, as lenders may require more documentation and financial information.',
//               'Building a new home can be unpredictable, and you may not know exactly what the final product will look like until it\'s complete.',
//             ],
//           ),
//         );

//       case loanAgainstProperty:
//         return provider.showFbOrAdxOrAdmobInterstitialAd(
//           availableAds: myAdsIdClass.availableAdsList,
//           RouteUtils.loanShortDescriptionScreen,
//           context,
//           googleInterID: myAdsIdClass.googleInterstitialId,
//           fbInterID: myAdsIdClass.facebookInterstitialId,
//           arguments: LoanDescriptionArguments(
//             sortDescriptionAppBarTitle: loanAgainstProperty,
//             loanName: loanAgainstProperty,
//             subTitle:
//                 '''○ A Loan Against Property (LAP) is a type of secured loan that allows borrowers to avail of a loan by pledging their property as collateral.

// ○ The loan amount is disbursed based on the market value of the property, and the borrower can use the funds for any purpose, such as business expansion, education, marriage, medical emergencies, or debt consolidation.

// ○ The interest rate for LAP is typically lower than unsecured loans, and the tenure can range from 5 to 20 years.

// ○ Loan against property offers borrowers flexibility in terms of loan amount and usage. The funds obtained can be used for various purposes, such as funding business expansion, meeting personal financial needs, financing education or marriage expenses, debt consolidation, or any other legitimate financial requirement.

// ○ The interest rates for loan against property are usually lower compared to unsecured loans, as the lender has the property as collateral. The interest can be fixed or floating, depending on the terms agreed upon. The repayment tenure for loan against property can range from 5 to 20 years, allowing borrowers to repay the loan in convenient monthly installments.
// ''',
//             eligibilityCriteria:
//                 '''○ The borrower should be an Indian citizen or resident

// ○ The borrower should own a residential or commercial property that is free from any encumbrances

// ○ The property should have a clear title and necessary approvals from the local authorities

// ○ The borrower should have a stable source of income and a good credit score

// ○ The borrower should have a minimum age of 21 years and a maximum age of 65 years at the time of loan maturity''',
//             documents:
//                 '''○ Income proof, such as salary slips or income tax returns

// ○ Identity and address proof, such as Aadhar Card, PAN Card, Voter ID, or Passport

// ○ Property documents, such as sale deed, land records, or property tax receipts

// ○ Bank statements for the past 6 to 12 months

// ○ Employment proof, such as appointment letter, experience letter, or company ID card''',
//             tenureDescription:
//                 '''○ A short tenures, usually ranging from 5 to 20 years
// ○ The borrower can choose the tenure based on their repayment capacity and financial goals.''',
//             interest: '''○ Approximately from 7% to 15% per annum
// ○ Some lenders may also offer a fixed or floating interest rate, depending on the borrower's preference.''',
//             loanAmount: '''○ Based on borrower needs and eligibility

// ○ The loan amount for a Loan Against Property may vary depending on the lender, the market value of the property, and the borrower's repayment capacity.

// ○ Generally, lenders offer Loan Against Property ranging from Rs. 5 lakhs to Rs. 10 crores or more, depending on the market value of the property and the borrower's repayment capacity.

// ○ The loan amount can be up to 60% to 70% of the market value of the property, depending on the lender's policy.''',
//             processingFees:
//                 '''○ Approximately ranging from 0.5% to 2% of the loan amount
// Some lenders may also charge a prepayment penalty if the borrower repays the loan before the tenure ends.''',
//             fullDescriptionAppBarTitle: loanAgainstProperty,
//             buttonLable: 'Know More about Loan Against Property',
//             imgURl: AssetUtils.icLoanAgainstPropertyLoan,
//             lable1: 'What is concept of a Loan Against Property?',
//             description1:
//                 '''○ A Loan Against Property (LAP) is a type of secured loan where the borrower pledges their property (residential or commercial) as collateral to the lender. The loan amount is sanctioned based on the value of the property pledged.

// ○ The borrower can use the loan amount for various purposes such as business expansion, education expenses, medical expenses, wedding expenses, or to purchase another property.

// ○ The interest rates on LAP are usually lower than unsecured loans such as personal loans as the lender has the property as collateral, which reduces the risk for the lender.''',
//             lable2: 'Highlights and Advantages:',
//             description2:
//                 '''○ High loan amount: LAP offers a higher loan amount compared to other forms of secured loans such as personal loans or gold loans. The loan amount is typically based on the value of the property being pledged.

// ○ Lower interest rates: LAP typically comes with lower interest rates compared to unsecured loans such as personal loans as the lender has the security of the pledged property.

// ○ Flexible repayment tenure: LAP comes with a flexible repayment tenure ranging from 5 to 20 years, depending on the lender's terms and conditions.

// ○ Multipurpose loan: LAP can be used for a variety of purposes such as business expansion, debt consolidation, education, medical expenses, wedding expenses, or to purchase another property.

// ○ Quick processing: LAP can be processed quickly as the lender does not have to evaluate the borrower's creditworthiness extensively. The primary factor considered is the value of the property being pledged.

// ○ Tax benefits: The interest paid on the LAP is eligible for tax deductions under section 24 of the Income Tax Act, subject to certain conditions.

// ○ Improved credit score: Timely payment of EMIs on LAP can help improve the borrower's credit score and creditworthiness.''',
//             lable3: 'Risks and considerations:',
//             description3:
//                 '''○ Risk of default: If the borrower is unable to repay the loan amount, the lender has the right to seize and sell the pledged property to recover the outstanding amount. This can result in the loss of the borrower's property.

// ○ Valuation of the property: The loan amount is determined based on the value of the property being pledged. However, the property valuation can vary depending on various factors, and the lender may not offer the desired loan amount. The borrower should get the property valued by a professional before applying for a LAP.

// ○ High fees and charges: Lenders may charge high processing fees, prepayment charges, foreclosure charges, and other fees and charges. These fees can increase the overall cost of borrowing.

// ○ Impact on credit score: Failure to repay the loan on time can negatively impact the borrower's credit score and creditworthiness, making it difficult to obtain credit in the future.

// ○ Tenure and interest rate: The tenure and interest rate of the LAP can vary depending on the lender's terms and conditions. Borrowers should carefully evaluate their repayment capacity and compare the interest rates and terms offered by different lenders before choosing a LAP.

// ○ Legal implications: The borrower should understand the legal implications of pledging their property as collateral, including the terms and conditions of the loan agreement and the consequences of defaulting on the loan.''',
//             lable4: 'TERMS & CONDITIONS:',
//             description4:
//                 '''○ Eligibility criteria: The borrower must meet the lender's eligibility criteria, which may include factors such as age, income, credit score, and property value.

// ○ Loan amount: The loan amount is determined based on the value of the property being pledged and may range from 50% to 75% of the property value. The maximum loan amount may vary depending on the lender's policy.

// ○ Interest rate: The interest rate on LAP may vary depending on various factors such as the loan amount, tenure, and the borrower's creditworthiness. The interest rate may be fixed or floating.

// ○ Repayment tenure: The tenure of the LAP may range from 5 to 20 years, depending on the lender's policy. The borrower can repay the loan in Equated Monthly Installments (EMIs).

// ○ Processing fees and other charges: The lender may charge processing fees, prepayment charges, foreclosure charges, and other fees and charges. These charges can vary depending on the lender's policy.

// ○ Pledge of property: The borrower must pledge their property as collateral to avail of the LAP. The property should be free of any encumbrances, and the borrower should have a clear title to the property.

// ○ Default and foreclosure: If the borrower defaults on the LAP, the lender has the right to seize and sell the pledged property to recover the outstanding amount. The borrower should carefully evaluate their repayment capacity before availing of the loan.

// ○ Legal implications: The borrower should understand the legal implications of pledging their property as collateral, including the terms and conditions of the loan agreement and the consequences of defaulting on the loan.''',
//             takePoints: [
//               'Lower interest rates',
//               'Larger loan amounts',
//               'Longer repayment terms',
//               'Flexibility in use of funds',
//               'Secured loan',
//             ],
//             take: [
//               'Loans Against Property typically have lower interest rates than unsecured loans, such as personal loans or credit cards.',
//               'Loans Against Property typically allow you to borrow larger amounts of money than unsecured loans, which can be useful for larger expenses.',
//               'Loans Against Property typically have longer repayment terms than unsecured loans, which can result in lower monthly payments.',
//               'Loans Against Property can be used for a variety of purposes, such as home renovations, debt consolidation, or business expansion.',
//               'Loans Against Property are secured by your property, which can provide lenders with a greater sense of security and may result in more favorable loan terms.',
//             ],
//             notTakePoints: [
//               'Risk of losing your property',
//               'Lengthy approval process',
//               'Additional fees',
//               'Strict eligibility requirements',
//               'Longer repayment terms',
//             ],
//             notTake: [
//               'Since Loans Against Property are secured by your property, failing to make payments could result in foreclosure or repossession of your property.',
//               'Loans Against Property may have a lengthier approval process than unsecured loans, which could result in delays in accessing funds.',
//               'Loans Against Property may have additional fees such as appraisal fees, title search fees, and processing fees, which can add to the overall cost of the loan.',
//               'Loans Against Property typically have strict eligibility requirements, such as a minimum credit score or a certain amount of equity in the property.',
//               'While longer repayment terms can result in lower monthly payments, they also mean that you will be paying interest on the loan for a longer period of time, which can result in higher overall interest costs.',
//             ],
//           ),
//         );

//       case securedBusinessLoan:
//         return provider.showFbOrAdxOrAdmobInterstitialAd(
//           availableAds: myAdsIdClass.availableAdsList,
//           RouteUtils.loanShortDescriptionScreen,
//           context,
//           googleInterID: myAdsIdClass.googleInterstitialId,
//           fbInterID: myAdsIdClass.facebookInterstitialId,
//           arguments: LoanDescriptionArguments(
//             sortDescriptionAppBarTitle: securedBusinessLoan,
//             loanName: securedBusinessLoan,
//             subTitle:
//                 '''○ A Secured Business Loan is a type of loan that requires collateral to be pledged by the borrower to the lender.

// ○ The collateral can be in the form of property, stocks, bonds, or any other assets that have a significant market value.

// ○ The loan amount is determined by the value of the collateral pledged, and the interest rate is generally lower than that of unsecured loans.

// ○ Secured Business Loans are suitable for businesses looking for larger loan amounts, longer repayment tenures, and lower interest rates.

// ○ A secured business loan is a type of loan that is backed by collateral, such as business assets, real estate, or personal assets. It is designed to provide funding to businesses while reducing the risk for lenders.

// ○ When applying for a secured business loan, borrowers pledge specific assets as collateral to secure the loan. The collateral serves as a form of security for the lender, providing assurance that the loan will be repaid. In the event of default, the lender has the right to seize and sell the collateral to recover the outstanding amount.

// ''',
//             eligibilityCriteria:
//                 '''○ The borrower should be a registered business entity, such as a company, partnership firm, or proprietorship

// ○ The business should have a minimum operational history, usually at least 3 years

// ○ The business should have a positive credit score and a healthy financial track record

// ○ The collateral pledged should have a clear title and necessary approvals from the local authorities

// ○ The borrower should have a stable source of income and repayment capacity''',
//             documents: '''○ Business registration and incorporation documents

// ○ Income tax returns and financial statements for the past 2 to 3 years

// ○ Bank statements for the past 6 to 12 months

// ○ Identity and address proof of the business owner and co-applicants

// ○ Collateral documents, such as property deeds, stocks, or bonds certificates''',
//             tenureDescription:
//                 '''○ A short tenures, usually ranges from 3 to 20 years.
// ○ The borrower can choose the tenure based on their repayment capacity and financial goals.''',
//             interest: '''○ Approximately 8% to 18% per annum''',
//             loanAmount: '''○ Based on borrower needs and eligibility

// ○ Generally, lenders offer Secured Business Loans ranging from Rs. 5 lakhs to Rs. 10 crores or more

// ○ The loan amount can be up to 60% to 80% of the collateral value, depending on the lender's policy.''',
//             processingFees: '''○ Approximately 0.5% to 2% of the loan amount
// ○ Some lenders may also charge a prepayment penalty if the borrower repays the loan before the tenure ends.''',
//             fullDescriptionAppBarTitle: securedBusinessLoan,
//             buttonLable: 'Know More about Secured Business Loan',
//             imgURl: AssetUtils.icSecuredLoan1,
//             lable1: 'What is concept of a Secured Business Loan?',
//             description1:
//                 '''○ A Secured Business Loan is a type of loan that is secured against collateral provided by the borrower. The collateral could be in the form of property, inventory, equipment, or any other valuable asset that can be pledged as security for the loan.

// ○ The loan amount is determined based on the value of the collateral provided by the borrower.

// ○ The loan can be used for various business purposes such as business expansion, working capital, inventory management, purchase of equipment or machinery, hiring employees, or any other business-related expense.

// ○ The repayment tenure and interest rate of the loan can vary depending on the lender's terms and conditions.''',
//             lable2: 'Highlights and Advantages:',
//             description2:
//                 '''○ High loan amount: The loan amount offered by a Secured Business Loan is typically higher than that of an unsecured loan. This is because the loan is secured against collateral provided by the borrower.

// ○ Lower interest rates: As the loan is secured against collateral, lenders may offer lower interest rates compared to unsecured loans, which can result in lower monthly EMIs.

// ○ Flexible repayment tenure: The repayment tenure of a Secured Business Loan can be flexible, ranging from a few months to several years, depending on the borrower's repayment capacity and the lender's terms and conditions.

// ○ Collateral security: The collateral provided by the borrower offers security to the lender, which reduces the lender's risk. This can result in a higher loan approval rate and lower interest rates.

// ○ Multiple uses: The loan amount can be used for various business purposes such as business expansion, working capital, inventory management, purchase of equipment or machinery, hiring employees, or any other business-related expense.

// ○ Credit score improvement: Timely repayment of the loan can improve the borrower's credit score, which can increase the borrower's creditworthiness and make it easier to obtain credit in the future.''',
//             lable3: 'Risks and considerations:',
//             description3:
//                 '''○ Risk of collateral loss: The biggest risk of a Secured Business Loan is the potential loss of the pledged collateral if the borrower is unable to repay the loan on time. If the borrower defaults on the loan, the lender has the right to seize and sell the pledged collateral to recover the outstanding amount.

// ○ High-interest rates for risky borrowers: Borrowers with poor credit history or limited business experience may be considered risky by lenders, and may have to pay higher interest rates to compensate for the lender's risk.

// ○ Evaluation of collateral value: The loan amount is determined based on the value of the collateral provided by the borrower. It is important for borrowers to evaluate the value of their collateral before pledging it to the lender to avoid undervaluation.

// ○ Lengthy loan processing: The loan processing time for a Secured Business Loan can be longer compared to an unsecured loan due to the requirement of collateral evaluation and legal documentation.

// ○ Repayment discipline: The borrower should ensure timely repayment of the loan to avoid the risk of losing their collateral. Late payments or default can negatively impact the borrower's credit score and make it difficult to obtain credit in the future.

// ○ Legal implications: The borrower should understand the legal implications of pledging their collateral as security for the loan, including the terms and conditions of the loan agreement and the consequences of defaulting on the loan.''',
//             lable4: 'TERMS & CONDITIONS:',
//             description4:
//                 '''○ Loan amount: The loan amount offered will depend on the value of the collateral provided by the borrower.

// ○ Interest rates: The interest rates on a Secured Business Loan can vary depending on the lender, the borrower's creditworthiness, and the loan tenure.

// ○ Repayment tenure: The repayment tenure for a Secured Business Loan can be flexible, ranging from a few months to several years, depending on the borrower's repayment capacity and the lender's policies.

// ○ Collateral: The borrower must provide collateral that can be pledged as security for the loan. The collateral could be in the form of property, inventory, equipment, or any other valuable asset.

// ○ Loan processing fees: The lender may charge a loan processing fee, which can vary depending on the loan amount and the lender's policies.

// ○ Prepayment charges: Some lenders may charge prepayment charges if the borrower wishes to prepay the loan before the end of the repayment tenure.

// ○ Late payment charges: Late payment charges may be levied on the borrower if they fail to make the monthly loan payments on time.

// ○ Legal implications: The borrower should understand the legal implications of pledging their collateral as security for the loan, including the terms and conditions of the loan agreement and the consequences of defaulting on the loan.''',
//             takePoints: [
//               'Lower interest rates',
//               'Larger loan amounts',
//               'Longer repayment terms',
//               'Collateral',
//               'Flexibility in use of funds',
//             ],
//             take: [
//               'Secured Business Loans typically have lower interest rates than unsecured loans, such as business credit cards or lines of credit.',
//               'Secured Business Loans typically allow you to borrow larger amounts of money than unsecured loans, which can be useful for larger expenses.',
//               'Secured Business Loans typically have longer repayment terms than unsecured loans, which can result in lower monthly payments.',
//               'Secured Business Loans require collateral, which can be used to secure the loan and provide lenders with a greater sense of security, which may result in more favorable loan terms.',
//               'Secured Business Loans can be used for a variety of purposes, such as purchasing inventory, hiring employees, or expanding operations.',
//             ],
//             notTakePoints: [
//               'Risk of losing collateral',
//               'Additional fees',
//               'Strict eligibility requirements',
//               'Longer repayment terms',
//               'Lengthy approval process',
//             ],
//             notTake: [
//               'Since Secured Business Loans are secured by collateral, failing to make payments could result in the loss of the collateral, such as equipment or property.',
//               'Secured Business Loans may have additional fees such as appraisal fees, title search fees, and processing fees, which can add to the overall cost of the loan.',
//               'Secured Business Loans typically have strict eligibility requirements, such as a minimum credit score or a certain amount of collateral value.',
//               'While longer repayment terms can result in lower monthly payments, they also mean that you will be paying interest on the loan for a longer period of time, which can result in higher overall interest costs.',
//               'Secured Business Loans may have a lengthier approval process than unsecured loans, which could result in delays in accessing funds.',
//             ],
//           ),
//         );

//       case personalLoan:
//         return provider.showFbOrAdxOrAdmobInterstitialAd(
//           availableAds: myAdsIdClass.availableAdsList,
//           RouteUtils.loanShortDescriptionScreen,
//           context,
//           googleInterID: myAdsIdClass.googleInterstitialId,
//           fbInterID: myAdsIdClass.facebookInterstitialId,
//           arguments: LoanDescriptionArguments(
//             sortDescriptionAppBarTitle: personalLoan,
//             loanName: personalLoan,
//             subTitle:
//                 '''○ A Personal Loan is an unsecured loan that can be taken by an individual for any personal financial requirement, such as medical emergencies, travel, education, debt consolidation, or home renovation.

// ○ The loan amount is determined by the borrower's creditworthiness, repayment capacity, and other factors such as income, employment history, and credit score.''',
//             eligibilityCriteria:
//                 '''○ The borrower should be an Indian citizen or resident

// ○ The borrower should be between the ages of 21 to 60 years

// ○ The borrower should have a regular source of income, such as salary, self-employment income, or pension

// ○ The borrower should have a minimum income requirement, usually starting from Rs. 15,000 per month

// ○ The borrower should have a good credit score and a healthy financial track record''',
//             documents:
//                 '''○ Identity and address proof, such as PAN card, Aadhaar card, passport, or driving license

// ○ Income proof, such as salary slips, income tax returns, or bank statements for the past 6 months

// ○ Employment proof, such as a company ID card, employment letter, or business registration certificate

// ○ Credit score and credit report, which can be obtained from credit bureaus such as CIBIL, Experian, or Equifax''',
//             tenureDescription:
//                 '''○ A short tenures, usually ranging from 1 to 5 years
// ○ The borrower can choose the tenure based on their repayment capacity and financial goals.''',
//             interest:
//                 '''○ The interest rate for a Personal Loan may vary depending on the lender and the borrower's creditworthiness.
// ○ Approximately 10% to 24% per annum''',
//             loanAmount: '''○ Based on borrower needs and eligibility
// ○ Generally, lenders offer Personal Loans ranging from Rs. 10,000 to Rs. 50 lakhs or more, depending on the borrower's income and repayment capacity.''',
//             processingFees: '''○ Approximately from 1% to 3% of the loan amount
// ○ The processing fees for a Personal Loan may vary depending on the lender and the loan amount.''',
//             fullDescriptionAppBarTitle: personalLoan,
//             buttonLable: 'Know More about Personal Loan',
//             imgURl: AssetUtils.icPersonalLoanImage,
//             lable1: 'What is concept of a Personal Loan?',
//             description1:
//                 '''○ A Personal Loan is an unsecured loan that can be availed by individuals to meet their personal financial needs.

// ○ Unlike a secured loan, a Personal Loan does not require collateral such as property, gold or other assets to be pledged as security for the loan.

// ○ The loan amount, interest rate, and repayment tenure are determined based on the borrower's credit score, income, and other factors.

// ○ The borrower can use the loan amount for various purposes such as home renovation, medical expenses, wedding expenses, travel expenses, or any other personal expenses.

// ○ The loan amount can usually range from a few thousand to several lakhs depending on the borrower's creditworthiness and the lender's policies.''',
//             lable2: 'Highlights and Advantages:',
//             description2:
//                 '''○ Unsecured Loan: As Personal Loans are unsecured loans, borrowers are not required to provide collateral to avail of the loan. This makes it a convenient option for individuals who do not have any assets to pledge as security.

// ○ Quick Disbursal: The loan application process for a Personal Loan is usually simple and quick, and the loan amount can be disbursed within a few days of loan approval.

// ○ Flexible Repayment Tenure: Personal Loans come with flexible repayment tenures ranging from a few months to several years, depending on the borrower's repayment capacity. This makes it easy for borrowers to choose a repayment tenure that suits their financial situation.

// ○ Multiple Uses: The loan amount can be used for various personal expenses such as medical expenses, home renovation, travel expenses, wedding expenses, or any other personal expense. This makes it a versatile option for individuals with different financial needs.

// ○ No End-Use Restriction: Borrowers do not need to provide any specific reason for availing of a Personal Loan, and there are no restrictions on the end-use of the loan amount.

// ○ Competitive Interest Rates: Personal Loans come with competitive interest rates, which may be lower than other forms of unsecured credit like credit cards.''',
//             lable3: 'Risks and considerations:',
//             description3:
//                 '''○ High Interest Rates: Personal Loans usually come with higher interest rates than secured loans, as they are unsecured loans. The interest rate can vary depending on the borrower's credit score, income, and other factors.

// ○ Impact on Credit Score: Late payments or defaulting on a Personal Loan can have a negative impact on the borrower's credit score, which can make it difficult for them to get loans in the future.

// ○ Debt Trap: Taking a Personal Loan can put the borrower at risk of falling into a debt trap, particularly if they take multiple loans or borrow more than they can repay.

// ○ Hidden Fees and Charges: Some lenders may charge hidden fees and charges, such as prepayment charges, processing fees, and late payment fees. It is important for borrowers to read the loan agreement carefully and understand all the terms and conditions before availing of a Personal Loan.

// ○ Limited Loan Amount: As Personal Loans are unsecured loans, the loan amount may be limited depending on the borrower's creditworthiness and other factors. This may not be sufficient for borrowers with high financial needs.

// ○ Unpredictable Market Conditions: Economic or market conditions can lead to fluctuations in interest rates and affect the borrower's ability to repay the loan.''',
//             lable4: 'TERMS & CONDITIONS:',
//             description4:
//                 '''○ Eligibility Criteria: Borrowers must meet certain eligibility criteria to qualify for a Personal Loan, such as age, income, credit score, and employment status.

// ○ Loan Amount: The loan amount may be determined based on the borrower's creditworthiness and other factors, and it may vary from lender to lender.

// ○ Interest Rates: The interest rate on a Personal Loan may vary depending on the lender and the borrower's creditworthiness. It may be a fixed or floating rate.

// ○ Repayment Tenure: The repayment tenure for a Personal Loan may vary from a few months to several years, depending on the borrower's repayment capacity and the lender's policies.

// ○ Prepayment Charges: Some lenders may charge prepayment charges if the borrower decides to repay the loan before the end of the repayment tenure.

// ○ Processing Fees: Lenders may charge processing fees, which can range from 1% to 3% of the loan amount.

// ○ Late Payment Fees: Lenders may charge late payment fees if the borrower fails to make the loan payment on time.

// ○ Credit Score: The borrower's credit score may be affected if they fail to make loan payments on time or default on the loan.

// ○ Documentation: Borrowers must provide certain documents such as identity proof, address proof, income proof, and bank statements to avail of a Personal Loan.''',
//             takePoints: [
//               'Flexibility in use of funds',
//               'Lower interest rates',
//               'Fixed repayment terms',
//               'Quick approval process',
//               'No collateral required',
//             ],
//             take: [
//               'Personal loans can be used for a variety of purposes, such as home renovations, debt consolidation, or unexpected expenses.',
//               'Personal loans may have lower interest rates than credit cards, making them a more affordable option for borrowing.',
//               'Personal loans typically have fixed repayment terms, which means that you will know exactly how much you need to pay each month and for how long.',
//               'Personal loans often have a faster approval process than other types of loans, allowing you to access funds quickly.',
//               'Personal loans are unsecured, which means that you do not have to put up collateral such as your home or car to secure the loan.',
//             ],
//             notTakePoints: [
//               'Higher interest rates',
//               'Shorter repayment terms',
//               'Fees',
//               'Credit score requirements',
//               'Risk of default',
//             ],
//             notTake: [
//               'While personal loans may have lower interest rates than credit cards, they may still have higher interest rates than other types of loans such as home equity loans.',
//               'Personal loans typically have shorter repayment terms than other types of loans, which can result in higher monthly payments.',
//               'Personal loans may have fees such as origination fees or prepayment penalties, which can add to the overall cost of the loan.',
//               'Personal loans may have stricter credit score requirements than other types of loans, which could make it difficult to qualify for the loan.',
//               'Since personal loans are unsecured, lenders may view them as riskier and may charge higher interest rates to compensate for the risk.',
//             ],
//           ),
//         );

//       case instantLoan:
//         return provider.showFbOrAdxOrAdmobInterstitialAd(
//           availableAds: myAdsIdClass.availableAdsList,
//           RouteUtils.loanShortDescriptionScreen,
//           context,
//           googleInterID: myAdsIdClass.googleInterstitialId,
//           fbInterID: myAdsIdClass.facebookInterstitialId,
//           arguments: LoanDescriptionArguments(
//             sortDescriptionAppBarTitle: instantLoan,
//             loanName: instantLoan,
//             subTitle:
//                 '''○ An Instant Loan is a type of Personal Loan that can be approved and disbursed quickly, usually within a few hours or days.

// ○ These loans are ideal for those who need immediate access to cash for an emergency or unexpected expense.

// ○ Instant Loans are usually unsecured loans, and the loan amount and tenure may vary depending on the borrower's creditworthiness and the lender's policies.

// ○ The application process for instant loans is usually simple and streamlined.

// ○ Borrowers can apply online, provide the necessary details and documentation electronically, and receive a quick decision on their loan application. If approved, the loan amount is disbursed swiftly, often within a few hours or even minutes, directly into the borrower's bank account.

// ○ The eligibility criteria and loan terms for instant loans vary among lenders. Factors such as the borrower's credit score, income stability, employment history, and repayment capacity are typically considered. The loan amount and interest rates may also vary based on these factors.

// ''',
//             eligibilityCriteria:
//                 '''○ The borrower should be an Indian citizen or resident

// ○ The borrower should be between the ages of 21 to 60 years

// ○ The borrower should have a regular source of income, such as salary, self-employment income, or pension

// ○ The borrower should have a minimum income requirement, usually starting from Rs. 15,000 per month

// ○ The borrower should have a good credit score and a healthy financial track record''',
//             documents:
//                 '''○ Identity and address proof, such as PAN card, Aadhaar card, passport, or driving license

// ○ Income proof, such as salary slips, income tax returns, or bank statements for the past 6 months

// ○ Employment proof, such as a company ID card, employment letter, or business registration certificate

// ○ Credit score and credit report, which can be obtained from credit bureaus such as CIBIL, Experian, or Equifax''',
//             tenureDescription:
//                 '''○ A short tenures, usually ranging from 1 to 3 years
// ○ The borrower can choose the tenure based on their repayment capacity and financial goals.''',
//             interest:
//                 '''○ The interest rate for an Instant Loan may vary depending on the lender and the borrower's creditworthiness.
// ○ Approximately from 10% to 24%''',
//             loanAmount:
//                 '''○ The loan amount can be up to 40 times the borrower's monthly income, depending on the lender's policy.
// ○ Generally, lenders offer Instant Loans ranging from Rs. 5,000 to Rs. 5 lakhs or more, depending on the borrower's income and repayment capacity.''',
//             processingFees: '''○ Approximately 1% to 3% of the loan amount
// ○ The processing fees for an Instant Loan may vary depending on the lender and the loan amount.''',
//             fullDescriptionAppBarTitle: instantLoan,
//             buttonLable: 'Know More about Instant Loan',
//             imgURl: AssetUtils.icInstantPng,
//             lable1: 'What is concept of a Instant Loan?',
//             description1:
//                 '''○ An Instant Loan, as the name suggests, is a type of loan that can be availed of instantly or within a short period of time. These loans are usually unsecured loans, which means that they do not require any collateral or security to be provided by the borrower. Instant Loans are typically offered by digital lenders, such as fintech companies and online lenders, who use technology and algorithms to assess the borrower's creditworthiness and approve the loan quickly.

// ○ The application process for an Instant Loan is usually online, and the borrower can apply for the loan by filling in the application form and submitting the required documents.

// ○ Once the lender verifies the documents and approves the loan, the loan amount is disbursed to the borrower's bank account instantly or within a few hours.

// ○ Instant Loans are typically small-ticket loans, and the loan amount can range from a few thousand to a few lakhs, depending on the borrower's creditworthiness and other factors.

// ○ These loans are usually short-term loans, and the repayment tenure can range from a few months to a year.

// ○ The interest rates on Instant Loans can vary depending on the lender and the borrower's creditworthiness. These loans may have higher interest rates than traditional loans, as they are unsecured loans and the lender bears a higher risk.''',
//             lable2: 'Highlights and Advantages:',
//             description2:
//                 '''○ Quick Approval: Instant Loans are approved quickly, usually within a few hours, which makes them a convenient option for those who need funds urgently.

// ○ Easy Application Process: The application process for Instant Loans is usually online, which makes it easy and convenient for borrowers to apply for the loan from the comfort of their home or office.

// ○ No Collateral Required: Instant Loans are unsecured loans, which means that borrowers do not have to provide any collateral or security to avail of these loans.

// ○ Flexible Repayment Options: Instant Loans usually come with flexible repayment options, and borrowers can choose a repayment tenure that suits their repayment capacity.

// ○ Small Ticket Loans: Instant Loans are typically small-ticket loans, which makes them a suitable option for those who need funds for emergencies or unexpected expenses.

// ○ No Usage Restrictions: There are usually no restrictions on the usage of Instant Loan funds, which means that borrowers can use the funds for any purpose.

// ○ Competitive Interest Rates: Some digital lenders offer competitive interest rates on Instant Loans, which can be lower than traditional lenders.''',
//             lable3: 'Risks and considerations:',
//             description3:
//                 '''○ Higher Interest Rates: Instant Loans can come with higher interest rates than traditional loans due to the higher risk borne by the lender. Borrowers should ensure that they can afford to repay the loan with the interest rate charged.

// ○ Short Repayment Tenure: Instant Loans usually come with a short repayment tenure, which means that borrowers have to repay the loan within a few months to a year. Borrowers should ensure that they can repay the loan within the stipulated period to avoid any negative impact on their credit score.

// ○ Late Payment Charges: Borrowers who fail to repay the loan on time may have to pay late payment charges, which can be significantly high. This can also negatively impact their credit score.

// ○ Prepayment Charges: Some lenders may charge prepayment penalties if the borrower decides to repay the loan before the end of the tenure. Borrowers should ensure that they carefully read and understand the terms and conditions associated with the loan before availing of it.

// ○ Impact on Credit Score: Late payments or default on Instant Loans can negatively impact the borrower's credit score, which can make it difficult for them to avail of loans in the future.''',
//             lable4: 'TERMS & CONDITIONS:',
//             description4:
//                 '''○ Eligibility Criteria: Borrowers should meet the eligibility criteria set by the lender, which may include age, income, credit score, and employment status.

// ○ Loan Amount and Tenure: Borrowers should carefully consider the loan amount and tenure that they require and ensure that they can repay the loan within the stipulated period.

// ○ Interest Rate: Borrowers should carefully read and understand the interest rate charged by the lender and ensure that they can afford to repay the loan with the interest charged.

// ○ Processing Fees and Other Charges: Some lenders may charge processing fees and other charges, such as prepayment penalties, late payment fees, or bounce charges. Borrowers should carefully read and understand these charges before availing of the loan.

// ○ Repayment Schedule: Borrowers should ensure that they understand the repayment schedule and make timely payments to avoid late payment charges or default.

// ○ Documentation: Borrowers may need to provide certain documents, such as identity proof, income proof, and address proof, to avail of the loan. Borrowers should ensure that they have all the necessary documents before applying for the loan.

// ○ Default and Collection Practices: Borrowers should be aware of the default and collection practices of the lender in case of non-payment of the loan.''',
//             take: [
//               'Instant loans are designed to provide quick access to funds, which can be useful in emergency situations or when you need money quickly.',
//               'Instant loans typically have a simple and streamlined application process, which can be completed online in a matter of minutes.',
//               'Instant loans are usually unsecured, which means you don\'t need to provide collateral to secure the loan.',
//               ' Depending on the lender, instant loans may offer flexible loan amounts, allowing you to borrow as little or as much as you need.',
//               'Successfully repaying an instant loan can help improve your credit score, which can be beneficial for future borrowing opportunities.',
//             ],
//             takePoints: [
//               'Quick Access to Funds',
//               'Easy Application Process',
//               'No Collateral Required',
//               'Flexible Loan Amount',
//               'Improve Credit Score',
//             ],
//             notTake: [
//               'Instant loans typically have higher interest rates than traditional loans, which can make them more expensive overall.',
//               'Instant loans often have short repayment periods, which can make it difficult to repay the loan in a timely manner, leading to additional fees and charges.',
//               'Some instant loan lenders may charge hidden fees, such as application fees, processing fees, or late payment fees, which can add to the cost of the loan.',
//               'Depending on the lender, instant loans may have limited loan amounts, which may not be enough to cover all of your borrowing needs.',
//               'Some lenders may engage in predatory lending practices, such as charging excessive fees or targeting vulnerable borrowers, which can lead to financial hardship and debt. It\'s important to research lenders carefully and choose a reputable and trustworthy lender.',
//             ],
//             notTakePoints: [
//               'High Interest Rates',
//               'Short Repayment Periods',
//               'Hidden Fees',
//               'Limited Loan Amounts',
//               'Predatory Lending Practices',
//             ],
//           ),
//         );

//       case levelUpLoans:
//         return provider.showFbOrAdxOrAdmobInterstitialAd(
//           availableAds: myAdsIdClass.availableAdsList,
//           RouteUtils.loanShortDescriptionScreen,
//           context,
//           googleInterID: myAdsIdClass.googleInterstitialId,
//           fbInterID: myAdsIdClass.facebookInterstitialId,
//           arguments: LoanDescriptionArguments(
//             sortDescriptionAppBarTitle: levelUpLoans,
//             loanName: levelUpLoans,
//             subTitle:
//                 '''○ Level Up Funding is an online lender that offers Installment Loans to small business owners and individuals.

// ○ These loans are designed to help borrowers fund their business or personal expenses and are typically repaid in fixed monthly installments over a period of time.

// ○ Level Up Loans are unsecured loans, which means borrowers do not have to provide any collateral or security to obtain the loan. ''',
//             eligibilityCriteria:
//                 '''○ The borrower should be a US citizen or resident

// ○ The borrower should be at least 18 years old

// ○ The borrower should have a minimum credit score of 600

// ○ The borrower should have a minimum annual revenue of \$100,000 (for business loans)

// ○ The borrower should have a valid bank account and proof of income''',
//             documents:
//                 '''○ Government-issued ID, such as a driver's license or passport

// ○ Bank statements for the past 3 to 6 months

// ○ Tax returns for the past 1 to 2 years (for business loans)

// ○ Proof of income, such as pay stubs or income tax returns

// ○ Business registration documents (for business loans)''',
//             tenureDescription:
//                 '''○ A short tenures, usually ranging between 6 to 18 months
// ○ The loan is repaid in fixed monthly installments over the tenure period.''',
//             interest: '''○ Approximately range from 4.99% to 35.99% per annum
// ○ The interest rate is fixed for the entire tenure period, which means borrowers have a predictable repayment schedule.''',
//             loanAmount: '''○ Based on borrower needs and eligibility

// ○ Level Up Loans ranging from \$5,000 to \$500,000

// ○ The loan amount is determined based on the borrower's creditworthiness, income, and business revenue (for business loans).''',
//             processingFees:
//                 '''○ Approximately from 1% to 5% of the loan amount''',
//             fullDescriptionAppBarTitle: levelUpLoans,
//             buttonLable: 'Know More about Level Up Loans',
//             imgURl: AssetUtils.icLevelUpLoanPng,
//             lable1: 'What is concept of a Level Up Loans?',
//             description1:
//                 '''○ The concept of Level Up Loans is to provide borrowers with a simple and straightforward loan application process, flexible repayment options, and competitive interest rates.''',
//             lable2: 'Highlights and Advantages:',
//             description2:
//                 '''○ Fast and Easy Application Process: Borrowers can apply for a loan online and receive a decision within minutes.

// ○ Flexible Repayment Terms: Borrowers can choose from different repayment terms, ranging from six months to three years, depending on their needs.

// ○ Competitive Interest Rates: Level Up Loans offers competitive interest rates, which can help borrowers save money over the life of the loan.

// ○ No Prepayment Penalties: Borrowers can repay the loan early without incurring any prepayment penalties.

// ○ Personalized Customer Service: Level Up Funding provides personalized customer service and support to help borrowers throughout the loan application and repayment process.''',
//             lable3: 'Risks and considerations:',
//             description3:
//                 '''○ High Interest Rates: While Level Up Loans offer competitive interest rates, they may still be higher than other forms of financing, particularly if the borrower has poor credit.

// ○ Fees and Charges: Borrowers should carefully review the terms and conditions of the loan and be aware of any fees or charges associated with it, such as origination fees, late fees, or insufficient funds fees.

// ○ Impact on Credit Score: Late payments or default on a Level Up Loan can negatively impact the borrower's credit score, which can make it difficult for them to avail of loans in the future.''',
//             lable4: 'TERMS & CONDITIONS:',
//             description4:
//                 '''○ Loan Amounts: Borrowers can apply for loan amounts ranging from \$1,000 to \$100,000.

// ○ Loan Terms: Loan terms can range from six months to three years.

// ○ Interest Rates: Interest rates can vary depending on the borrower's creditworthiness and other factors, but typically range from 6.99% to 24.99%.

// ○ Fees: Borrowers may be charged origination fees, late fees, insufficient funds fees, or other charges, depending on the specific loan product.

// ○ Repayment: Borrowers are typically required to make regular monthly payments over the course of the loan term. They may have the option to choose between different repayment plans, such as a fixed monthly payment or a percentage of their daily credit card sales (for business loans).

// ○ Prepayment: Borrowers may have the option to repay the loan early without incurring any prepayment penalties.

// ○ Credit Check: Level Up Funding may perform a credit check on the borrower as part of the loan application process.

// ○ Collateral: Some Level Up Loans may require collateral, such as business assets or personal property.

// ○ Eligibility: Borrowers must meet certain eligibility criteria, such as minimum credit score requirements and proof of income, to qualify for a Level Up Loan.''',
//             takePoints: [
//               'Competitive Interest Rates',
//               'Quick and Easy Application',
//               'Flexible Loan Terms',
//               'No Prepayment Penalties',
//               'No Hidden Fees',
//             ],
//             take: [
//               'LevelUp Loans offers competitive interest rates, which can be lower than the rates offered by other lenders.',
//               'Applying for a loan with LevelUp Loans is quick and easy. The application process can be completed online, and the company claims to provide a decision within minutes.',
//               'LevelUp Loans offers flexible loan terms, including loan amounts ranging from \$1,000 to \$50,000, and repayment periods of up to 60 months. This can help you tailor the loan to your specific needs and budget.',
//               'LevelUp Loans does not charge prepayment penalties, which means you can pay off your loan early without incurring any additional fees.',
//               'LevelUp Loans does not charge any hidden fees, so you can be sure of the total cost of your loan upfront.',
//             ],
//             notTakePoints: [
//               'Credit Requirements',
//               'Fees',
//               'Higher Interest Rates for Some Borrowers',
//               'Limited Loan Amounts',
//               'Potentially High Monthly Payments',
//             ],
//             notTake: [
//               'LevelUp Loans has credit score requirements for borrowers, which means that if you have poor credit, you may not be eligible for a loan.',
//               'While LevelUp Loans does not charge any hidden fees, it does charge origination fees, which can range from 0% to 6% of the loan amount, depending on your creditworthiness.',
//               'While LevelUp Loans offers competitive interest rates, borrowers with lower credit scores may receive higher rates, which can make the loan more expensive overall.',
//               'LevelUp Loans offers loan amounts ranging from \$1,000 to \$50,000, which may not be enough for larger purchases or expenses.',
//               'Depending on the loan amount and repayment period you choose, your monthly payments may be higher than you can comfortably afford, which can lead to financial strain.',
//             ],
//           ),
//         );

//       case groupLoans:
//         return provider.showFbOrAdxOrAdmobInterstitialAd(
//           availableAds: myAdsIdClass.availableAdsList,
//           RouteUtils.loanShortDescriptionScreen,
//           context,
//           googleInterID: myAdsIdClass.googleInterstitialId,
//           fbInterID: myAdsIdClass.facebookInterstitialId,
//           arguments: LoanDescriptionArguments(
//             sortDescriptionAppBarTitle: groupLoans,
//             loanName: groupLoans,
//             subTitle:
//                 '''○ Group Loans are loans extended to a group of individuals who collectively apply for and receive a loan.

// ○ The loan is repaid in equal installments, and the group members are jointly liable for the loan.

// ○ Group loans, also known as joint loans or collective loans, are a type of loan that is extended to a group of individuals rather than to individual borrowers. These loans are typically offered to groups of people who share a common goal or purpose, such as members of a self-help group, community organization, or cooperative.

// ○ In a group loan, each member of the group is jointly responsible for the loan repayment. The group acts as a collective unit, and the lender holds the entire group accountable for the loan. This group-based approach provides mutual support, encourages accountability, and helps mitigate the risk for lenders.
// ''',
//             eligibilityCriteria:
//                 '''○ The group should consist of 5 to 20 members

// ○ The group members should have a good credit history

// ○ The group members should have a steady source of income

// ○ The group should have a registered association or group''',
//             documents:
//                 '''○ Identification documents: Each member of the group will typically be required to provide identification documents, such as valid government-issued IDs or passports. These documents help establish the identity and personal details of the individuals involved.

// ○ Group registration documents: If the group is formally registered or organized, the lender may ask for proof of registration or incorporation. This can include documents such as a certificate of registration, articles of association, bylaws, or any other legal documentation related to the formation and operation of the group.

// ○ Group constitution or operating guidelines: In cases where the group operates based on specific rules or guidelines, lenders may request a copy of the group's constitution, operating guidelines, or similar documents. These documents outline the purpose, structure, decision-making processes, and other relevant information about the group.

// ○ Proof of group activities or business plan: Depending on the purpose of the loan, the lender may require documents that demonstrate the group's activities or business plan. This can include records of past projects, income-generating activities, financial statements, or a detailed plan outlining how the loan funds will be utilized.

// ○ Financial statements or income records: Lenders may ask for financial statements or income records of the group to assess their repayment capacity. This can include records of income, expenses, assets, liabilities, and any other financial documentation that provides insights into the group's financial situation.

// ○ Guarantees or collateral documentation: In some cases, the lender may require additional documentation related to the collateral or guarantees provided by the group. This can include property documents, asset valuations, legal agreements, or any other relevant paperwork that establishes the value and ownership of the collateral.
// ''',
//             tenureDescription:
//                 '''○ A short tenures, usually ranging from 6 months to 5 years.

// ○ The tenure or repayment period for group loans can vary depending on the terms and conditions agreed upon by the lender and the group members. The repayment tenure is typically determined based on the nature of the loan, the purpose of the loan, and the collective repayment capacity of the group.

// ○ In some cases, group loans may have shorter repayment tenures compared to individual loans. This is because group loans often target small-scale or microfinance initiatives that aim to generate income or provide short-term financial assistance to the group members. As a result, the repayment tenure may range from a few months to a couple of years.

// ''',
//             interest:
//                 '''○ The interest rate for Group Loans may vary depending on the lender and the borrower's creditworthiness.
// ○ Generally, the interest rates for Group Loans are lower than individual loans as the lender considers the group's collective repayment capacity.''',
//             loanAmount:
//                 '''○ Generally, lenders offer Group Loans ranging from \$1,000 to \$50,000, depending on the borrower's financial profile''',
//             processingFees:
//                 '''○ The processing fees for Group Loans may vary depending on the lender
// ○ Approximately 1% to 3% of the loan amount''',
//             fullDescriptionAppBarTitle: groupLoans,
//             buttonLable: 'Know More about Group Loans',
//             imgURl: AssetUtils.icGroupLoan,
//             lable1: 'What is concept of a Group Loans?',
//             description1:
//                 '''○ Group loans, also known as collective loans or solidarity loans, are a type of loan that is extended to a group of individuals who are jointly responsible for repaying the loan. These loans are typically offered by microfinance institutions or community-based organizations to low-income individuals who may not have access to traditional banking services.

// ○ Group loans work by pooling together the resources and creditworthiness of a group of borrowers, who then jointly apply for a loan. The loan is typically structured as a revolving credit facility, with each member of the group responsible for making regular repayments on the loan. The loan may also be secured by the collective assets of the group or by personal guarantees from each member.

// ○ Group loans are designed to promote social and economic development by empowering individuals who may not have access to credit to start or grow their own businesses. By pooling their resources and sharing the responsibility for repayment, group members can access larger loan amounts and lower interest rates than they would be able to on their own.

// ○ Group loans also promote financial discipline and accountability, as members are accountable to each other for meeting their repayment obligations.''',
//             lable2: 'Highlights and Advantages:',
//             description2:
//                 '''○ Access to credit: Group loans provide access to credit to individuals who may not have access to traditional banking services due to lack of collateral, credit history, or other factors.

// ○ Lower interest rates: Group loans typically have lower interest rates than individual loans, as lenders perceive group loans to be less risky due to the joint liability of the group members.

// ○ Larger loan amounts: By pooling their resources, group members can access larger loan amounts than they would be able to on their own.

// ○ Shared responsibility: Group loans promote accountability and responsibility among group members, as each member is responsible for ensuring that the loan is repaid on time.

// ○ Social benefits: Group loans can promote social cohesion and trust within the group, as well as empower marginalized communities and promote gender equality.

// ○ Financial education: Group loans often come with financial education and training programs to help members manage their finances and build their business skills.

// ○ Flexibility: Group loans are often more flexible than traditional bank loans, with less stringent requirements for collateral or credit history.''',
//             lable3: 'Risks and considerations:',
//             description3:
//                 '''○ Joint liability: With group loans, each member is jointly responsible for the repayment of the loan. If one member defaults on their payments, the other members may be held liable for the outstanding balance. This can put pressure on the group and strain relationships if members are unable to make their payments.

// ○ Lack of collateral: Group loans may not require collateral, which can make it easier for individuals to access credit. However, it also means that the lender has less security in the event of default, which can result in higher interest rates and stricter repayment terms.

// ○ High interest rates: While group loans can have lower interest rates than individual loans, they can still be relatively high compared to other forms of credit, due to the perceived risk of lending to low-income individuals.

// ○ Limited loan amounts: While group loans can provide access to larger loan amounts than individuals may be able to obtain on their own, there are still limits to the amount of credit that can be extended to the group.

// ○ Social pressure: The group dynamic of group loans can create social pressure on individual members to meet their repayment obligations, which can be stressful for some borrowers.

// ○ Limited access: Group loans are typically offered by microfinance institutions or community-based organizations, which may have limited access to capital and may only operate in specific regions or communities.''',
//             lable4: 'TERMS & CONDITIONS:',
//             description4:
//                 '''○ Loan amount: The loan amount will be determined by the lender based on the needs and capacity of the group. The amount may be disbursed in one lump sum or in multiple installments.

// ○ Interest rate: The interest rate will vary depending on the lender and the loan product. Group loans may have a lower interest rate than individual loans, but they can still be relatively high compared to other forms of credit.

// ○ Repayment schedule: The repayment schedule will be determined by the lender and will depend on the loan amount and the capacity of the group. Repayment may be made in regular installments or as a lump sum at the end of the loan term.

// ○ Joint liability: Group loans typically require joint liability among group members, meaning that each member is responsible for the repayment of the entire loan. If one member defaults on their payments, the other members may be held liable for the outstanding balance.

// ○ Collateral: Group loans may or may not require collateral, depending on the lender and the loan product. If collateral is required, it may be in the form of property or a personal guarantee.

// ○ Loan purpose: Group loans may have specific requirements for the use of funds, such as for business purposes or for a specific project. Borrowers should ensure that they understand the loan purpose before applying.

// ○ Fees and charges: Lenders may charge fees and charges for processing the loan, as well as for late or missed payments. Borrowers should carefully review the fees and charges associated with the loan before accepting the terms.''',
//             takePoints: [
//               'Lower Interest Rates',
//               'Access to Funding',
//               'Shared Responsibility',
//               'Support Network',
//               'Credit Building',
//             ],
//             take: [
//               'Group loans often have lower interest rates than individual loans because the risk is spread across multiple borrowers.',
//               'Group loans can provide access to funding that may not be available through individual loans or traditional lending sources.',
//               'Group loans require each borrower to take responsibility for their portion of the loan, which can help ensure that all borrowers are invested in the success of the loan.',
//               'Borrowers in a group loan can provide each other with support and encouragement, which can be especially beneficial for those who are starting a business or pursuing a common goal.',
//               'Successfully repaying a group loan can help build credit for all borrowers, which can be important for future borrowing opportunities.',
//             ],
//             notTakePoints: [
//               'Shared Responsibility',
//               'Group Dynamics',
//               'Limited Control',
//               'Time Commitment',
//               'Limited Availability',
//             ],
//             notTake: [
//               'While shared responsibility can be a benefit of group loans, it can also be a drawback if one borrower is unable to repay their portion of the loan, as this can impact the credit scores of all borrowers.',
//               'Borrowers in a group loan must work together to ensure the success of the loan, which can be challenging if there are disagreements or conflicts among the group.',
//               'Borrowers in a group loan may have limited control over how the loan funds are used, which can be frustrating if they have specific needs or goals that are not addressed by the loan.',
//               'Participating in a group loan may require a significant time commitment, as borrowers must attend meetings and work together to ensure the success of the loan.',
//               'Group loans may not be available in all areas or for all types of borrowing needs, which can limit their usefulness for some borrowers.',
//             ],
//           ),
//         );

//       default:
//     }
//   }
}
