// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:instant_pay/utilities/env/env_utils.dart';
import 'package:instant_pay/utilities/storage/storage.dart';
import 'package:instant_pay/view/screen/dashboard/dashboard_screen.dart';
import 'package:instant_pay/view/screen/dashboard/home/model/available_ads_response.dart';

class SplashProvider extends ChangeNotifier {
  getRoutes({required BuildContext context}) async {
    Future.delayed(
      const Duration(seconds: 3),
      () async {
        await getApiData(context: context);

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DashboardScreen(routeName: 'SplashScreen')),
            (route) => false);
      },
    );
  }

  Future getApiData({required BuildContext context}) async {
    try {
      var res = await http.get(
        Uri.parse(dotenv.get(EnvUtils.getAppDataAdsApiUrl)),
        headers: {"secret_key": dotenv.get(EnvUtils.secretKey)},
      );

      // log(res.body);

      if (res.statusCode == 200) {
        AvailableScreenAdsModel availableScreenAdsModel =
            AvailableScreenAdsModel.fromJson(jsonDecode(res.body));

        ///Ads Status [On/Off]
        StorageUtils.prefs.setBool(StorageKeyUtils.isAddShowInApp,
            availableScreenAdsModel.data!.app!.status == 0 ? false : true);

        StorageUtils.prefs.setBool(StorageKeyUtils.isShowFacebookAds,
            availableScreenAdsModel.data!.app!.isFacebook == 0 ? false : true);

        StorageUtils.prefs.setBool(StorageKeyUtils.isShowADXAds,
            availableScreenAdsModel.data!.app!.isAdx == 0 ? false : true);

        StorageUtils.prefs.setBool(StorageKeyUtils.isShowAdmobAds,
            availableScreenAdsModel.data!.app!.isAdmob == 0 ? false : true);

        StorageUtils.prefs.setBool(
            StorageKeyUtils.isCheckScreenForAdInApp,
            availableScreenAdsModel.data!.app!.isCheckScreen == 0
                ? false
                : true);

        StorageUtils.prefs.setString(StorageKeyUtils.availableScreensToShowAds,
            jsonEncode(availableScreenAdsModel.data));

        // if (kDebugMode) {
        // StorageUtils.prefs.setBool(StorageKeyUtils.isShowFacebookAds, false);
        // StorageUtils.prefs.setBool(StorageKeyUtils.isShowADXAds, true);
        // StorageUtils.prefs.setBool(StorageKeyUtils.isShowAdmobAds, true);
        //   StorageUtils.prefs
        //       .setBool(StorageKeyUtils.isCheckScreenForAdInApp, false);
        // }

        StorageUtils.prefs.setBool(StorageKeyUtils.isUserFirstTime, true);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Something went Wrong!');
    }
  }
}
