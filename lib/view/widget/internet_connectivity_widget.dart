// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:instant_pay/utilities/assets/asset_utils.dart';
import 'package:instant_pay/utilities/colors/color_utils.dart';
import 'package:instant_pay/utilities/env/env_utils.dart';
import 'package:instant_pay/utilities/font/font_utils.dart';
import 'package:instant_pay/utilities/storage/storage.dart';
import 'package:instant_pay/view/screen/dashboard/home/model/available_ads_response.dart';
import 'package:instant_pay/view/widget/center_text_button_widget.dart';

class ConnectivityIndicatorWidget extends StatefulWidget {
  const ConnectivityIndicatorWidget({super.key});

  @override
  _ConnectivityIndicatorWidgetState createState() =>
      _ConnectivityIndicatorWidgetState();
}

class _ConnectivityIndicatorWidgetState
    extends State<ConnectivityIndicatorWidget> {
  bool isInternetAvailable = true;

  @override
  void initState() {
    super.initState();
    ConnectivityService((result, isOnline) async {
      // Timer(const Duration(seconds: 2), () {
      //   hideStatus();
      // });
      switch (result) {
        case ConnectivityResult.none:
          setState(() {
            isInternetAvailable = false;
          });
          break;
        case ConnectivityResult.wifi:
          setState(() {
            isInternetAvailable = true;
          });
          break;
        case ConnectivityResult.mobile:
          setState(() {
            isInternetAvailable = true;
          });
          break;
        case ConnectivityResult.bluetooth:
        case ConnectivityResult.ethernet:
        case ConnectivityResult.vpn:
        case ConnectivityResult.other:
          break;
      }
    }).initialize();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return isInternetAvailable
        ? const SizedBox()
        : Material(
            color: Colors.transparent,
            child: Container(
              height: screenSize.height,
              width: screenSize.width,
              decoration: const BoxDecoration(color: Colors.white),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      AssetUtils.noInternetLottie,
                      height: 300,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "It seems like your internet connection is off.",
                        textAlign: TextAlign.center,
                        style: FontUtils.h16(
                            fontColor: ColorUtils.themeColor.oxff447D58,
                            fontWeight: FWT.medium),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CenterTextButtonWidget(
                      onTap: () async {
                        ConnectivityResult connectivityResult =
                            await Connectivity().checkConnectivity();

                        if (connectivityResult == ConnectivityResult.mobile ||
                            connectivityResult == ConnectivityResult.wifi) {
                          // print("StorageUtils.prefs =--> ${StorageUtils.prefs}");
                          // if(StorageUtils.prefs ){}

                          bool isUserFirstTime = StorageUtils.prefs
                                  .getBool(StorageKeyUtils.isUserFirstTime) ??
                              false;
                          if (isUserFirstTime == false) {
                            StorageUtils.prefs
                                .setBool(StorageKeyUtils.isUserFirstTime, true);
                          }
                          // Navigator.pushNamedAndRemoveUntil(context, RouteUtils.dashboardScreen, (route) => false);
                        } else {
                          Fluttertoast.showToast(msg: 'No Internet!');
                        }
                      },
                      title: 'Check Status',
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

typedef ConnectivityCallback = Function(
    ConnectivityResult state, bool isConnected);

class ConnectivityService {
  ConnectivityCallback? callback;

  static ConnectivityService? instance;

  ConnectivityResult result = ConnectivityResult.none;
  bool isConnected = false;

  ConnectivityService._();

  factory ConnectivityService(ConnectivityCallback callback) {
    if (instance == null) {
      instance = ConnectivityService._();
      instance!.callback = callback;
      return instance!;
    } else {
      instance!.callback = callback;
      return instance!;
    }
  }

  Connectivity connectivity = Connectivity();

  void initialize() async {
    ConnectivityResult result = await connectivity.checkConnectivity();
    _checkStatus(result);
    connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        bool isUserFirstTime =
            StorageUtils.prefs.getBool(StorageKeyUtils.isUserFirstTime) ??
                false;
        if (isUserFirstTime == false) {
          Timer(const Duration(seconds: 1), () async {
            String prefsAvailableScreens = StorageUtils.prefs
                    .getString(StorageKeyUtils.availableScreensToShowAds) ??
                '';
            if (prefsAvailableScreens == '') {
              // print("ABC ===> ");
              var res = await http.get(
                Uri.parse(dotenv.get(EnvUtils.getAppDataAdsApiUrl)),
                headers: {"secret_key": dotenv.get(EnvUtils.secretKey)},
              );
              if (res.statusCode == 200) {
                // print("ABC ===> DEF ");

                AvailableScreenAdsModel availableScreenAdsModel =
                    AvailableScreenAdsModel.fromJson(jsonDecode(res.body));

                StorageUtils.prefs.setBool(
                    StorageKeyUtils.isAddShowInApp,
                    availableScreenAdsModel.data!.app!.status == 0
                        ? false
                        : true);

                StorageUtils.prefs.setBool(
                    StorageKeyUtils.isShowFacebookAds,
                    availableScreenAdsModel.data!.app!.isFacebook == 0
                        ? false
                        : true);

                StorageUtils.prefs.setBool(
                    StorageKeyUtils.isShowADXAds,
                    availableScreenAdsModel.data!.app!.isAdx == 0
                        ? false
                        : true);

                StorageUtils.prefs.setBool(
                    StorageKeyUtils.isShowAdmobAds,
                    availableScreenAdsModel.data!.app!.isAdmob == 0
                        ? false
                        : true);

                StorageUtils.prefs.setString(
                    StorageKeyUtils.availableScreensToShowAds,
                    jsonEncode(availableScreenAdsModel.data));
                StorageUtils.prefs
                    .setBool(StorageKeyUtils.isUserFirstTime, true);
              }
            }
          });
        }
      }
    });
  }

  void _checkStatus(ConnectivityResult cResult) async {
    result = cResult;
    isConnected = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      } else {
        isConnected = false;
      }
    } on SocketException {
      isConnected = false;
    }
    instance?.callback!(result, isConnected);
  }
}
