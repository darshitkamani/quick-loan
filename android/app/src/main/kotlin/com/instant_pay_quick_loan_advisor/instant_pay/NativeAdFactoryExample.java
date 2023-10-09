package com.instant_pay_quick_loan_advisor.instant_pay;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.RatingBar;
import android.widget.TextView;
import com.google.android.gms.ads.nativead.MediaView;
import com.google.android.gms.ads.nativead.NativeAd;
import com.google.android.gms.ads.nativead.NativeAdView;
import com.instant_pay_quick_loan_advisor.R;

import java.util.Map;

import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin;

class NativeAdFactoryMedium implements GoogleMobileAdsPlugin.NativeAdFactory {

    private final Context context;

    NativeAdFactoryMedium(Context context) {
        this.context = context;
    }


    public  NativeAdView createNativeAd(NativeAd nativeAd, Map<String, Object> customOptions) {
        NativeAdView nativeAdView = (NativeAdView) LayoutInflater.from(context)
                .inflate(R.layout.my_native_ad, null);



//    attribution

        TextView attributionViewSmall = nativeAdView
                .findViewById(R.id.native_ad_attribution_small);


        attributionViewSmall.setVisibility(View.VISIBLE);
// icon

        nativeAdView.setIconView(nativeAdView.findViewById(R.id.native_ad_icon));
        if (nativeAd.getIcon() == null) {
            nativeAdView.getIconView().setVisibility(View.GONE);

        } else {
            ((ImageView)nativeAdView.getIconView()).setImageDrawable(nativeAd.getIcon().getDrawable());

        }

//  media
        MediaView mediaView = nativeAdView.findViewById(R.id.native_ad_media);
        mediaView.setMediaContent(nativeAd.getMediaContent());
        nativeAdView.setMediaView(mediaView);

// button

        nativeAdView.setCallToActionView(nativeAdView.findViewById(R.id.native_ad_button));
        if(nativeAd.getCallToAction()==null){
            nativeAdView.getCallToActionView().setVisibility(View.INVISIBLE);
        }else{
            ((Button)nativeAdView.getCallToActionView()).setText(nativeAd.getCallToAction());
        }

//   headline
        nativeAdView.setHeadlineView(nativeAdView.findViewById(R.id.native_ad_headline));
        ((TextView)nativeAdView.getHeadlineView()).setText(nativeAd.getHeadline());

//  bodyView
        nativeAdView.setBodyView(nativeAdView.findViewById(R.id.native_ad_body));
        if(nativeAd.getBody()==null){
            nativeAdView.getBodyView().setVisibility(View.INVISIBLE);
        }else {
            ((TextView)nativeAdView.getBodyView()).setText(nativeAd.getBody());
            nativeAdView.getBodyView().setVisibility(View.VISIBLE);
        }

//    advertiser name
        nativeAdView.setAdvertiserView(nativeAdView.findViewById(R.id.native_ad_advertiser));
        if(nativeAd.getAdvertiser()==null){
            nativeAdView.getAdvertiserView().setVisibility(View.GONE);
        }else {
            ((TextView)nativeAdView.getAdvertiserView()).setText(nativeAd.getAdvertiser());
            nativeAdView.getAdvertiserView().setVisibility(View.VISIBLE);
        }
//   ratingbar
        nativeAdView.setStarRatingView(nativeAdView.findViewById(R.id.native_ad_rating));
        if(nativeAd.getStarRating()==null){
            nativeAdView.getStarRatingView().setVisibility(View.INVISIBLE);
        }else{
            ((RatingBar)nativeAdView.getStarRatingView()).setRating(nativeAd.getStarRating().floatValue());
            nativeAdView.getStarRatingView().setVisibility(View.VISIBLE);

        }




        nativeAdView.setNativeAd(nativeAd);

        return nativeAdView;
    }
}


