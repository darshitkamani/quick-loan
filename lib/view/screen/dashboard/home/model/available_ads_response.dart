// To parse this JSON data, do
//
//     final availableScreenAdsModel = availableScreenAdsModelFromJson(jsonString);

import 'dart:convert';

AvailableScreenAdsModel availableScreenAdsModelFromJson(String str) =>
    AvailableScreenAdsModel.fromJson(json.decode(str));

String availableScreenAdsModelToJson(AvailableScreenAdsModel data) =>
    json.encode(data.toJson());

class AvailableScreenAdsModel {
  final int? status;
  final int? statusCode;
  final String? msg;
  final MonetizationData? data;

  AvailableScreenAdsModel({
    this.status,
    this.statusCode,
    this.msg,
    this.data,
  });

  factory AvailableScreenAdsModel.fromJson(Map<String, dynamic> json) =>
      AvailableScreenAdsModel(
        status: json["status"],
        statusCode: json["status_code"],
        msg: json["msg"],
        data: json["data"] == null
            ? null
            : MonetizationData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "status_code": statusCode,
        "msg": msg,
        "data": data?.toJson(),
      };
}

class MonetizationData {
  final App? app;
  final List<AppUnit>? appUnits;
  final List<AdUnit>? adUnits;
  final List<Screen>? screens;

  MonetizationData({
    this.app,
    this.appUnits,
    this.adUnits,
    this.screens,
  });

