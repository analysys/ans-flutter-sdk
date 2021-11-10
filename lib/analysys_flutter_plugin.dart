import 'dart:async';


import 'package:flutter/services.dart';

class AnalysysAgent {
  static const MethodChannel _channel =
      const MethodChannel('argo_flutter_plugin');

  ///  设置上传间隔时间
  /// 
  /// [interval]说明：单位：秒，仅 setDebugMode = 0 时生效
  /// 
  /// ```dart
  /// AnalysysAgent.setIntervalTime(10);
  /// ```
  static Future<void> setIntervalTime(int interval) {
    try {
      return _channel.invokeMethod('set_interval_time', interval);
    } catch (e) {
      print("setIntervalTime error with exception:" + e.toString());
    }
    return null;
  }

  ///  本地缓存上限值
  /// 
  /// [mode]说明：最小值为100，默认10000条，超过此数据默认清理最早的10条数据
  ///
  /// ```dart
  /// AnalysysAgent.setMaxCacheSize(10000);
  /// ```
  static Future<void> setMaxCacheSize(int mode) {
    try {
      return _channel.invokeMethod('set_max_cache_size', mode);
    } catch (e) {
      print("setMaxCacheSize error with exception:" + e.toString());
    }
    return null;
  }

  ///  获取本地缓存最大值
  /// 
  /// ```dart
  /// AnalysysAgent.getMaxCacheSize();
  /// ```
  static Future<int> getMaxCacheSize() async {
    return await _channel.invokeMethod('get_max_cache_size');
  }

  ///   数据累积"size"条数后触发上传
  /// 
  /// [mode]说明：仅 setDebugMode = 0 时生效
  /// 
  /// ```dart
  /// AnalysysAgent.setMaxEventSize(10);
  /// ```
  static Future<void> setMaxEventSize(int mode) {
    try {
      return _channel.invokeMethod('set_max_event_size', mode);
    } catch (e) {
      print("setMaxEventSize error with exception:" + e.toString());
    }
    return null;
  }

  ///  主动触发数据上传
  /// 
  /// ```dart
  /// AnalysysAgent.flush();
  /// ```
  static Future<void> flush() {
    try {
      return _channel.invokeMethod('flush');
    } catch (e) {
      print("flush error with exception:" + e.toString());
    }
    return null;
  }

  /// 设置数据网络上传策略
  /// 
  /// [type]说明：
  /// 0：不允许上传 
  /// 2：允许移动网络上传
  /// 4：允许wifi网络
  /// 255：允许所有网络
  /// 
  /// ```dart
  /// AnalysysAgent.setUploadNetworkType(0xFF);
  /// ```
  static Future<void> setUploadNetworkType(int type) {
    try {
      return _channel.invokeMethod('setUploadNetworkType', type);
    } catch (e) {
      print("setUploadNetworkType error with exception:" + e.toString());
    }
    return null;
  }

  ///  清除本地所有已缓存数据
  /// 
  /// ```dart
  /// AnalysysAgent.cleanDBCache();
  /// ```
  static Future<void> cleanDBCache() {
    try {
      return _channel.invokeMethod('cleanDBCache');
    } catch (e) {
      print("cleanDBCache error with exception:" + e.toString());
    }
    return null;
  }

  /// 设置是否自动采集原生页面生命周期，默认为true
  /// 
  /// ```dart
  /// AnalysysAgent.setAutomaticCollection(true);
  /// ```
  static Future<void> setAutomaticCollection(bool autoCollection) {
    try {
      return _channel.invokeMethod('setAutomaticCollection', autoCollection);
    } catch (e) {
      print("cleanDBCache error with exception:" + e.toString());
    }
    return null;
  }

  //****************************** 事件相关 *********************************//

