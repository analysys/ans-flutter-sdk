import 'dart:async';

import 'package:argo_flutter_plugin/AnalysysConfig.dart';
import 'package:flutter/services.dart';

class AnalysysAgent {
  static const MethodChannel _channel =
      const MethodChannel('argo_flutter_plugin');

  static Future<void> init(AnalysysConfig config) {
    try {
      return _channel.invokeMethod('init', config.toMap());
    } catch (e) {
      print("init error with exception:" + e.toString());
    }
    return null;
  }

  static Future<void> setDebugMode(int mode) {
    try {
      return _channel.invokeMethod('set_debug_mode', mode);
    } catch (e) {
      print("setDebugMode error with exception:" + e.toString());
    }
    return null;
  }

  ///   不允许上传 0
  ///   允许移动网络上传 1 << 1
  ///   允许wifi网络  1 << 2
  ///   允许所有网络 0xFF;
  static Future<void> setUploadNetworkType(int type) {
    try {
      return _channel.invokeMethod('setUploadNetworkType', type);
    } catch (e) {
      print("setUploadNetworkType error with exception:" + e.toString());
    }
    return null;
  }

  static Future<void> reportException(String exception) {
    try {
      return _channel.invokeMethod('reportException', exception);
    } catch (e) {
      print("reportException error with exception:" + e.toString());
    }
    return null;
  }

  static Future<void> cleanDBCache() {
    try {
      return _channel.invokeMethod('cleanDBCache');
    } catch (e) {
      print("cleanDBCache error with exception:" + e.toString());
    }
    return null;
  }

  static Future<Map<String, Object>> getPresetProperties() async {
    return await _channel.invokeMethod('getPresetProperties');
  }

  static Future<void> setUploadUrl(String url) {
    try {
      return _channel.invokeMethod('set_upload_url', url);
    } catch (e) {
      print("setUploadUrl error with exception:" + e.toString());
    }
    return null;
  }

  static Future<void> setIntervalTime(int interval) {
    try {
      return _channel.invokeMethod('set_interval_time', interval);
    } catch (e) {
      print("setIntervalTime error with exception:" + e.toString());
    }
    return null;
  }

  static Future<void> setMaxCacheSize(int mode) {
    try {
      return _channel.invokeMethod('set_max_cache_size', mode);
    } catch (e) {
      print("setMaxCacheSize error with exception:" + e.toString());
    }
    return null;
  }

  static Future<int> getMaxCacheSize() async {
    return await _channel.invokeMethod('get_max_cache_size');
  }

  static Future<void> setMaxEventSize(int mode) {
    try {
      return _channel.invokeMethod('set_max_event_size', mode);
    } catch (e) {
      print("setMaxEventSize error with exception:" + e.toString());
    }
    return null;
  }

  static Future<void> flush() {
    try {
      return _channel.invokeMethod('flush');
    } catch (e) {
      print("flush error with exception:" + e.toString());
    }
    return null;
  }

  static Future<void> alias(String aliasId, String originalId) {
    try {
      Map<String, dynamic> params = {};
      if (aliasId != null && aliasId.length > 0) {
        params["alias_id"] = aliasId;
      }
      if (originalId != null && originalId.length > 0) {
        params["original_id"] = originalId;
      }
      return _channel.invokeMethod('alias', params);
    } catch (e) {
      print("alias error with exception:" + e.toString());
    }
    return null;
  }

  static Future<void> identify(String distinctId) {
    try {
      return _channel.invokeMethod('identify', distinctId);
    } catch (e) {
      print("identify error with exception:" + e.toString());
    }
    return null;
  }

  static Future<String> getDistinctId() async {
    return await _channel.invokeMethod('get_distinct_id');
  }

  static Future<void> reset() {
    try {
      return _channel.invokeMethod('reset');
    } catch (e) {
      print("reset error with exception:" + e.toString());
    }
    return null;
  }

  static Future<void> track(String eventName, {Map<String, Object> eventInfo}) {
    try {
      if (eventName == null) {
        print("track eventName can not be null:");
        return null;
      }
      Map<String, Object> params = {};
      params['event_name'] = eventName;
      if (eventInfo != null) {
        params['event_info'] = eventInfo;
      }
      return _channel.invokeMethod('track', params);
    } catch (e) {
      print("track error with exception:" + e.toString());
    }
    return null;
  }

  static Future<void> pageView(String pageName,
      {Map<String, Object> pageInfo}) {
    try {
      if (pageName == null) {
        print("pageView pageName can not be null!");
        return null;
      }
      Map<String, Object> params = {};
      params['page_name'] = pageName;
      if (pageInfo != null) {
        params['page_detail'] = pageInfo;
      }
      return _channel.invokeMethod('pageview', params);
    } catch (e) {
      print("pageView error with exception:" + e.toString());
    }
    return null;
  }

