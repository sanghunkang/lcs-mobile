import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  bool _isInitialized = false;

  void loadBanner(Function(BannerAd) onBannerLoaded) async {
    await _initialize();
    final banner = BannerAd(
      adUnitId: _getBannerAdUnitId(),
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => onBannerLoaded(ad as BannerAd),
        // onAdFailedToLoad: (ad, error) {},
      ),
    );
    banner.load();
  }

  void loadInterstitial(Function(InterstitialAd) onInterstitialLoaded) async {
    await _initialize();
    InterstitialAd.load(
      adUnitId: _getInterstitialAdUnitId(),
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => onInterstitialLoaded(ad),
        onAdFailedToLoad: (e) {
          debugPrint(e.toString());
        },
      ),
    );
  }

  Future<void> _initialize() async {
    if (!_isInitialized) {
      await _requestTrackingIfNeeded();
      await MobileAds.instance.initialize();
      _isInitialized = true;
    }
    return;
  }

  Future<void> _requestTrackingIfNeeded() async {
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;

    if (status == TrackingStatus.notDetermined) {
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }

  String _getBannerAdUnitId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    }

    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716'; // test
    }

    throw UnsupportedError('Unsupported platform');
  }

  String _getInterstitialAdUnitId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712';
    }

    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910'; // test
    }

    throw UnsupportedError('Unsupported platform');
  }
}
