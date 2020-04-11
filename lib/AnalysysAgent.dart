import 'dart:async';

import 'package:argo_flutter_plugin/AnalysysConfig.dart';
import 'package:flutter/services.dart';

class AnalysysAgent {
  static const MethodChannel _channel =
      const MethodChannel('argo_flutter_plugin');

  static void init(AnalysysConfig config) {
    try {
      _channel.invokeMethod('init', config.toMap());
    } catch (e) {
      print("init error with exception:" + e.toString());
    }
  }

  static void setDebugMode(int mode) {
    try {
      _channel.invokeMethod('set_debug_mode', mode);
    } catch (e) {
      print("setDebugMode error with exception:" + e.toString());
    }
  }

  ///   不允许上传 0
  ///   允许移动网络上传 1 << 1
  ///   允许wifi网络  1 << 2
  ///   允许所有网络 0xFF;
  static void setUploadNetworkType(int type) {
    try {
      _channel.invokeMethod('setUploadNetworkType', type);
    } catch (e) {
      print("setUploadNetworkType error with exception:" + e.toString());
    }
  }

  static void reportException(String exception) {
    try {
      _channel.invokeMethod('reportException', exception);
    } catch (e) {
      print("reportException error with exception:" + e.toString());
    }
  }

  static void cleanDBCache() {
    try {
      _channel.invokeMethod('cleanDBCache');
    } catch (e) {
      print("cleanDBCache error with exception:" + e.toString());
    }
  }

  static Map<String, Object> getPresetProperties() {
    try {
      _channel.invokeMethod('getPresetProperties');
    } catch (e) {
      print("setDebugMode error with exception:" + e.toString());
    }
  }

  static void setUploadUrl(String url) {
    try {
      _channel.invokeMethod('set_upload_url', url);
    } catch (e) {
      print("setUploadUrl error with exception:" + e.toString());
    }
  }

  static void setIntervalTime(int interval) {
    try {
      _channel.invokeMethod('set_interval_time', interval);
    } catch (e) {
      print("setIntervalTime error with exception:" + e.toString());
    }
  }

  static void setMaxCacheSize(int mode) {
    try {
      _channel.invokeMethod('set_max_cache_size', mode);
    } catch (e) {
      print("setMaxCacheSize error with exception:" + e.toString());
    }
  }

  static Future<int> getMaxCacheSize() async {
    return await _channel.invokeMethod('get_max_cache_size');
  }

  static void setMaxEventSize(int mode) {
    try {
      _channel.invokeMethod('set_max_event_size', mode);
    } catch (e) {
      print("setMaxEventSize error with exception:" + e.toString());
    }
  }

  static void flush() {
    try {
      _channel.invokeMethod('flush');
    } catch (e) {
      print("flush error with exception:" + e.toString());
    }
  }

  static void alias(String aliasId, String originalId) {
    try {
      Map<String, dynamic> params = {};
      if (aliasId != null && aliasId.length > 0) {
        params["alias_id"] = aliasId;
      }
      if (originalId != null && originalId.length > 0) {
        params["original_id"] = originalId;
      }
      _channel.invokeMethod('alias', params);
    } catch (e) {
      print("alias error with exception:" + e.toString());
    }
  }

  static void identify(String distinctId) {
    try {
      _channel.invokeMethod('identify', distinctId);
    } catch (e) {
      print("identify error with exception:" + e.toString());
    }
  }

  static Future<String> getDistinctId() async {
    return await _channel.invokeMethod('get_distinct_id');
  }

  static void reset() {
    try {
      _channel.invokeMethod('reset');
    } catch (e) {
      print("reset error with exception:" + e.toString());
    }
  }

  static void track(String eventName, {Map<String, Object> eventInfo}) {
    try {
      if (eventName == null) {
        print("track eventName can not be null:");
        return;
      }
      Map<String, Object> params = {};
      params['event_name'] = eventName;
      if (eventInfo != null) {
        params['event_info'] = eventInfo;
      }
      _channel.invokeMethod('track', params);
    } catch (e) {
      print("track error with exception:" + e.toString());
    }
  }

  static void pageView(String pageName, {Map<String, Object> pageInfo}) {
    try {
      if (pageName == null) {
        print("pageView pageName can not be null!");
        return;
      }
      Map<String, Object> params = {};
      params['page_name'] = pageName;
      if (pageInfo != null) {
        params['page_detail'] = pageInfo;
      }
      _channel.invokeMethod('pageview', params);
    } catch (e) {
      print("pageView error with exception:" + e.toString());
    }
  }

