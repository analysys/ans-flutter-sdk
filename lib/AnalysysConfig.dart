/// Flutter SDK Do not control the default value,
/// controlled by "Android SDK" or "IOS SDK" itself
class AnalysysConfig {
  String channel;
  String baseUrl;
  String appKey;
  bool autoInstallation;
  bool calibration;
  bool autoHeatMap;
  bool autoTrackPageView;
  bool autoTrackFragmentPageView;
  bool autoTrackClick;
  bool autoTrackDeviceId;
  int diffTime;
  int encryptType;
  bool autoProfile;

  Map toMap() {
    Map map = {
      "channel": channel,
      "baseUrl": baseUrl,
      "appKey": appKey,
      "autoInstallation": autoInstallation,
      "calibration": calibration,
      "autoHeatMap": autoHeatMap,
      "autoTrackPageView": autoTrackPageView,
      "autoTrackFragmentPageView": autoTrackFragmentPageView,
      "autoTrackClick": autoTrackClick,
      "autoTrackDeviceId": autoTrackDeviceId,
      "diffTime": diffTime,
      "encryptType": encryptType,
      "autoProfile": autoProfile
    };
    return map;
  }
}