  /// 应用启动来源，
  /// 参数为 1. icon启动 默认值为icon启动
  /// 参数为 2. msg 启动
  /// 参数为 3. deepLink启动
  /// 参数为 5. 其他方式启动
  static Future<void> launchSource(int source) {
    try {
      return _channel.invokeMethod('launchSource', source);
    } catch (e) {
      print("pageView error with exception:" + e.toString());
    }
    return null;
  }

  static Future<void> registerSuperProperty(
      String superPropertyName, Object superPropertyValue) {
    try {
      if (superPropertyName == null || superPropertyValue == null) {
        print("registerSuperProperty param can not be null!");
        return null;
      }
      Map<String, Object> params = {};
      params['property_name'] = superPropertyName;
      params['property_value'] = superPropertyValue;
      return _channel.invokeMethod('register_super_property', params);
    } catch (e) {
      print("registerSuperProperty error with exception:" + e.toString());
    }
    return null;
  }

  static Future<void> registerSuperProperties(
      Map<String, Object> superProperty) {
    try {
      if (superProperty == null) {
        print("registerSuperProperties param can not be null!");
        return null;
      }
      Map<String, Object> params = {};
      params['properties'] = superProperty;
      return _channel.invokeMethod('register_super_properties', params);
    } catch (e) {
      print("registerSuperProperties error with exception:" + e.toString());
    }
    return null;
  }

  static Future<void> unRegisterSuperProperty(String superPropertyName) {
    try {
      if (superPropertyName == null) {
        print("unRegisterSuperProperty param can not be null!");
        return null;
      }
      return _channel.invokeMethod(
          'unregister_super_property', superPropertyName);
    } catch (e) {
      print("unRegisterSuperProperty error with exception:" + e.toString());
    }
    return null;
  }

  static Future<void> clearSuperProperties() {
    try {
      return _channel.invokeMethod('clear_super_properties');
    } catch (e) {
      print("clearSuperProperties error with exception:" + e.toString());
    }
    return null;
  }

  static Future<Object> getSuperProperty(String key) async {
    return await _channel.invokeMethod('get_super_property', key);
  }

  static Future<Object> getSuperProperties() async {
    return await _channel.invokeMethod('get_super_properties');
  }

  static Future<void> profileSet(Map<String, Object> property) {
    try {
      if (property == null) {
        print("profileSet param can not be null!");
        return null;
      }
      Map<String, Object> params = {};
      params['properties'] = property;
      return _channel.invokeMethod('profile_set', params);
    } catch (e) {
      print("profileSet error with exception:" + e.toString());
    }
    return null;
  }

  static Future<void> profileSetOnce(Map<String, Object> property) {
    try {
      if (property == null) {
        print("profileSetOnce param can not be null!");
        return null;
      }
      Map<String, Object> params = {};
      params['properties'] = property;
      return _channel.invokeMethod('profile_set_once', params);
    } catch (e) {
      print("profileSetOnce error with exception:" + e.toString());
    }
    return null;
  }

  static Future<void> profileIncrement(Map<String, dynamic> property) {
    try {
      if (property == null) {
        print("profileIncrement param can not be null!");
        return null;
      }
      Map<String, Object> params = {};
      params['properties'] = property;
      return _channel.invokeMethod('profile_increment', params);
    } catch (e) {
      print("profileIncrement error with exception:" + e.toString());
    }
    return null;
  }

  static Future<void> profileAppend(Map<String, Object> property) {
    try {
      if (property == null) {
        print("profileAppend param can not be null!");
        return null;
      }
      Map<String, Object> params = {};
      params['properties'] = property;
      return _channel.invokeMethod('profile_append', params);
    } catch (e) {
      print("profileAppend error with exception:" + e.toString());
    }
    return null;
  }

  static Future<void> profileUnset(String propertyName) {
    try {
      if (propertyName == null) {
        print("profileUnset param can not be null!");
        return null;
      }
      return _channel.invokeMethod('profile_unset', propertyName);
    } catch (e) {
      print("profileUnset error with exception:" + e.toString());
    }
    return null;
  }

  static Future<void> profileDelete() {
    try {
      return _channel.invokeMethod('profile_delete');
    } catch (e) {
      print("profileDelete error with exception:" + e.toString());
    }
    return null;
  }

  static Future<void> trackCampaign(String campaign, bool isClick) {
    try {
      if (campaign == null || isClick == null) {
        print("trackCampaign param can not be null!");
        return null;
      }
      Map<String, Object> params = {};
      params['campaign'] = campaign;
      params['is_click'] = isClick;
      print("track_campaign" + params.toString());
      return _channel.invokeMethod('track_campaign', params);
    } catch (e) {
      print("trackCampaign error with exception:" + e.toString());
    }
    return null;
  }
}
