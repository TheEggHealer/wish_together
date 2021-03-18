
import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:wishtogether/constants.dart';

class AdService {

  static bool get hasAds {
    return false;
  }

  static double get adHeight {
    if(hasAds) {
      if (Platform.isAndroid) {
        return 60;
      } else if (Platform.isIOS) {
        return 70;
      }
    }
    return 0;
  }

  static MobileAdTargetingInfo targetInfo = MobileAdTargetingInfo(
    testDevices: ['a044f0e1976dc9cc23c660a6c7c60df8'],
  );

  static String get appId {
    if(Platform.isAndroid) {
      return 'ca-app-pub-7768123198632313~8206192262';
    } else if(Platform.isIOS) {
      return 'ca-app-pub-7768123198632313~1473488290';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static String get testBannerId {
    if(Platform.isAndroid) {
      return 'ca-app-pub-7768123198632313/9750282186';
    } else if(Platform.isIOS) {
      return 'ca-app-pub-7768123198632313/4527677410';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static BannerAd buildTestAd() {
    return BannerAd(
      adUnitId: testBannerId,
      size: AdSize.banner,
      targetingInfo: targetInfo,
    );
  }

}