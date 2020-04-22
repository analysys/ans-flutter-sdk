#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"

#import <AnalysysAgent/AnalysysAgent.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GeneratedPluginRegistrant registerWithRegistry:self];
    // Override point for customization after application launch.
    
    AnalysysConfig.appKey = @"heatmaptest0916";
    AnalysysConfig.channel = @"App Store";
    AnalysysConfig.encryptType = AnalysysEncryptAESCBC128;
    [AnalysysAgent startWithConfig:AnalysysConfig];
    
#if DEBUG
    [AnalysysAgent setDebugMode:AnalysysDebugButTrack];
#endif
    [AnalysysAgent setUploadURL:@"http://192.168.220.105:8089"];
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
