import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

final adUnitId = Platform.isAndroid
    ? 'ca-app-pub-3940256099942544/1033173712'
    : 'ca-app-pub-3940256099942544/4411468910';

class AdmobUsecase {
  InterstitialAd? _interstitialAd;

  Future<void> loadInterstitialAd() async {
    InterstitialAd.load(
      adUnitId: adUnitId, // テスト用の広告ユニットID
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Interstitial ad failed to load: $error');
        },
      ),
    );
  }

  // 広告を表示するメソッド
  void showInterstitialAd({VoidCallback? onAdClosed}) {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          if (onAdClosed != null) {
            onAdClosed();
          }
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          if (onAdClosed != null) {
            onAdClosed();
          }
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null; // 広告を表示した後はnullにする
    } else {
      print('Interstitial ad is not ready yet.');
      if (onAdClosed != null) {
        onAdClosed();
      }
    }
  }
}