  /// 应用启动来源，
  /// 参数为 1. icon启动 默认值为icon启动
  /// 参数为 2. msg 启动
  /// 参数为 3. deepLink启动
  /// 参数为 5. 其他方式启动
  static void launchSource(int source) {
    try {
      _channel.invokeMethod('launchSource', source);
    } catch (e) {
      print("pageView error with exception:" + e.toString());
    }
  }

  static void registerSuperProperty(
      String superPropertyName, Object superPropertyValue) {
    try {
      if (superPropertyName == null || superPropertyValue == null) {
        print("registerSuperProperty param can not be null!");
        return;
      }
      Map<String, Object> params = {};
      params['property_name'] = superPropertyName;
      params['property_value'] = superPropertyValue;
      _channel.invokeMethod('register_super_property', params);
    } catch (e) {
      print("registerSuperProperty error with exception:" + e.toString());
    }
  }

  static void registerSuperProperties(Map<String, Object> superProperty) {
    try {
      if (superProperty == null) {
        print("registerSuperProperties param can not be null!");
        return;
      }
      Map<String, Object> params = {};
      params['properties'] = superProperty;
      _channel.invokeMethod('register_super_properties', params);
    } catch (e) {
      print("registerSuperProperties error with exception:" + e.toString());
    }
  }

  static void unRegisterSuperProperty(String superPropertyName) {
    try {
      if (superPropertyName == null) {
        print("unRegisterSuperProperty param can not be null!");
        return;
      }
      _channel.invokeMethod('unregister_super_property', superPropertyName);
    } catch (e) {
      print("unRegisterSuperProperty error with exception:" + e.toString());
    }
  }

  static void clearSuperProperties() {
    try {
      _channel.invokeMethod('clear_super_properties');
    } catch (e) {
      print("clearSuperProperties error with exception:" + e.toString());
    }
  }

  static Future<Object> getSuperProperty(String key) async {
    return await _channel.invokeMethod('get_super_property', key);
  }

  static Future<Object> getSuperProperties() async {
    return await _channel.invokeMethod('get_super_properties');
  }

  static void profileSet(Map<String, Object> property) {
    try {
      if (property == null) {
        print("profileSet param can not be null!");
        return;
      }
      Map<String, Object> params = {};
      params['properties'] = property;
      _channel.invokeMethod('profile_set', params);
    } catch (e) {
      print("profileSet error with exception:" + e.toString());
    }
  }

  static void profileSetOnce(Map<String, Object> property) {
    try {
      if (property == null) {
        print("profileSetOnce param can not be null!");
        return;
      }
      Map<String, Object> params = {};
      params['properties'] = property;
      _channel.invokeMethod('profile_set_once', params);
    } catch (e) {
      print("profileSetOnce error with exception:" + e.toString());
    }
  }

  static void profileIncrement(Map<String, dynamic> property) {
    try {
      if (property == null) {
        print("profileIncrement param can not be null!");
        return;
      }
      Map<String, Object> params = {};
      params['properties'] = property;
      _channel.invokeMethod('profile_increment', params);
    } catch (e) {
      print("profileIncrement error with exception:" + e.toString());
    }
  }

  static void profileAppend(Map<String, Object> property) {
    try {
      if (property == null) {
        print("profileAppend param can not be null!");
        return;
      }
      Map<String, Object> params = {};
      params['properties'] = property;
      _channel.invokeMethod('profile_append', params);
    } catch (e) {
      print("profileAppend error with exception:" + e.toString());
    }
  }

  static void profileUnset(String propertyName) {
    try {
      if (propertyName == null) {
        print("profileUnset param can not be null!");
        return;
      }
      _channel.invokeMethod('profile_unset', propertyName);
    } catch (e) {
      print("profileUnset error with exception:" + e.toString());
    }
  }

  static void profileDelete() {
    try {
      _channel.invokeMethod('profile_delete');
    } catch (e) {
      print("profileDelete error with exception:" + e.toString());
    }
  }

  static void trackCampaign(String campaign, bool isClick) {
    try {
      if (campaign == null || isClick == null) {
        print("trackCampaign param can not be null!");
        return;
      }
      Map<String, Object> params = {};
      params['campaign'] = campaign;
      params['is_click'] = isClick;
      print("track_campaign" + params.toString());
      _channel.invokeMethod('track_campaign', params);
    } catch (e) {
      print("trackCampaign error with exception:" + e.toString());
    }
  }
}
