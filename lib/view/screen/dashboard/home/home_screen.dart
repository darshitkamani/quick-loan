// ignore_for_file: use_build_context_synchronously
//
import 'package:action_broadcast/action_broadcast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:instant_pay/l10n/locale_keys.g.dart';
import 'package:instant_pay/utilities/assets/asset_utils.dart';
import 'package:instant_pay/utilities/colors/color_utils.dart';
import 'package:instant_pay/utilities/font/font_utils.dart';
import 'package:instant_pay/utilities/routes/routes.dart';
import 'package:instant_pay/utilities/storage/storage.dart';
import 'package:instant_pay/utilities/strings/strings_utils.dart';
import 'package:instant_pay/view/screen/dashboard/calculator/fd_calculator_screen.dart';
import 'package:instant_pay/view/screen/dashboard/home/loan_short_description_screen.dart';
import 'package:instant_pay/view/screen/dashboard/home/model/available_ads_response.dart';
import 'package:instant_pay/view/widget/ads_widget/interstitial_ads_widget.dart';
import 'package:instant_pay/view/widget/ads_widget/load_ads_by_api.dart';
import 'package:instant_pay/view/widget/bounce_click_widget.dart';
import 'package:instant_pay/view/widget/loan_button_widget.dart';
import 'package:instant_pay/view/widget/visible_ads_circular_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String screenName = "HomeScreen";
  bool isFacebookAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowFacebookAds) ?? false;
  bool isADXAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowADXAds) ?? false;
  bool isAdmobAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowAdmobAds) ?? false;
  bool isAdShow = StorageUtils.prefs.getBool(StorageKeyUtils.isAddShowInApp) ?? false;
  bool isCheckScreen = StorageUtils.prefs.getBool(StorageKeyUtils.isCheckScreenForAdInApp) ?? false;

  MyAdsIdClass myAdsIdClass = MyAdsIdClass();
  late StreamSubscription receiver;

  NativeAd? adxNativeAd;
  bool adxNativeAdLoaded = false;

  NativeAd? adxNativeAd1;
  bool adxNativeAdLoaded1 = false;

  Widget fbNativeAdWidget = const SizedBox();
  Widget fbNativeAdWidget1 = const SizedBox();
  bool isLoadingAdsWidget = false;

  bool isLangSwitchValue = false;

  @override
  void initState() {
    super.initState();
    if (!kDebugMode) {}
    initReceiver();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (!kDebugMode) {
        await FirebaseAnalytics.instance.logEvent(name: screenName);
      }
      setState(() {
        int prefferedLanguage = StorageUtils.prefs.getInt(StorageKeyUtils.applicationLanguageState) ?? 0;

        isLangSwitchValue = (prefferedLanguage == 0) ? false : true;
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
        ///Check new flow for every screen show first facebook always
        if (isCheckScreen) {
          _showFBNativeAd(isCalledFrom: 'isCheckScreen');
        } else {
          print("myAdsIdClass.isFacebook && isFacebookAdsShow --> ${myAdsIdClass.isFacebook} $isFacebookAdsShow");
          if (myAdsIdClass.isFacebook && isFacebookAdsShow) {
            _showFBNativeAd(isCalledFrom: 'else isCheckScreen ');
          }
          if (myAdsIdClass.isGoogle && isADXAdsShow) {
            loadNativeAd();
            loadNativeAd1();
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

  loadNativeAd({String isCalledFrom = 'init'}) async {
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

  loadNativeAd1({String isCalledFrom = 'init'}) async {
    print('Screen name loadNativeAd1() ---> $screenName isCalledFrom --> $isCalledFrom ');

    String nativeAdId = myAdsIdClass.googleNativeId; // AdsUnitId().getGoogleNativeAdId();
    if (nativeAdId != '') {
      setState(() {
        adxNativeAd1 = NativeAd(
          adUnitId: myAdsIdClass.googleNativeId, // nativeAdId,
          factoryId: 'listTileMedium',
          request: const AdRequest(),
          listener: NativeAdListener(
            onAdLoaded: (ad) {
              setState(() {
                adxNativeAdLoaded1 = true;
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

  updatePrefsResponse({required String adType}) {
    Timer(const Duration(seconds: 1), () {
      isFacebookAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowFacebookAds) ?? false;
      isADXAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowADXAds) ?? false;
      isAdmobAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowAdmobAds) ?? false;
      isAdShow = StorageUtils.prefs.getBool(StorageKeyUtils.isAddShowInApp) ?? false;
      setState(() {});
      if (isAdmobAdsShow) {
        setState(() {
          fbNativeAdWidget = const SizedBox();
          fbNativeAdWidget1 = const SizedBox();
        });
        if (adType == "Native") {
          loadNativeAd();
          loadNativeAd1();
        }
      }
    });
  }

  _showFBNativeAd({required String isCalledFrom}) {
    bool isFailedTwiceToLoadFbAdId = StorageUtils.prefs.getBool('${StorageKeyUtils.isFailedTwiceToLoadFbAdId}${myAdsIdClass.facebookNativeId}') ?? false;
    print('myAdsIdClass ---> ${myAdsIdClass.facebookNativeId.isEmpty}  ||$isFailedTwiceToLoadFbAdId -- > ${myAdsIdClass.facebookNativeId.isEmpty || isFailedTwiceToLoadFbAdId}');
    if (myAdsIdClass.facebookNativeId.isEmpty || isFailedTwiceToLoadFbAdId) {
      loadNativeAd(isCalledFrom: isCalledFrom);
      loadNativeAd1(isCalledFrom: isCalledFrom);
    } else {
      setState(() {
        fbNativeAdWidget = loadFbNativeAd(myAdsIdClass.facebookNativeId, isCalledFrom: isCalledFrom);
        fbNativeAdWidget1 = loadFbNativeAd(myAdsIdClass.facebookNativeId, isCalledFrom: isCalledFrom);
      });
      // updatePrefsResponse(adType: 'Native');
    }
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
            loadNativeAd(isCalledFrom: 'fbNativeFunction');
            loadNativeAd1(isCalledFrom: 'fbNativeFunction');
          }
        }
      },
      keepExpandedWhileLoading: false,
    );
  }

  Color overlayColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    List<Map<dynamic, dynamic>> loanProductsList = [
      {"name": LocaleKeys.businessLoan.tr()},
      {"name": LocaleKeys.instantLoan.tr()},
      {"name": LocaleKeys.cashLoan.tr()},
      {"name": LocaleKeys.newHomeLoan.tr()},
      {"name": LocaleKeys.homeConstructionLoan.tr()},
      {"name": LocaleKeys.loanAgainstProperty.tr()},
      {"name": LocaleKeys.securedBusinessLoan.tr()},
      {"name": LocaleKeys.groupLoans.tr()},
    ];

    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.loans.tr()),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () async {
                final provider = Provider.of<InterstitialAdsWidgetProvider>(context, listen: false);
                receiver.cancel();
                print('myAdsIdClass -screen running ad ->> $screenName${myAdsIdClass.isFacebook} ${myAdsIdClass.isGoogle}');

                provider.showFbOrAdxOrAdmobInterstitialAd(
                  myAdsIdClass: myAdsIdClass,
                  availableAds: myAdsIdClass.availableAdsList,
                  isFreeAds: true,
                  RouteUtils.helpScreen,
                  context,
                  googleInterID: myAdsIdClass.googleInterstitialId,
                  fbInterID: myAdsIdClass.facebookInterstitialId,
                );
              },
              icon: const Icon(Icons.help_outline_rounded)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlutterSwitch(
                height: 33.0,
                width: 55.0,
                toggleSize: 25.0,
                value: isLangSwitchValue,
                borderRadius: 30.0,
                activeToggleColor: const Color(0xFFFFFFFF),
                inactiveToggleColor: const Color(0xFFFFFFFF),
                activeColor: const Color(0xFFFFFFFF),
                inactiveColor: const Color(0xFFFFFFFF),
                activeIcon: const Image(image: AssetImage(AssetUtils.hinLogo), fit: BoxFit.cover),
                inactiveIcon: const Image(image: AssetImage(AssetUtils.engLogo), fit: BoxFit.cover),
                onToggle: (val) {
                  if (EasyLocalization.of(context)?.currentLocale == const Locale('en', 'US')) {
                    EasyLocalization.of(context)?.setLocale(const Locale('hi', 'IN'));
                    StorageUtils.prefs.setInt(StorageKeyUtils.applicationLanguageState, 1);
                  } else if (EasyLocalization.of(context)?.currentLocale == const Locale('hi', 'IN')) {
                    EasyLocalization.of(context)?.setLocale(const Locale('en', 'US'));
                    StorageUtils.prefs.setInt(StorageKeyUtils.applicationLanguageState, 0);
                  }
                  setState(() {
                    isLangSwitchValue = val;
                  });
                },
              ),
            ],
          ),
          const SizedBox(width: 10),

          // IconButton(
          //     onPressed: () async {
          //       Share.share('Check out this loan APP :\nhttps://play.google.com/store/apps/details?id=com.loan.fundmentor_aa_credit_aa_kredit_loan_guide_instant_loan_smartcoin_personal_app_navi_loan_guide_app_instant_personal_loan_advisor_quick_loan');
          //     },
          //     icon: const Icon(Icons.ios_share_outlined)),
        ],
      ),
      body: VisibleAdsCircularWidget(
        isVisible: isLoadingAdsWidget,
        child: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                  const SizedBox(height: 10),
                    fbNativeAdWidget,
                    (adxNativeAdLoaded && adxNativeAd != null)
                        ? Container(
                            color: Colors.transparent,
                            height: 275,
                            alignment: Alignment.center,
                            child: AdWidget(ad: adxNativeAd!),
                          )
                        : const SizedBox(),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          LocaleKeys.ourServices.tr(),
                          style: FontUtils.h16(fontColor: ColorUtils.themeColor.oxff000000, fontWeight: FWT.semiBold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.5,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                        ),
                        itemCount: loanProductsList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return LoanButtonWidget(
                            title: loanProductsList[index]['name'],
                            titleWidget: Image(
                              image: AssetImage(loanProductsImageList[index]['img']),
                              height: 60,
                            ),
                            onTap: () {
                              getLoanDetails(loanProductsImageList[index]['title']!);
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    myWidget(AssetUtils.icMutualFundsDash, () {
                      getLoanDetails(mutualFundsGuidance);
                    }),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: BounceClickWidget(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return const FDCalculator();
                          }));
                        },
                        child: Stack(
                          children: [
                            Container(
                              height: screenSize.height * 0.30,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                boxShadow: const [BoxShadow(color: Colors.black, blurRadius: 10, spreadRadius: -7)],
                                borderRadius: BorderRadius.circular(20),
                                color: ColorUtils.themeColor.oxffFFFFFF,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: const Image(
                                  image: AssetImage(AssetUtils.fdCalculator),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // Positioned(
                            //   left: 20,
                            //   top: 60,
                            //   child: Text(
                            //     'FD\nCALCULATOR',
                            //     textAlign: TextAlign.center,
                            //     style: FontUtils.h26(fontWeight: FWT.bold),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    fbNativeAdWidget1,
                    (adxNativeAdLoaded1 && adxNativeAd1 != null)
                        ? Container(
                            color: Colors.transparent,
                            height: 275,
                            alignment: Alignment.center,
                            child: AdWidget(ad: adxNativeAd1!),
                          )
                        : const SizedBox(),
                    const SizedBox(height: 5),
                    myWidget(AssetUtils.icDigitalGold, () {
                      getLoanDetails(digitalGoldGuidance);
                    }),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<dynamic, dynamic>> loanProductsImageList = [
    {
      'img': AssetUtils.k_business,
      "title": businessLoan,
    },
    {
      'img': AssetUtils.k_instant,
      "title": instantLoan,
    },
    {
      'img': AssetUtils.k_cash,
      "title": cashLoan,
    },
    {
      'img': AssetUtils.k_homeLoan,
      "title": newHomeLoan,
    },
    {
      'img': AssetUtils.k_home,
      "title": homeConstructionLoan,
    },
    {
      'img': AssetUtils.k_loan,
      "title": loanAgainstProperty,
    },
    {
      'img': AssetUtils.k_secured,
      "title": securedBusinessLoan,
    },
    {
      'img': AssetUtils.k_group,
      "title": groupLoans,
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

  Widget myWidget(String img, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BounceClickWidget(onTap: onTap, child: Image(image: AssetImage(img))),
      ),
    );
  }
}

List<String> parseStringToList(String inputString) {
  List<String> resultList = inputString.substring(1, inputString.length - 2).split("','");

  return resultList;
}

class OverlayContainer extends StatefulWidget {
  const OverlayContainer({super.key});

  @override
  _OverlayContainerState createState() => _OverlayContainerState();
}

class _OverlayContainerState extends State<OverlayContainer> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          isTapped = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          isTapped = false;
        });
      },
      onTap: () {
        setState(() {
          isTapped = true;
        });
        Timer(const Duration(milliseconds: 300), () {
          setState(() {
            isTapped = false;
          });
        });
      },
      onTapCancel: () {},
      child: Container(
        width: 200,
        height: 200,
        color: Colors.blue,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: isTapped ? 0.5 : 1.0,
          child: Container(
            color: Colors.red, // Overlay color
          ),
        ),
      ),
    );
  }
}
