#import "ArgoFlutterPlugin.h"
#import <AnalysysAgent/AnalysysAgent.h>
#import <objc/runtime.h>

static bool isStringType(id param) {
    if (param == nil || ![param isKindOfClass:NSString.class]) {
        return false;
    }
    NSString *tempString = (NSString *)param;
    if (tempString == nil || tempString.length == 0) {
        return false;
    }
    return true;
}

static bool isValidateMap(id param,Class cls) {
    if (param == nil || ![param isKindOfClass:NSDictionary.class]) {
        return false;
    }
    NSDictionary *tempDic = (NSDictionary *)param;
    if (tempDic == nil || tempDic.count == 0) {
        return false;
    }
    for (id key in tempDic.allKeys) {
        if (!isStringType(key)) {
            return false;
        }
        if (cls) {
            id value = tempDic[key];
            if (value == nil || ![value isKindOfClass:cls]) {
                return false;
            }
        }
    }
    return true;
}

static bool isValidateMapKey(id param) {
    return isValidateMap(param,nil);
}

static bool isNumberType(id param) {
    if (param == nil || ![param isKindOfClass:NSNumber.class]) {
        return false;
    }
    return true;
}

@implementation ArgoFlutterPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"argo_flutter_plugin"
            binaryMessenger:[registrar messenger]];
  ArgoFlutterPlugin *instance = [[ArgoFlutterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    @try {
        if ([self respondsToSelector:NSSelectorFromString([NSString stringWithFormat:@"%@:",call.method])]) {
            //NSLog(@"call.method******** %@", call.method);
            SEL calledSEL = NSSelectorFromString([NSString stringWithFormat:@"%@:",call.method]);
            if (calledSEL) {
                Method calledMethod = class_getInstanceMethod(self.class, calledSEL);
                if (calledMethod) {
                    uint numArgs = method_getNumberOfArguments(calledMethod);
                    if (numArgs == 3) {
                        if ([call.method hasPrefix:@"get_"]) {
                            result (((id (*)(id, SEL,id)) method_getImplementation(calledMethod))(self, calledSEL,call.arguments));
                        } else {
                            ((void (*)(id, SEL,id)) method_getImplementation(calledMethod))(self, calledSEL,call.arguments);
                        }
                    }
                }
            }
        } else {
            result(FlutterMethodNotImplemented);
        }
    } @catch (NSException *exception) {
        NSLog(@"run handleMethodCall with exception:%@",[exception description]);
    }
}

//****************************** 易观SDK初始化设置 *********************************//
-(void)startWithConfig:(id)params {
    if (!isValidateMapKey(params)) {
        NSLog(@"init arguments error!!!");
        return;
    }
    NSDictionary *mapParams = (NSDictionary *)params;
    if (isStringType(mapParams[@"appKey"])) {
        AnalysysConfig.appKey = (NSString *)mapParams[@"appKey"];
    }
    if (isStringType(mapParams[@"channel"])) {
        AnalysysConfig.channel = (NSString *)mapParams[@"channel"];
    }
    
    if(isNumberType(mapParams[@"encryptType"])) {
        AnalysysConfig.encryptType = mapParams[@"encryptType"];
    }
    
    if(isNumberType(mapParams[@"autoProfile"])) {
        AnalysysConfig.autoProfile = mapParams[@"autoProfile"];
    }
    if(isNumberType(mapParams[@"autoInstallation"])) {
        AnalysysConfig.autoProfile = mapParams[@"autoInstallation"];
    }
    if(isNumberType(mapParams[@"autoTrackDeviceId"])) {
        AnalysysConfig.autoTrackDeviceId = mapParams[@"autoTrackDeviceId"];
    }

    if(isNumberType(mapParams[@"allowTimeCheck"])) {
        AnalysysConfig.autoTrackDeviceId = mapParams[@"allowTimeCheck"];
    }
    if(isNumberType(mapParams[@"maxDiffTimeInterval"])) {
        AnalysysConfig.autoTrackDeviceId = mapParams[@"maxDiffTimeInterval"];
    }
    
    [AnalysysAgent startWithConfig:AnalysysConfig];
}

//****************************** 服务器地址设置 *********************************//

-(void)set_upload_url:(id)params {
    if (isStringType(params)) {
        [AnalysysAgent setUploadURL:(NSString *)params];
    }
}

//****************************** SDK发送策略 *********************************//

-(void)set_debug_mode:(id)params {
    if (isNumberType(params)) {
        [AnalysysAgent setDebugMode:((NSNumber *)params).intValue];
    }
}

-(void)set_interval_time:(id)params {
    if (isNumberType(params)) {
        [AnalysysAgent setIntervalTime:((NSNumber *)params).integerValue];
    }
}

-(void)set_max_cache_size:(id)params {
    if (isNumberType(params)) {
        [AnalysysAgent setMaxCacheSize:((NSNumber *)params).integerValue];
    }
}

-(id)get_max_cache_size:(id)params {
    return @(AnalysysAgent.maxCacheSize);
}

-(void)set_max_event_size:(id)params {
    if (isNumberType(params)) {
        [AnalysysAgent setMaxEventSize:((NSNumber *)params).integerValue];
    }
}

-(void)flush:(id)params {
    [AnalysysAgent flush];
}

- (void)setUploadNetworkType:(id)params {
    if (isNumberType(params)) {
        [AnalysysAgent setUploadNetworkType:((NSNumber *)params).integerValue];
    }
}

- (void)cleanDBCache:(id)parames {
    [AnalysysAgent cleanDBCache];
}

- (void)setAutomaticCollection:(id)param {
    if (isNumberType(param)) {
        [AnalysysAgent setAutomaticCollection:param];
    }
}

//****************************** 事件 *********************************//

-(void)track:(id)params {
    if (!isValidateMapKey(params)) {
        return;
    }
    NSDictionary *mapParams = (NSDictionary *)params;
    NSString *eventName = mapParams[@"event_name"];
    NSDictionary *properties = mapParams[@"event_info"];
    if (isStringType(eventName)) {
        [AnalysysAgent track:eventName properties:(isValidateMapKey(properties) ? (NSDictionary *)properties : nil)];
    }   
}

-(void)pageview:(id)params {
    if (!isValidateMapKey(params)) {
        return;
    }
    NSDictionary *mapParams = (NSDictionary *)params;
    NSString *pageName = mapParams[@"page_name"];
    NSDictionary *properties = mapParams[@"page_detail"];
    if (isStringType(pageName)) {
        [AnalysysAgent pageView:pageName properties:(isValidateMapKey(properties) ? (NSDictionary *)properties : nil)];
    }
}

//****************************** 用户属性 *********************************//

-(void)alias:(id)aliasId {
    if (!isStringType(aliasId)) {
        return;
    }
    [AnalysysAgent alias:aliasId originalId:nil];
}

-(void)identify:(id)anonymousId {
    if (isStringType(anonymousId)) {
        [AnalysysAgent identify:anonymousId];
    }
}

-(id)get_distinct_id:(id)params{
    NSString *distinctID = [AnalysysAgent getDistinctId];
    return distinctID;
}

-(void)reset:(id) params{
    [AnalysysAgent reset];
}

//****************************** 通用属性 *********************************//

-(void)register_super_property:(id)params {
    if (!isValidateMapKey(params)) {
        return;
    }
    NSDictionary *mapParams = (NSDictionary *)params;
    NSString *propertyName = mapParams[@"property_name"];
    id value = mapParams[@"property_value"];
    if (isStringType(propertyName) && value != nil) {
        [AnalysysAgent registerSuperProperty:propertyName value:value];
    }
}

-(void)register_super_properties:(id)params {
    if (!isValidateMapKey(params)) {
        return;
    }
    NSDictionary *mapParams = (NSDictionary *)params;
    NSDictionary *properties = mapParams[@"properties"];
    if (isValidateMapKey(properties)) {
        [AnalysysAgent registerSuperProperties:properties];
    }
}

-(void)unregister_super_property:(id)params {
    if (isStringType(params)) {
        [AnalysysAgent unRegisterSuperProperty:(NSString *)params];
    }
}

-(void)clear_super_properties:(id)params {
    [AnalysysAgent clearSuperProperties];
}

-(id)get_super_property:(id)params {
    if (isStringType(params)) {
        return [AnalysysAgent getSuperProperty:(NSString *)params];
    }
    return nil;
}

-(id)get_super_properties:(id)params {
    return [AnalysysAgent getSuperProperties];
}

-(id)getPresetProperties:(id)params {
    return [AnalysysAgent getPresetProperties];
}

-(void)profile_set:(id)params {
    if (!isValidateMapKey(params)) {
        return;
    }
    NSDictionary *mapParams = (NSDictionary *)params;
    NSDictionary *properties = mapParams[@"properties"];
    if (isValidateMapKey(properties)) {
        [AnalysysAgent profileSet:properties];
    }
}

-(void)profile_set_once:(id)params {
    if (!isValidateMapKey(params)) {
        return;
    }
    NSDictionary *mapParams = (NSDictionary *)params;
    NSDictionary *properties = mapParams[@"properties"];
    if (isValidateMapKey(properties)) {
        [AnalysysAgent profileSetOnce:properties];
    }
}

-(void)profile_increment:(id)params {
    if (!isValidateMapKey(params)) {
        return;
    }
    NSDictionary *mapParams = (NSDictionary *)params;
    NSDictionary *properties = mapParams[@"properties"];
    if (isValidateMap(properties, NSNumber.class)) {
        [AnalysysAgent profileIncrement:properties];
    }
}

-(void)profile_append:(id)params {
    if (!isValidateMapKey(params)) {
        return;
    }
    NSDictionary *mapParams = (NSDictionary *)params;
    NSDictionary *properties = mapParams[@"properties"];
    if (isValidateMap(properties, NSArray.class)) {
        [AnalysysAgent profileAppend:properties];
    }
}

-(void)profile_unset:(id) params{
    if (isStringType(params)) {
        [AnalysysAgent profileUnset:(NSString *)params];
    }
}

-(void)profile_delete:(id) params{
    [AnalysysAgent profileDelete];
}

// -(void)track_campaign:(id) params{
//     if (!isValidateMapKey(params)) {
//         return;
//     }
//     NSDictionary * mapParams = (NSDictionary *)params;
//     NSString *campaign = mapParams[@"campaign"];
//     bool isClick = false;
//     if (!isStringType(campaign)) {
//         return;
//     }
//     if (!isNumberType(mapParams[@"is_click"])) {
//         return;
//     } 
//     isClick = mapParams[@"is_click"];
//     [AnalysysAgent trackCampaign:campaign isClick:isClick];
// }

@end
