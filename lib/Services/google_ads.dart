import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class GoogleAdsManager extends GetxController{
  InterstitialAd? interstitialAd;
  RewardedAd? rewardedAd;

  void loadAd() {
    RewardedAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/5224354917',
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            rewardedAd = ad;
            update();
          },
          onAdFailedToLoad: (error) {},
        ));
  }

  void interAds() {
    try{
      InterstitialAd.load(
          adUnitId: 'ca-app-pub-3940256099942544/1033173712',
          request: const AdRequest(),
          adLoadCallback: InterstitialAdLoadCallback(
              onAdLoaded: (ad) {
                interstitialAd = ad;
                update();
              },
              onAdFailedToLoad: (error) {}));
    }catch(e){
      print(e);
      rethrow;
    }
  }

}

