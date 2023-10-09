package com.quick_loan_credit_card_advisor.instant_pay;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin;


public class MainActivity extends FlutterActivity {
    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        // TODO: Register the ListTileNativeAdFactory

        GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, "listTileMedium",
                new NativeAdFactoryMedium(getContext()));
    }

    @Override
    public void cleanUpFlutterEngine(FlutterEngine flutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine);

        // TODO: Unregister the ListTileNativeAdFactory
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "listTileMedium");
    }
}

//public class MainActivity extends FlutterActivity {
//    @Override
//    public void configureFlutterEngine(FlutterEngine flutterEngine) {
//        super.configureFlutterEngine(flutterEngine);
//        final NativeAdFactory factory = new NativeAdFactoryExample(getLayoutInflater());
//        GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, "adFactory", factory);
//    }
//
//    @Override
//    public void cleanUpFlutterEngine(FlutterEngine flutterEngine) {
//        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "adFactory");
//    }
//}
