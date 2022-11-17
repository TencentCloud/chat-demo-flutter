// ignore_for_file: constant_identifier_names, slash_for_doc_comments

import 'package:tim_ui_kit_push_plugin/model/appInfo.dart';

class PushConfig{
  /// 华为离线推送参数start ******/
  // 在腾讯云控制台上传第三方推送证书后分配的证书ID
  static const HWPushBuzID = 24934;
  // ignore: todo
  // TODO: 角标参数，默认为应用的 launcher 界面的类名
  static const String BADGECLASSNAME = "com.tencent.qcloud.tim.demo.SplashActivity";
  /**华为离线推送参数end ******/

  /// 小米离线推送参数start ******/
  // 在腾讯云控制台上传第三方推送证书后分配的证书ID
  static const XMPushBuzID = 24933;
  // 小米开放平台分配的应用APPID及APPKEY
  static const String XMPushAPPID = "2882303761520155831";
  static const String XMPushAPPKEY = "5152015527831";
  /**小米离线推送参数end ******/

  /// 魅族离线推送参数start ******/
  // 在腾讯云控制台上传第三方推送证书后分配的证书ID
  static const MZPushBuzID = 24935;
  // 魅族开放平台分配的应用APPID及APPKEY
  static const String MZPushAPPID = "148322";
  static const String MZPushAPPKEY = "2c008055172b453ba3b1ea2ec5f3895d";
  /**魅族离线推送参数end ******/

  /// vivo离线推送参数start ******/
  // 在腾讯云控制台上传第三方推送证书后分配的证书ID
  static const VIVOPushBuzID = 24936;
  /**vivo离线推送参数end ******/

  /// google离线推送参数start ******/
  // 在腾讯云控制台上传第三方推送证书后分配的证书ID
  static const GOOGLEFCMPushBuzID = 24938;
  /**google离线推送参数end ******/

  /// oppo离线推送参数start ******/
  // 在腾讯云控制台上传第三方推送证书后分配的证书ID
  static const OPPOPushBuzID = 24937;
  // oppo开放平台分配的应用APPID及APPKEY
  static const String OPPOPushAPPKEY = "cc035ae17e4b4831bb3d58b2c934990e";
  static const String OPPOPushAPPSECRET = "8a363e802cdf4fc9bc2342608baf68c4";
  static const String OPPOPushAPPID = "30803767";
  static const String OPPOChannelID = "new_message";
  /**oppo离线推送参数end ******/

  /// Apple离线推送参数start ******/
  // 在腾讯云控制台上传第三方推送证书后分配的证书ID
  static const ApplePushBuzID = 34290;
  /**Apple离线推送参数end ******/

  static final PushAppInfo appInfo = PushAppInfo(
    hw_buz_id: PushConfig.HWPushBuzID,
    mi_app_id: PushConfig.XMPushAPPID,
    mi_app_key: PushConfig.XMPushAPPKEY,
    mi_buz_id: PushConfig.XMPushBuzID,
    mz_app_id: PushConfig.MZPushAPPID,
    mz_app_key: PushConfig.MZPushAPPKEY,
    mz_buz_id: PushConfig.MZPushBuzID,
    vivo_buz_id: PushConfig.VIVOPushBuzID,
    oppo_app_key: PushConfig.OPPOPushAPPKEY,
    oppo_app_secret: PushConfig.OPPOPushAPPSECRET,
    oppo_buz_id: PushConfig.OPPOPushBuzID,
    oppo_app_id: PushConfig.OPPOPushAPPID,
    google_buz_id: PushConfig.GOOGLEFCMPushBuzID,
    apple_buz_id: PushConfig.ApplePushBuzID
  );
}