//package com.instant_pay_quick_loan_advisor.instant_pay;
//// Copyright 2021 Google LLC
////
//// Licensed under the Apache License, Version 2.0 (the "License");
//// you may not use this file except in compliance with the License.
//// You may obtain a copy of the License at
////
//// https://www.apache.org/licenses/LICENSE-2.0
////
//// Unless required by applicable law or agreed to in writing, software
//// distributed under the License is distributed on an "AS IS" BASIS,
//// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//// See the License for the specific language governing permissions and
//// limitations under the License.
//
//
//
//import android.view.LayoutInflater;
//import android.view.View;
//import android.widget.Button;
//import android.widget.ImageView;
//import android.widget.RatingBar;
//import android.widget.TextView;
//
//import com.google.android.gms.ads.nativead.MediaView;
//import com.google.android.gms.ads.nativead.NativeAd;
//import com.google.android.gms.ads.nativead.NativeAdView;
//import com.instant_pay_quick_loan_advisor.R;
//
//
//import java.util.Map;
//
//import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory;
//
//class NativeAdFactoryExample implements NativeAdFactory {
//    private final LayoutInflater layoutInflater;
//
//    NativeAdFactoryExample(LayoutInflater layoutInflater) {
//        this.layoutInflater = layoutInflater;
//    }
//
//    @Override
//    public NativeAdView createNativeAd(NativeAd nativeAd, Map<String, Object> customOptions) {
//        final NativeAdView adView = (NativeAdView) layoutInflater.inflate(R.layout.my_native_ad, null);
//
//        // Set the media view.
//        adView.setMediaView((MediaView) adView.findViewById(R.id.ad_media));
//
//        // Set other ad assets.
//        adView.setHeadlineView(adView.findViewById(R.id.ad_headline));
//        adView.setBodyView(adView.findViewById(R.id.ad_body));
//        adView.setCallToActionView(adView.findViewById(R.id.ad_call_to_action));
//        adView.setIconView(adView.findViewById(R.id.ad_app_icon));
//        adView.setPriceView(adView.findViewById(R.id.ad_price));
//        adView.setStarRatingView(adView.findViewById(R.id.ad_stars));
//        adView.setStoreView(adView.findViewById(R.id.ad_store));
//        adView.setAdvertiserView(adView.findViewById(R.id.ad_advertiser));
//
//        // The headline and mediaContent are guaranteed to be in every NativeAd.
//        ((TextView) adView.getHeadlineView()).setText(nativeAd.getHeadline());
//        adView.getMediaView().setMediaContent(nativeAd.getMediaContent());
//
//        // These assets aren't guaranteed to be in every NativeAd, so it's important to
//        // check before trying to display them.
//        if (nativeAd.getBody() == null) {
//            adView.getBodyView().setVisibility(View.INVISIBLE);
//        } else {
//            adView.getBodyView().setVisibility(View.VISIBLE);
//            ((TextView) adView.getBodyView()).setText(nativeAd.getBody());
//        }
//
//        if (nativeAd.getCallToAction() == null) {
//            adView.getCallToActionView().setVisibility(View.INVISIBLE);
//        } else {
//            adView.getCallToActionView().setVisibility(View.VISIBLE);
//            ((Button) adView.getCallToActionView()).setText(nativeAd.getCallToAction());
//        }
//
//        if (nativeAd.getIcon() == null) {
//            adView.getIconView().setVisibility(View.GONE);
//        } else {
//            ((ImageView) adView.getIconView()).setImageDrawable(nativeAd.getIcon().getDrawable());
//            adView.getIconView().setVisibility(View.VISIBLE);
//        }
//
//        if (nativeAd.getPrice() == null) {
//            adView.getPriceView().setVisibility(View.INVISIBLE);
//        } else {
//            adView.getPriceView().setVisibility(View.VISIBLE);
//            ((TextView) adView.getPriceView()).setText(nativeAd.getPrice());
//        }
//
//        if (nativeAd.getStore() == null) {
//            adView.getStoreView().setVisibility(View.INVISIBLE);
//        } else {
//            adView.getStoreView().setVisibility(View.VISIBLE);
//            ((TextView) adView.getStoreView()).setText(nativeAd.getStore());
//        }
//
//        if (nativeAd.getStarRating() == null) {
//            adView.getStarRatingView().setVisibility(View.INVISIBLE);
//        } else {
//            ((RatingBar) adView.getStarRatingView()).setRating(nativeAd.getStarRating().floatValue());
//            adView.getStarRatingView().setVisibility(View.VISIBLE);
//        }
//
//        if (nativeAd.getAdvertiser() == null) {
//            adView.getAdvertiserView().setVisibility(View.INVISIBLE);
//        } else {
//            adView.getAdvertiserView().setVisibility(View.VISIBLE);
//            ((TextView) adView.getAdvertiserView()).setText(nativeAd.getAdvertiser());
//        }
//
//        // This method tells the Google Mobile Ads SDK that you have finished populating your
//        // native ad view with this native ad.
//        adView.setNativeAd(nativeAd);
//
//        return adView;
//    }
//}
