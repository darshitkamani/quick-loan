import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:instant_pay/utilities/storage/storage.dart';
import 'package:instant_pay/view/screen/dashboard/home/model/available_ads_response.dart';

class LoadAdsByApi {
  bool isFacebookAdsShow =
      StorageUtils.prefs.getBool(StorageKeyUtils.isShowFacebookAds) ?? false;
  bool isADXAdsShow =
      StorageUtils.prefs.getBool(StorageKeyUtils.isShowADXAds) ?? false;
  bool isAdmobAdsShow =
      StorageUtils.prefs.getBool(StorageKeyUtils.isShowAdmobAds) ?? false;
  bool isAdShow =
      StorageUtils.prefs.getBool(StorageKeyUtils.isAddShowInApp) ?? false;

  Future<MyAdsIdClass> isAvailableAds({
    required BuildContext context,
    required String screenName,
  }) async {
    MyAdsIdClass myAdsIdClass = MyAdsIdClass();
    if (isAdShow) {
      // List<MonetizationData> list = List<MonetizationData>.from(jsonDecode(StorageUtils.prefs.getString(StorageKeyUtils.availableScreensToShowAds) ?? '').map((x) => Screen.fromJson(x)));

      MonetizationData monetizationData = MonetizationData.fromJson(jsonDecode(
          StorageUtils.prefs
                  .getString(StorageKeyUtils.availableScreensToShowAds) ??
              ''));

      if (monetizationData.screens != null) {
        for (var j = 0; j < monetizationData.screens!.length; j++) {
          if (monetizationData.screens![j].name == screenName) {
            myAdsIdClass.isFacebook =
                monetizationData.screens![j].isFacebook == 0 ? false : true;
            myAdsIdClass.isGoogle =
                monetizationData.screens![j].isGoogle == 0 ? false : true;
            myAdsIdClass.availableAdsList = await loadAd(
                availableAds: monetizationData.screens![j].advertisements!);
            for (var k = 0; k < monetizationData.appUnits!.length; k++) {
              if (monetizationData.screens![j].appUnitId ==
                  monetizationData.adUnits![k].appUnitId) {
                // print(
                //     "monetizationData.adUnits![k] screen name $screenName -->${monetizationData.screens![j].appUnitId} ${monetizationData.adUnits![k].appUnitId} ${monetizationData.adUnits![k].toJson()}");
                myAdsIdClass.googleNativeId =
                    monetizationData.adUnits![k].nativeId!;
                myAdsIdClass.googleInterstitialId =
                    monetizationData.adUnits![k].interstitialId!;
                myAdsIdClass.googleAppOpenId =
                    monetizationData.adUnits![k].appOpenId!;
                myAdsIdClass.facebookInterstitialId =
                    monetizationData.adUnits![k].facebookInterstitialId!;
                myAdsIdClass.facebookNativeId =
                    monetizationData.adUnits![k].facebookNativeId!;
                break;
              }
            }
            break;
          }
        }
      }
    }

    debugPrint(
        'AVAILABLE ADS LIST IN $screenName -- ${myAdsIdClass.availableAdsList.toString()}');
    return myAdsIdClass;
  }

  Future<List<String>> loadAd(
      {required List<Advertisement> availableAds}) async {
    List<String> adsList = [];
    if (availableAds.isNotEmpty) {
      for (int i = 0; i < availableAds.length; i++) {
        if (availableAds[i].name == "Interstitial") {
          if (availableAds[i].status == 1) {
            adsList.add(availableAds[i].name!);
          }
        }
        if (availableAds[i].name == "Rewarded") {
          if (availableAds[i].status == 1) {
            adsList.add(availableAds[i].name!);
          }
        }
        if (availableAds[i].name == "Native") {
          if (availableAds[i].status == 1) {
            adsList.add(availableAds[i].name!);
          }
        }
        if (availableAds[i].name == "Banner") {
          if (availableAds[i].status == 1) {
            adsList.add(availableAds[i].name!);
          }
        }
        if (availableAds[i].name == "AppOpen") {
          if (availableAds[i].status == 1) {
            adsList.add(availableAds[i].name!);
          }
        }
      }
    }
    return adsList;
  }
}