  factory MonetizationData.fromJson(Map<String, dynamic> json) =>
      MonetizationData(
        app: json["app"] == null ? null : App.fromJson(json["app"]),
        appUnits: json["app_units"] == null
            ? []
            : List<AppUnit>.from(
                json["app_units"]!.map((x) => AppUnit.fromJson(x))),
        adUnits: json["ad_units"] == null
            ? []
            : List<AdUnit>.from(
                json["ad_units"]!.map((x) => AdUnit.fromJson(x))),
        screens: json["screens"] == null
            ? []
            : List<Screen>.from(
                json["screens"]!.map((x) => Screen.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "app": app?.toJson(),
        "app_units": appUnits == null
            ? []
            : List<dynamic>.from(appUnits!.map((x) => x.toJson())),
        "ad_units": adUnits == null
            ? []
            : List<dynamic>.from(adUnits!.map((x) => x.toJson())),
        "screens": screens == null
            ? []
            : List<dynamic>.from(screens!.map((x) => x.toJson())),
      };
}

class AdUnit {
  final int? id;
  final int? appId;
  final int? appUnitId;
  final String? bannerId;
  final String? interstitialId;
  final String? rewardedInterstitialId;
  final String? rewardedId;
  final String? nativeId;
  final String? appOpenId;
  final String? facebookBannerId;
  final String? facebookInterstitialId;
  final String? facebookRewardedId;
  final String? facebookNativeId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AdUnit({
    this.id,
    this.appId,
    this.appUnitId,
    this.bannerId,
    this.interstitialId,
    this.rewardedInterstitialId,
    this.rewardedId,
    this.nativeId,
    this.appOpenId,
    this.facebookBannerId,
    this.facebookInterstitialId,
    this.facebookRewardedId,
    this.facebookNativeId,
    this.createdAt,
    this.updatedAt,
  });

  factory AdUnit.fromJson(Map<String, dynamic> json) => AdUnit(
        id: json["id"],
        appId: json["app_id"],
        appUnitId: json["app_unit_id"],
        bannerId: json["banner_id"],
        interstitialId: json["interstitial_id"],
        rewardedInterstitialId: json["rewarded_interstitial_id"],
        rewardedId: json["rewarded_id"],
        nativeId: json["native_id"],
        appOpenId: json["app_open_id"],
        facebookBannerId: json["facebook_banner_id"],
        facebookInterstitialId: json["facebook_interstitial_id"],
        facebookRewardedId: json["facebook_rewarded_id"],
        facebookNativeId: json["facebook_native_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "app_id": appId,
        "app_unit_id": appUnitId,
        "banner_id": bannerId,
        "interstitial_id": interstitialId,
        "rewarded_interstitial_id": rewardedInterstitialId,
        "rewarded_id": rewardedId,
        "native_id": nativeId,
        "app_open_id": appOpenId,
        "facebook_banner_id": facebookBannerId,
        "facebook_interstitial_id": facebookInterstitialId,
        "facebook_rewarded_id": facebookRewardedId,
        "facebook_native_id": facebookNativeId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class App {
  final int? id;
  final String? name;
  final String? secretKey;
  final int? isFacebook;
  final int? isAdx;
  final int? isAdmob;
  final int? status;
  final int? isCheckScreen;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  App({
    this.id,
    this.name,
    this.secretKey,
    this.isFacebook,
    this.isAdx,
    this.isAdmob,
    this.status,
    this.isCheckScreen,
    this.createdAt,
    this.updatedAt,
  });

  factory App.fromJson(Map<String, dynamic> json) => App(
        id: json["id"],
        name: json["name"],
        secretKey: json["secret_key"],
        isFacebook: json["is_facebook"],
        isAdx: json["is_adx"],
        isCheckScreen: json['is_check_screen'] ?? 0,
        isAdmob: json["is_admob"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "secret_key": secretKey,
        "is_facebook": isFacebook,
        "is_adx": isAdx,
        "is_admob": isAdmob,
        "status": status,
        "is_check_screen": isCheckScreen,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class AppUnit {
  final int? id;
  final int? appId;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AppUnit({
    this.id,
    this.appId,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory AppUnit.fromJson(Map<String, dynamic> json) => AppUnit(
        id: json["id"],
        appId: json["app_id"],
        name: json["name"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "app_id": appId,
        "name": name,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Screen {
  final int? id;
  final String? appId;
  final int? appUnitId;
  final String? name;
  final String? screenKey;
  final int? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Advertisement>? advertisements;
  final int isFacebook;
  final int isGoogle;

  Screen({
    this.id,
    this.appId,
    this.appUnitId,
    this.name,
    this.screenKey,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.advertisements,
    this.isFacebook = 0,
    this.isGoogle = 0,
  });

  factory Screen.fromJson(Map<String, dynamic> json) => Screen(
        id: json["id"],
        appId: json["app_id"],
        appUnitId: json["app_unit_id"],
        name: json["name"],
        screenKey: json["screen_key"],
        status: json["status"],
        isFacebook: json["is_facebook"] ?? 0,
        isGoogle: json["is_google"] ?? 0,
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        advertisements: json["advertisements"] == null
            ? []
            : List<Advertisement>.from(
                json["advertisements"]!.map((x) => Advertisement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "app_id": appId,
        "app_unit_id": appUnitId,
        "name": name,
        "screen_key": screenKey,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "is_facebook": isFacebook,
        "is_google": isGoogle,
        "updated_at": updatedAt?.toIso8601String(),
        "advertisements": advertisements == null
            ? []
            : List<dynamic>.from(advertisements!.map((x) => x.toJson())),
      };
}

class Advertisement {
  final int? id;
  final String? screenId;
  final String? name;
  final int? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Advertisement({
    this.id,
    this.screenId,
    this.name,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Advertisement.fromJson(Map<String, dynamic> json) => Advertisement(
        id: json["id"],
        screenId: json["screen_id"],
        name: json["name"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "screen_id": screenId,
        "name": name,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class MyAdsIdClass {
  MyAdsIdClass({
    this.screenName = '',
    this.googleNativeId = '',
    this.googleInterstitialId = '',
    this.googleAppOpenId = '',
    this.facebookNativeId = '',
    this.facebookInterstitialId = '',
    this.isFacebook = false,
    this.isGoogle = false,
    this.availableAdsList = const [],
  });

  String screenName;
  String googleNativeId;
  String googleInterstitialId;
  String googleAppOpenId;
  String facebookNativeId;
  String facebookInterstitialId;
  List<String> availableAdsList;
  bool isFacebook;
  bool isGoogle;
}
