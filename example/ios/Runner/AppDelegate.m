#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"

#import <AnalysysAgent/AnalysysAgent.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GeneratedPluginRegistrant registerWithRegistry:self];
    // Override point for customization after application launch.
    NSLog(@"%@",[AnalysysAgent SDKVersion]);
    AnalysysConfig.appKey = @"3dc2312475ba8f98";
    AnalysysConfig.channel = @"App Store";
    AnalysysConfig.encryptType = AnalysysEncryptAESCBC128;
    [AnalysysAgent startWithConfig:AnalysysConfig];
    
#if DEBUG
    [AnalysysAgent setDebugMode:AnalysysDebugButTrack];
#else
    [AnalysysAgent setDebugMode:AnalysysDebugOff];
#endif
    [AnalysysAgent setUploadURL:@"https://uba-up.analysysdata.com"];
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
