#import "ArgoFlutterPlugin.h"
#import <AnalysysAgent/AnalysysAgent.h>
#import <objc/runtime.h>

static bool isStringType (id param) {
    if (param == nil || ![param isKindOfClass:NSString.class]) {
        return false;
    }
    NSString *tempString = (NSString *)param;
    if (tempString == nil || tempString.length == 0) {
        return false;
    }
    return true;
}

static bool isValidateMap (id param,Class cls) {
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

static bool isValidateMapKey (id param) {
    return isValidateMap (param,nil);
}

static bool isNumberType (id param) {
    if (param == nil || ![param isKindOfClass:NSNumber.class]) {
        return false;
    }
    return true;
}

@implementation ArgoFlutterPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"argo_flutter_plugin"
            binaryMessenger:[registrar messenger]];
  ArgoFlutterPlugin* instance = [[ArgoFlutterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    @try {
        if ([self respondsToSelector:NSSelectorFromString([NSString stringWithFormat:@"%@:",call.method])]) {
            SEL calledSEL = NSSelectorFromString([NSString stringWithFormat:@"%@:",call.method]);
            if (calledSEL) {
                Method calledMethod = class_getInstanceMethod(self.class, calledSEL);
                if (calledMethod) {
                    uint numArgs = method_getNumberOfArguments(calledMethod);
                    if (numArgs == 3) {
                        if ([call.method hasPrefix:@"get_"]) {
                            result (((id (*)(id, SEL,id)) method_getImplementation(calledMethod))(self, calledSEL,call.arguments));
                        }else {
                            ((void (*)(id, SEL,id)) method_getImplementation(calledMethod))(self, calledSEL,call.arguments);
                        }
                    }
                }
            }
        }else {
            result(FlutterMethodNotImplemented);
        }
    } @catch (NSException *exception) {
        NSLog(@"run handleMethodCall with exception:%@",[exception description]);
    }
}



-(void)init:(id) params{
    if (!isValidateMapKey(params)) {
        NSLog(@"init arguments error!!!");
        return;
    }
    NSDictionary * mapParams = (NSDictionary *)params;
    if (isStringType(mapParams[@"channel"])) {
        AnalysysConfig.channel = (NSString *)mapParams[@"channel"];
    }
    if (isStringType(mapParams[@"base_url"])) {
        AnalysysConfig.baseUrl = (NSString *)mapParams[@"base_url"];
    }
    if (isStringType(mapParams[@"app_key"])) {
        AnalysysConfig.appKey = (NSString *)mapParams[@"app_key"];
    }
    AnalysysConfig.autoProfile = false;
    AnalysysConfig.autoInstallation = false;
    [AnalysysAgent setAutomaticHeatmap:false];
    [AnalysysAgent setAutomaticCollection:false];
    [AnalysysAgent startWithConfig:AnalysysConfig];
}

-(void)set_debug_mode:(id) params{
    if (isNumberType(params)) {
        [AnalysysAgent setDebugMode:((NSNumber *)params).intValue];
    }
}

-(void)set_upload_url:(id) params{
    if (isStringType(params)) {
        [AnalysysAgent setUploadURL:(NSString *)params];
    }
}

-(void)set_interval_time:(id) params{
    if (isNumberType(params)) {
        [AnalysysAgent setIntervalTime:((NSNumber *)params).integerValue];
    }
}

-(void)set_max_cache_size:(id) params{
    if (isNumberType(params)) {
        [AnalysysAgent setMaxCacheSize:((NSNumber *)params).integerValue];
    }
}

-(id)get_max_cache_size:(id) params{
    return @(AnalysysAgent.maxCacheSize);
}

-(void)set_max_event_size:(id) params{
    if (isNumberType(params)) {
        [AnalysysAgent setMaxEventSize:((NSNumber *)params).integerValue];
    }
}

-(void)flush:(id) params{
    [AnalysysAgent flush];
}

-(void)alias:(id) params{
    if (!isValidateMapKey(params)) {
        return;
    }
    NSDictionary * mapParams = (NSDictionary *)params;
    NSString *aliasId = nil;
    NSString *originalId = nil;
    if (isStringType(mapParams[@"alias_id"])) {
        aliasId = (NSString *)mapParams[@"alias_id"];
    }
    if (isStringType(mapParams[@"original_id"])) {
        originalId = (NSString *)mapParams[@"original_id"];
    }
    if (aliasId != nil && originalId != nil) {
        [AnalysysAgent alias:aliasId originalId:originalId];
    }
}

-(void)identify:(id) params{
    if (isStringType(params)) {
        [AnalysysAgent identify:(NSString *)params];
    }
}

-(id)get_distinct_id:(id) params{
    return [AnalysysAgent getDistinctId];
}

-(void)reset:(id) params{
    [AnalysysAgent reset];
}

-(void)track:(id) params{
    if (!isValidateMapKey(params)) {
        return;
    }
    NSDictionary * mapParams = (NSDictionary *)params;
    NSString *name = nil;
    NSDictionary *info = nil;
    if (isStringType(mapParams[@"event_name"])) {
        name = (NSString *)mapParams[@"event_name"];
    }
    if (isValidateMapKey(mapParams[@"event_info"])) {
        info = (NSDictionary *)mapParams[@"event_info"];
    }
    if (name != nil && info != nil) {
        [AnalysysAgent track:name properties:info];
    }else if (name != nil) {
        [AnalysysAgent track:name];
    }
}

-(void)pageview:(id) params{
    if (!isValidateMapKey(params)) {
        return;
    }
    NSDictionary * mapParams = (NSDictionary *)params;
    NSString *name = nil;
    NSDictionary *info = nil;
    if (isStringType(mapParams[@"page_name"])) {
        name = (NSString *)mapParams[@"page_name"];
    }
    if (isValidateMapKey(mapParams[@"page_detail"])) {
        info = (NSDictionary *)mapParams[@"page_detail"];
    }
    if (name != nil && info != nil) {
        [AnalysysAgent pageView:name properties:info];
    }else if (name != nil) {
        [AnalysysAgent pageView:name];
    }
}

-(void)register_super_property:(id) params{
    if (!isValidateMapKey(params)) {
        return;
    }
    NSDictionary * mapParams = (NSDictionary *)params;
    NSString *name = nil;
    id        info = nil;
    if (isStringType(mapParams[@"property_name"])) {
        name = (NSString *)mapParams[@"property_name"];
    }
    info = mapParams[@"property_value"];
    if (name != nil && info != nil) {
        [AnalysysAgent registerSuperProperty:name value:info];
    }
}

-(void)register_super_properties:(id) params{
    if (!isValidateMapKey(params)) {
        return;
    }
    NSDictionary * mapParams = (NSDictionary *)params;
    NSDictionary *info = nil;
    if (isValidateMapKey(mapParams[@"properties"])) {
        info = (NSDictionary *)mapParams[@"properties"];
    }
    if (info != nil) {
        [AnalysysAgent registerSuperProperties:info];
    }
}

-(void)unregister_super_property:(id) params{
    if (isStringType(params)) {
        [AnalysysAgent unRegisterSuperProperty:(NSString *)params];
    }
}

-(void)clear_super_properties:(id) params{
    [AnalysysAgent clearSuperProperties];
}

-(id)get_super_property:(id) params{
    if (isStringType(params)) {
        return [AnalysysAgent getSuperProperty:(NSString *)params];
    }
    return nil;
}

-(id)get_super_properties:(id) params{
    return [AnalysysAgent getSuperProperties];
}

-(void)profile_set:(id) params{
    if (!isValidateMapKey(params)) {
        return;
    }
    NSDictionary * mapParams = (NSDictionary *)params;
    NSDictionary *info = nil;
    if (isValidateMapKey(mapParams[@"properties"])) {
        info = (NSDictionary *)mapParams[@"properties"];
    }
    if (info != nil) {
        [AnalysysAgent profileSet:info];
    }
}

-(void)profile_set_once:(id) params{
    if (!isValidateMapKey(params)) {
        return;
    }
    NSDictionary * mapParams = (NSDictionary *)params;
    NSDictionary *info = nil;
    if (isValidateMapKey(mapParams[@"properties"])) {
        info = (NSDictionary *)mapParams[@"properties"];
    }
    if (info != nil) {
        [AnalysysAgent profileSetOnce:info];
    }
}

-(void)profile_increment:(id) params{
    if (!isValidateMapKey(params)) {
        return;
    }
    NSDictionary * mapParams = (NSDictionary *)params;
    NSDictionary *info = nil;
    if (isValidateMap(mapParams[@"properties"],NSNumber.class)) {
        info = (NSDictionary *)mapParams[@"properties"];
    }
    if (info != nil) {
        [AnalysysAgent profileIncrement:info];
    }
}

-(void)profile_append:(id) params{
    if (!isValidateMapKey(params)) {
        return;
    }
    NSDictionary * mapParams = (NSDictionary *)params;
    NSDictionary *info = nil;
    if (isValidateMapKey(mapParams[@"properties"])) {
        info = (NSDictionary *)mapParams[@"properties"];
    }
    if (info != nil) {
        [AnalysysAgent profileAppend:info];
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

-(void)track_campaign:(id) params{
    if (!isValidateMapKey(params)) {
        return;
    }
    NSDictionary * mapParams = (NSDictionary *)params;
    NSString *campaign = nil;
    bool isClick = false;
    if (isStringType(mapParams[@"campaign"])) {
        campaign = (NSString *)mapParams[@"campaign"];
    }
    if (isNumberType(mapParams[@"is_click"])) {
        isClick = (NSString *)mapParams[@"is_click"];
    }else {
        return;
    }
    if (campaign != nil) {
        [AnalysysAgent trackCampaign:campaign isClick:isClick];
    }
}

@end
