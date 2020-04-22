/// Flutter SDK Do not control the default value,
/// controlled by "Android SDK" or "IOS SDK" itself
class AnalysysConfig {
  /// 项目标识 
  String appKey;
  ///  渠道 
  String channel;
  /// 默认不加密，1：AES ECB加密 2： AES CBC加密
  int encryptType;
  
  /// 是否追踪新用户的首次属性，默认值：true 
  bool autoProfile;
  /// 是否允许渠道追踪，默认值：false 
  bool autoInstallation;
  /// 是否上报deviceId
  bool autoTrackDeviceId;
  
  /// 是否允许时间校准, 默认值：false
  bool allowTimeCheck;
  /// 最大允许时间误差,单位：秒
  int maxDiffTimeInterval;
  
  // 将配置信息转换为map
  Map toMap() {
    Map map = {
      "appKey": appKey, 
      "channel": channel, 
      "encryptType": encryptType,
      "autoProfile": autoProfile, 
      "autoInstallation": autoInstallation, 
      "autoTrackDeviceId": autoTrackDeviceId, 
      "allowTimeCheck": allowTimeCheck,
      "maxDiffTimeInterval": maxDiffTimeInterval
    };
    return map;
  }
}
