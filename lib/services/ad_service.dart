
import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';

class AdService {

  static String get appId {
    if(Platform.isAndroid) {
      return 'ca-app-pub-7768123198632313~8206192262';
    } else if(Platform.isIOS) {
      return 'no_id';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static String get testBannerId {
    if(Platform.isAndroid) {
      return 'ca-app-pub-7768123198632313/9750282186';
    } else if(Platform.isIOS) {
      return 'no_id';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static BannerAd buildTestAd() {
    return BannerAd(
        adUnitId: testBannerId,
        size: AdSize.fullBanner,

    );
  }

}