import 'package:google_mobile_ads/google_mobile_ads.dart';


class GoogleAdsManager{
  BannerAd? bannerAd;
  InterstitialAd? interstitialAd;

  void bannerAds() {
    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: "ca-app-pub-3403605839455121/6709723471",
        listener: const BannerAdListener(),
        request: const AdRequest());

    bannerAd!.load();
  }

  void interAds() {
    InterstitialAd.load(
        adUnitId: "ca-app-pub-3403605839455121/6709723471",
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) {
              interstitialAd = ad;
            },
            onAdFailedToLoad: (error) {}));
  }

}

