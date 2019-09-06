import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:notes/environment.dart';

MobileAdTargetingInfo _targetingInfo = MobileAdTargetingInfo(
  keywords: <String>[
    'business',
    'education',
    'business modelling',
    'business model canvas',
    'BCM',
    'Startup ideas',
    'business ideas',
    'strategyzer',
    'business strategy',
    'business analysis'
  ],
  // TODO : add relevant URL
  contentUrl: '',
  childDirected: false,
  testDevices: <
      String>[], // Android emulators are considered test devices, needed only for debug.
);

InterstitialAd _interstitialAd;

_createAd() {
  _interstitialAd = InterstitialAd(
    // TODO: This is a test AdUnit Id. should be replaced with actual Ad Id.
    adUnitId: AppEnvironment.isInDebugMode
        ? InterstitialAd.testAdUnitId
        : 'ca-app-pub-5385464425046425/9415040610',
    // adUnitId: InterstitialAd.testAdUnitId,
    targetingInfo: _targetingInfo,
    listener: (MobileAdEvent event) {
      switch (event) {
        case MobileAdEvent.closed:
          // when Ad is closed dispose it and load new Ad.
          _interstitialAd.dispose();
          AdMobWidget.loadAd();
          break;
        default:
          break;
      }
    },
  );
}

class AdMobWidget {
  static final AdMobWidget _programizAdMob = AdMobWidget._internal();

  static void init() {
    // This is a Temp Test App Id. should be replaced with actual app Id
    FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-5385464425046425~3794499539');
    loadAd();
  }

  factory AdMobWidget() {
    return _programizAdMob;
  }

  AdMobWidget._internal();

  // static final _bannerAdloadController = StreamController<bool>.broadcast();

  // static Stream<bool> get bannerLoadStream => _bannerAdloadController.stream;

  // to preload a Ad
  static Future<void> loadAd() async {
    _createAd();
    return _interstitialAd..load();
  }

  // to show a preloaded Ad
  // Ad should be loaded first
  static Future<void> showPreloadedInterStialAd() async {
    if (await _interstitialAd.isLoaded())
      _interstitialAd..show();
    else
      showInterStialAd();
  }

  // to load an Ad and show it
  static void showInterStialAd() {
    _createAd();
    _interstitialAd
      ..load()
      ..show();
  }

  ////

  static bool isAdActive = false;

  // static BannerAd myBanner = BannerAd(
  //   // Replace the testAdUnitId with an ad unit id from the AdMob dash.
  //   // https://developers.google.com/admob/android/test-ads
  //   // https://developers.google.com/admob/ios/test-ads
  //   adUnitId: AppEnvironment.isInDebugMode
  //       ? BannerAd.testAdUnitId
  //       : "ca-app-pub-5385464425046425/6015734196",
  //   // adUnitId: BannerAd.testAdUnitId,
  //   // size: AdSize.smartBanner,
  //   size: AdSize.banner,
  //   targetingInfo: _targetingInfo,
  //   listener: (MobileAdEvent event) {
  //     // print("BannerAd event is $event");
  //   },
  // );

  // static Future<Null> buildBannerAd(double anchorOffset) async {
  //   if (!isAdActive)
  //     // typically this happens well before the ad is shown

  //     await myBanner.load();
  //   var isBannerAdLoaded = await myBanner.isLoaded();
  //   _bannerAdloadController.sink.add(isBannerAdLoaded);

  //   if (isBannerAdLoaded) {
  //     myBanner
  //         .show(
  //       // Positions the banner ad 60 pixels from the bottom of the screen
  //       anchorOffset: anchorOffset,
  //       // Banner Position
  //       anchorType: AnchorType.bottom,
  //     )
  //         .then((status) {
  //       if (status) isAdActive = true;
  //     });
  //   }
  // }

  // static Future<Null> disposeBannerAd() async {
  //   myBanner
  //     ..dispose().then((status) {
  //       _bannerAdloadController.sink.add(false);
  //       if (status) isAdActive = false;
  //     });
  // }

  // static dispose() {
  //   _bannerAdloadController.close();
  // }
}
