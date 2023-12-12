package com.analysys.argo.argo_flutter_plugin;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import com.analysys.AnalysysAgent;
import com.analysys.AnalysysConfig;
import com.analysys.EncryptEnum;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * ArgoFlutterPlugin
 */
public class ArgoFlutterPlugin implements FlutterPlugin, MethodCallHandler,ActivityAware{

    private Activity mActivity;
    private static final String TAG = "argo.analysys";
    private static final boolean DEBUG = true;
    private MethodChannel channel;
    private Context context;

    /**
     * Plugin registration.
     */

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        //执行结束的返回值，供给flutter方处理，如果void 则为空
        Object callbackObject = null;
        try {

            if (context == null) {
                Log.e(TAG, "context error!!!");
                return;
            }
            if (DEBUG) {
                printAges(call);
            }

            switch (call.method) {
                case "init":
                    //dart 中已经删除这个接口，由两边代码分别初始化
                    this.init(context, call.arguments);
                    break;
                case "set_debug_mode":
                    this.setDebugMode(context, call.arguments);
                    break;
                case "set_upload_url":
                    this.setUploadURL(context, call.arguments);
                    break;
                case "set_interval_time":
                    this.setIntervalTime(context, call.arguments);
                    break;
                case "set_max_cache_size":
                    this.setMaxCacheSize(context, call.arguments);
                    break;
                case "reportException":
                    this.reportException(context, call.arguments);
                    break;
                case "cleanDBCache":
                    this.cleanDBCache(context, call.arguments);
                    break;
                case "setUploadNetworkType":
                    this.setUploadNetworkType(context, call.arguments);
                    break;
                case "get_max_cache_size":
                    callbackObject = this.getMaxCacheSize(context);
                    break;
                case "set_max_event_size":
                    this.setMaxEventSize(context, call.arguments);
                    break;
                case "getPresetProperties":
                    callbackObject = this.getPresetProperties(context, call.arguments);
                    break;
                case "flush":
                    this.flush(context);
                    break;
                case "alias":
                    this.alias(context, call.arguments);
                    break;
                case "identify":
                    this.identify(context, call.arguments);
                    break;
                case "get_distinct_id":
                    callbackObject = this.getDistinctId(context);
                    break;
                case "reset":
                    this.reset(context);
                    break;
                case "track":
                    this.track(context, call.arguments);
                    break;
                case "pageview":
                    this.pageView(context, call.arguments);
                    break;
                case "launchSource":
                    this.launchSource(context, call.arguments);
                    break;
                case "setAutomaticCollection":
                    this.setAutomaticCollection(context, call.arguments);
                    break;
                case "register_super_property":
                    this.registerSuperProperty(context, call.arguments);
                    break;
                case "register_super_properties":
                    this.registerSuperProperties(context, call.arguments);
                    break;
                case "unregister_super_property":
                    this.unRegisterSuperProperty(context, call.arguments);
                    break;
                case "clear_super_properties":
                    this.clearSuperProperties(context);
                    break;
                case "get_super_property":
                    callbackObject = this.getSuperProperty(context, call.arguments);
                    break;
                case "get_super_properties":
                    callbackObject = this.getSuperProperties(context);
                    break;
                case "profile_set":
                    this.profileSet(context, call.arguments);
                    break;
                case "profile_set_once":
                    this.profileSetOnce(context, call.arguments);
                    break;
                case "profile_increment":
                    this.profileIncrement(context, call.arguments);
                    break;
                case "profile_append":
                    this.profileAppend(context, call.arguments);
                    break;
                case "profile_unset":
                    this.profileUnset(context, call.arguments);
                    break;
                case "profile_delete":
                    this.profileDelete(context);
                    break;
                case "track_campaign":
                    this.trackCampaign(context, call.arguments);
                    break;
                default:
                    //未找到实现
                    result.notImplemented();
                    break;
            }
        } catch (Exception e) {
            result.error("100", e.getMessage(), e.toString());
            e.printStackTrace();
        }
        result.success(callbackObject);
    }


    private void setAutomaticCollection(Context context, Object arguments) {
        AnalysysAgent.setAutomaticCollection(context, (Boolean) arguments);
    }

    private void setUploadNetworkType(Context context, Object arguments) {
        AnalysysAgent.setUploadNetworkType((Integer) arguments);
    }

    private void reportException(Context context, Object arguments) {
        AnalysysAgent.reportException(context, new Exception("flutter:" + arguments));
    }

    private void cleanDBCache(Context context, Object arguments) {
        AnalysysAgent.cleanDBCache();
    }

    private void printAges(MethodCall call) {
        String methodName = call.method;
        if (call.arguments == null) {
            Log.e(TAG, " \n[methodName]" + methodName + "\n");
            return;
        }
        String ageType = call.arguments.getClass().getName();
        String ageValue = null;
        if (call.arguments instanceof Map) {
            JSONObject jsonObject = new JSONObject((Map) call.arguments);
            try {
                ageValue = jsonObject.toString(2);
            } catch (JSONException e) {
                e.printStackTrace();
            }
        } else {
            ageValue = String.valueOf(call.arguments);
        }
        Log.e(TAG, " \n[methodName]" + methodName + "\n" +
                "[ageType]" + ageType + "\n" +
                "[ageValue]" + ageValue + "\n");
    }

    private void launchSource(Context context, Object params) {
        int source = (int) params;
        AnalysysAgent.launchSource(source);
    }

    /**
     * 此接口已经启弃用，由两边接口自己定义初始化相关代码
     */
    @Deprecated
    private void init(Context context, Object params) {
        if (!isValidateMap(params)) {
            Log.e(TAG, "init arguments error!!!");
            return;
        }
        Map mapParams = (Map) params;
        AnalysysConfig config = null;
        if (mapParams.size() != 0) {
            config = new AnalysysConfig();
            if (isStringType(mapParams.get("channel"))) {
                config.setChannel((String) mapParams.get("channel"));
            }
            if (isStringType(mapParams.get("base_url"))) {
                config.setBaseUrl((String) mapParams.get("base_url"));
            }
            if (isStringType(mapParams.get("app_key"))) {
                config.setAppKey((String) mapParams.get("app_key"));
            }
            if (isBooleanType(mapParams.get("auto_profile"))) {
                config.setAutoProfile((boolean) mapParams.get("auto_profile"));
            }
            if (isIntegerType(mapParams.get("encryptType"))) {
                int encryptType = (int) mapParams.get("encryptType");
                for (EncryptEnum anEnum : EncryptEnum.values()) {
                    if (anEnum.getType() == encryptType) {
                        config.setEncryptType(anEnum);
                        break;
                    }
                }
            }
            if (isBooleanType(mapParams.get("auto_heatMap"))) {
                config.setAutoHeatMap((boolean) mapParams.get("auto_heatMap"));
            }
            if (isBooleanType(mapParams.get("autoInstallation"))) {
                config.setAutoInstallation((boolean) mapParams.get("autoInstallation"));
            }
        }
        AnalysysAgent.init(context, config);
    }

    private void setDebugMode(Context context, Object params) {
        Log.d(TAG, "setDebugMode method call from java");
        if (isIntegerType(params)) {
            AnalysysAgent.setDebugMode(context, (Integer) params);
        }
    }


    private void setUploadURL(Context context, Object params) {
        Log.d(TAG, "setUploadURL method call from java");
        if (isStringType(params)) {
            AnalysysAgent.setUploadURL(context, (String) params);
        }
    }

    private void setIntervalTime(Context context, Object params) {
        Log.d(TAG, "setIntervalTime method call from java");
        if (isIntegerType(params)) {
            AnalysysAgent.setIntervalTime(context, (Integer) params);
        }
    }

    private void setMaxCacheSize(Context context, Object params) {
        Log.d(TAG, "setMaxCacheSize method call from java");
        if (isIntegerType(params)) {
            AnalysysAgent.setMaxCacheSize(context, (Integer) params);
        }
    }

    private long getMaxCacheSize(Context context) {
        Log.d(TAG, "getMaxCacheSize method call from java");
        return AnalysysAgent.getMaxCacheSize(context);
    }

    private void setMaxEventSize(Context context, Object params) {
        Log.d(TAG, "setMaxEventSize method call from java");
        if (isIntegerType(params)) {
            AnalysysAgent.setMaxEventSize(context, (Integer) params);
        }
    }

    private Map<String, Object> getPresetProperties(Context context, Object params) {
        return AnalysysAgent.getPresetProperties(context);
    }

    private void flush(Context context) {
        Log.d(TAG, "flush method call from java");
        AnalysysAgent.flush(context);
    }

    private void alias(Context context, Object params) {/* String aliasId, String originalId */
        Log.d(TAG, "alias method call from java");
        if (isStringType(params)) {
            String alias_id = (String) params;
            AnalysysAgent.alias(context, alias_id);
            return;
        }
        if (isValidateMap(params)) {
            Map mapParams = (Map) params;
            if (isStringType(mapParams.get("alias_id")) && isStringType(mapParams.get("original_id"))) {
                AnalysysAgent.alias(context, (String) mapParams.get("alias_id"), (String) mapParams.get("original_id"));
            }
            return;
        }else {
            Log.e(TAG, "arguments error!!!");
        }


    }

    private void identify(Context context, Object params) {
        Log.d(TAG, "identify method call from java");
        if (isStringType(params)) {
            AnalysysAgent.identify(context, (String) params);
        }
    }

    private String getDistinctId(Context context) {
        Log.d(TAG, "getDistinctId method call from java");
        return AnalysysAgent.getDistinctId(context);
    }

    private void reset(Context context) {
        Log.d(TAG, "reset method call from java");
        AnalysysAgent.reset(context);
    }

    @SuppressWarnings("unchecked")
    private void track(Context context, Object params) {
        Log.d(TAG, "track method call from java");
        if (!isValidateMap(params)) {
            Log.e(TAG, "arguments error!!!");
            return;
        }
        Map mapParams = (Map) params;
        Object eventName = mapParams.get("event_name");
        Object eventInfo = mapParams.get("event_info");
        if (isStringType(eventName)) {
            AnalysysAgent.track(context, (String) eventName, isValidateMap(eventInfo) ? (Map<String, Object>) eventInfo : null);
        }
    }

    @SuppressWarnings("unchecked")
    private void pageView(Context context, Object params) {
        Log.d(TAG, "pageView method call from java");
        if (!isValidateMap(params)) {
            Log.e(TAG, "arguments error!!!");
            return;
        }
        Map mapParams = (Map) params;
        Object pageName = mapParams.get("page_name");
        Object pageDetail = mapParams.get("page_detail");
        if (isStringType(pageName)) {
            AnalysysAgent.pageView(context, (String) pageName, isValidateMap(pageDetail) ? (Map<String, Object>) pageDetail : null);
        }
    }


    private void registerSuperProperty(Context context, Object params) {
        Log.d(TAG, "registerSuperProperty method call from java");
        if (!isValidateMap(params)) {
            Log.e(TAG, "arguments error!!!");
            return;
        }
        Map mapParams = (Map) params;
        Object tempName = mapParams.get("property_name");
        Object tempValue = mapParams.get("property_value");
        if (isStringType(tempName) && tempValue != null) {
            AnalysysAgent.registerSuperProperty(context, (String) tempName, tempValue);
        }
    }

    @SuppressWarnings("unchecked")
    private void registerSuperProperties(Context context, Object params) {
        Log.d(TAG, "registerSuperProperties method call from java");
        if (!isValidateMap(params)) {
            Log.e(TAG, "arguments error!!!");
            return;
        }
        Map mapParams = (Map) params;
        Object tempProperties = mapParams.get("properties");
        if (isValidateMap(tempProperties)) {
            AnalysysAgent.registerSuperProperties(context, (Map<String, Object>) tempProperties);
        }
    }

    private void unRegisterSuperProperty(Context context, Object params) {
        Log.d(TAG, "unRegisterSuperProperty method call from java");
        if (isStringType(params)) {
            AnalysysAgent.unRegisterSuperProperty(context, (String) params);
        }
    }

    private void clearSuperProperties(Context context) {
        Log.d(TAG, "clearSuperProperties method call from java");
        AnalysysAgent.clearSuperProperties(context);
    }

    private Object getSuperProperty(Context context, Object params) {
        Log.d(TAG, "getSuperProperty method call from java");
        if (isStringType(params)) {
            return AnalysysAgent.getSuperProperty(context, (String) params);
        }
        return null;
    }

    private Map<String, Object> getSuperProperties(Context context) {
        Log.d(TAG, "getSuperProperties method call from java");
        return AnalysysAgent.getSuperProperties(context);
    }

    @SuppressWarnings("unchecked")
    private void profileSet(Context context, Object params) {
        Log.d(TAG, "profileSet method call from java");
        if (!isValidateMap(params)) {
            Log.e(TAG, "arguments error!!!");
            return;
        }
        Map mapParams = (Map) params;
        Object tempName = mapParams.get("profile_name");
        Object tempValue = mapParams.get("profile_value");
        Object tempProperties = mapParams.get("properties");
        if (isStringType(tempName) && isStringType(tempValue)) {
            AnalysysAgent.profileSet(context, (String) tempName, tempValue);
        } else if (isValidateMap(tempProperties)) {
            AnalysysAgent.profileSet(context, (Map<String, Object>) tempProperties);
        }
    }

    @SuppressWarnings("unchecked")
    private void profileSetOnce(Context context, Object params) {
        Log.d(TAG, "profileSetOnce method call from java");
        if (!isValidateMap(params)) {
            Log.e(TAG, "arguments error!!!");
            return;
        }
        Map mapParams = (Map) params;
        Object tempName = mapParams.get("profile_name");
        Object tempValue = mapParams.get("profile_value");
        Object tempProperties = mapParams.get("properties");
        if (isStringType(tempName) && isStringType(tempValue)) {
            AnalysysAgent.profileSetOnce(context, (String) tempName, tempValue);
        } else if (isValidateMap(tempProperties)) {
            AnalysysAgent.profileSetOnce(context, (Map<String, Object>) tempProperties);
        }
    }

    @SuppressWarnings("unchecked")
    private void profileIncrement(Context context, Object params) {
        Log.d(TAG, "profileIncrement method call from java");
        if (!isValidateMap(params)) {
            Log.e(TAG, "arguments error!!!");
            return;
        }
        Map mapParams = (Map) params;
        Object tempName = mapParams.get("profile_name");
        Object tempValue = mapParams.get("profile_value");
        Object tempProperties = mapParams.get("properties");
        if (isStringType(tempName) && isNumberType(tempValue)) {
            AnalysysAgent.profileIncrement(context, (String) tempName, (Number) tempValue);
        } else if (isValidateIncreMap(tempProperties)) {
            AnalysysAgent.profileIncrement(context, (Map<String, Number>) tempProperties);
        }
    }

    @SuppressWarnings("unchecked")
    private void profileAppend(Context context, Object params) {
        Log.d(TAG, "profileAppend method call from java");
        if (!isValidateMap(params)) {
            Log.e(TAG, "arguments error!!!");
            return;
        }
        Map mapParams = (Map) params;
        Object tempName = mapParams.get("profile_name");
        Object tempValue = mapParams.get("profile_value");
        //Map<String,Object>
        Object tempProperties = mapParams.get("properties");
        //List<Object>
        Object tempPropertiesList = mapParams.get("properties_list");
        if (isStringType(tempName) && isStringType(tempValue)) {
            AnalysysAgent.profileAppend(context, (String) tempName, tempValue);
        } else if (isValidateMap(tempProperties)) {
            AnalysysAgent.profileAppend(context, (Map<String, Object>) tempProperties);
        } else if (isStringType(tempName) && isListType(tempPropertiesList)) {
            AnalysysAgent.profileAppend(context, (String) tempName, (List<Object>) tempPropertiesList);
        }
    }

    private void profileUnset(Context context, Object params) {
        Log.d(TAG, "profileUnset method call from java");
        if (isStringType(params)) {
            AnalysysAgent.profileUnset(context, (String) params);
        }
    }

    private void profileDelete(Context context) {
        Log.d(TAG, "profileDelete method call from java");
        AnalysysAgent.profileDelete(context);
    }

    private void trackCampaign(Context context, Object params) {
        Log.d(TAG, "trackCampaign method call from java");
        Log.e(TAG, "trackCampaign:" + params);
        Map mapParams = (Map) params;
        if (isStringType(mapParams.get("campaign")) && isBooleanType(mapParams.get("is_click"))) {
            AnalysysAgent.trackCampaign(context, (String) mapParams.get("campaign"), (boolean) mapParams.get("is_click"));
        }
    }


    private boolean isValidateIncreMap(Object param) {
        if (!(param instanceof Map)) {
            return false;
        }
        Map map = (Map) param;
        for (Object key : map.keySet()) {
            if (!(key instanceof String)) {
                return false;
            }
            Object value = map.get(key);
            if (!(value instanceof Number)) {
                return false;
            }
        }
        return true;
    }

    private boolean isValidateMap(Object param) {
        if (!(param instanceof Map)) {
            Log.e(TAG, "param error :" + param);
            return false;
        }
        Map map = (Map) param;
        for (Object key : map.keySet()) {
            if (!(key instanceof String)) {
                return false;
            }
        }
        return true;
    }

    private boolean isStringType(Object param) {
        if (param == null) {
            return false;
        }
        return param instanceof String;
    }

    private boolean isBooleanType(Object param) {
        if (param == null) {
            return false;
        }
        return param instanceof Boolean;
    }

    private boolean isIntegerType(Object param) {
        if (param == null) {
            return false;
        }
        return param instanceof Integer;
    }

    private boolean isNumberType(Object param) {
        if (param == null) {
            return false;
        }
        return param instanceof Number;
    }

    private boolean isListType(Object param) {
        if (param == null) {
            return false;
        }
        return param instanceof List;
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        channel = new MethodChannel(binding.getBinaryMessenger(), "argo_flutter_plugin");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }


    @Override
    public void onAttachedToActivity(ActivityPluginBinding activityPluginBinding) {
        mActivity = activityPluginBinding.getActivity();
        context = mActivity;
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        mActivity = binding.getActivity();
        context = mActivity;
    }

    @Override
    public void onDetachedFromActivity() {
        mActivity = null;
        context = null;
    }


}
