
import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:wishtogether/constants.dart';

class AdService {

  static MobileAdTargetingInfo targetInfo = MobileAdTargetingInfo(
    testDevices: ['AB8BD444BDAEA0427676D9074F5C6B8B'],
    childDirected: true,
  );

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
      listener: (event) {
        debug(event);
        debug(event.index);
      },
      adUnitId: testBannerId,
      size: AdSize.fullBanner,
      targetingInfo: targetInfo,
    );
  }

}