  ///  事件信息  eventInfo 可选
  /// 
  /// ```dart
  /// Map<String, Object> properties = {"eventKey": "eventValue"};
  /// AnalysysAgent.track("eventProperties", properties);
  /// ```
  static Future<void> track(String eventName, [Map<String, Object> eventInfo]) {
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

  ///  页面信息 pageInfo 可选
  /// 
  /// ```dart
  /// Map<String, Object> properties = {"pageKey": "pageValue"};
  /// AnalysysAgent.pageView("pageDetail", properties);
  /// ```
  static Future<void> pageView(String pageName, [Map<String, Object> pageInfo]) {
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

  ///  页面信息 pageInfo 可选
  ///
  /// ```dart
  /// Map<String, Object> properties = {"pageKey": "pageValue"};
  /// AnalysysAgent.pageView("pageDetail", properties);
  /// ```
  static Future<void> pageClose(String pageName, [Map<String, Object> pageInfo]) {
    try {
      if (pageName == null) {
        print("pageClose pageName can not be null!");
        return null;
      }
      Map<String, Object> params = {};
      params['\$title'] = pageName;
      if (pageInfo != null) {
        params.addAll(pageInfo);
      }
      return track("page_close", params);
    } catch (e) {
      print("pageClose error with exception:" + e.toString());
    }
    return null;
  }

  // static Future<void> reportException(String exception) {
  //   try {
  //     return _channel.invokeMethod('reportException', exception);
  //   } catch (e) {
  //     print("reportException error with exception:" + e.toString());
  //   }
  //   return null;
  // }


  //****************************** 用户相关 *********************************//
  ///  用户关联。小于255字符
  /// 
  /// ```dart
  /// AnalysysAgent.alias("18899668899");
  /// ```
  static Future<void> alias(String aliasId) {
    try {
      return _channel.invokeMethod('alias', aliasId);
    } catch (e) {
      print("alias error with exception:" + e.toString());
    }
    return null;
  }

  ///  匿名ID设置。小于255字符
  /// 
  /// ```dart
  /// AnalysysAgent.identify("游客");
  /// ```
  static Future<void> identify(String distinctId) {
    try {
      return _channel.invokeMethod('identify', distinctId);
    } catch (e) {
      print("identify error with exception:" + e.toString());
    }
    return null;
  }

  ///  获取匿名标识
  /// 
  /// ```dart
  /// var distinctID = AnalysysAgent.getDistinctId();
  /// ```
  static Future<String>getDistinctId() async {
    return await _channel.invokeMethod('get_distinct_id');
  }

  ///  清除本地设置（anonymousId、aliasID、superProperties）
  /// 
  /// ```dart
  /// AnalysysAgent.reset();
  /// ```
  static Future<void>reset() {
    try {
      return _channel.invokeMethod('reset');
    } catch (e) {
      print("reset error with exception:" + e.toString());
    }
    return null;
  }

  ///  设置用户属性
  /// 
  /// ```dart
  /// AnalysysAgent.profileSet({"hobby": "playfootball"});
  /// ```
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

  ///  设置用户单次生效属性
  /// 
  /// ```dart
  /// AnalysysAgent.profileSetOnce({"birthday": "1997-7-1"});
  /// ```
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

  ///  设置用户属性相对变化值  多个 value必须为数字
  /// 
  /// ```dart
  /// AnalysysAgent.profileIncrement({"points": 99});
  /// ```
  static Future<void> profileIncrement(Map<String, num> property) {
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

  /// 增加列表类型的属性 value必须为列表
  /// 
  /// ```dart
  /// AnalysysAgent.profileAppend({"books": ["红楼梦", "水浒传"]});
  /// ```
  static Future<void> profileAppend(Map<String, List> property) {
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

  ///  删除某个用户属性
  /// 
  /// ```dart
  /// AnalysysAgent.profileUnset("birthday");
  /// ```
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

  ///  删除当前用户的所有属性
  /// ```dart
  /// AnalysysAgent.profileDelete();
  /// ```
  static Future<void> profileDelete() {
    try {
      return _channel.invokeMethod('profile_delete');
    } catch (e) {
      print("profileDelete error with exception:" + e.toString());
    }
    return null;
  }

  //****************************** 通用属性 *********************************//

  ///  添加单个通用属性
  /// 
  /// ```dart
  /// AnalysysAgent.registerSuperProperty("gender", "male");
  /// ```
  static Future<void> registerSuperProperty(String superPropertyName, Object superPropertyValue) {
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

  ///  添加多个通用属性
  /// 
  /// ```dart
  /// AnalysysAgent.registerSuperProperties({"age":30, "address":"beijing"});
  /// ```
  static Future<void> registerSuperProperties(Map<String, Object> superProperty) {
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

  ///  删除某个通用属性
  /// 
  /// ```dart
  /// AnalysysAgent.unRegisterSuperProperty("age");
  /// ```
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

  ///  清除所有通用属性
  /// 
  /// ```dart
  /// AnalysysAgent.clearSuperProperties();
  /// ```
  static Future<void> clearSuperProperties() {
    try {
      return _channel.invokeMethod('clear_super_properties');
    } catch (e) {
      print("clearSuperProperties error with exception:" + e.toString());
    }
    return null;
  }

  ///  获取某个通用属性
  /// 
  /// ```dart
  /// var value = AnalysysAgent.getSuperProperty("address");
  /// ```
  static Future<Object> getSuperProperty(String key) async {
    return await _channel.invokeMethod('get_super_property', key);
  }

  ///  获取已注册通用属性
  /// 
  /// ```dart
  /// var superProperties = AnalysysAgent.getSuperProperties();
  /// ```
  static Future<Map<String, Object>> getSuperProperties() async {
    return await _channel.invokeMethod('get_super_properties');
  }

  ///  SDK预置属性
  /// 
  /// ```dart
  /// var presetProperties = AnalysysAgent.getPresetProperties();
  /// ```
  static Future<Map<dynamic, dynamic>> getPresetProperties() async {
    return await _channel.invokeMethod('getPresetProperties');
  }


  //****************************** 消息推送 *********************************//

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
}
