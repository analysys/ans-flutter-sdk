package com.analysys.argo.argo_flutter_plugin_example;


import com.analysys.AnalysysAgent;
import com.analysys.AnalysysConfig;
import com.analysys.EncryptEnum;

import io.flutter.app.FlutterApplication;

public class App extends FlutterApplication {
    public static final String UPLOAD_URL = "https://arkpaastest.analysys.cn:4089";
    private static final String SOCKET_URL = "wss://arkpaastest.analysys.cn:4091";
    private static final String CONFIG_URL = "https://arkpaastest.analysys.cn:4089";
    @Override
    public void onCreate() {
        super.onCreate();
        //初始化方舟SDK
        AnalysysConfig config = new AnalysysConfig();
        // 设置key(目前使用电商demo的key)
        config.setAppKey("your_analysys_appkey");
        // 设置渠道
        config.setChannel("your_channel");
        // 设置追踪新用户的首次属性
        config.setAutoProfile(true);
        // 设置使用AES加密
        config.setEncryptType(EncryptEnum.AES);
        // 设置服务器时间校验
        config.setAllowTimeCheck(true);
        // 时间最大允许偏差为5分钟
        config.setMaxDiffTimeInterval(5 * 60);
        // 开启渠道归因
        config.setAutoInstallation(true);
        // 热图数据采集（默认关闭）
        config.setAutoHeatMap(false);
        // pageView自动上报总开关（默认开启）
        config.setAutoTrackPageView(false);
        // fragment-pageView自动上报开关（默认关闭）
        config.setAutoTrackFragmentPageView(false);
        // 点击自动上报开关（默认关闭）
        config.setAutoTrackClick(false);

        config.setAutoTrackCrash(false);

        config.setAutoTrackDeviceId(true);
        // 初始化
        AnalysysAgent.init(this, config);
        // 设置数据上传/更新地址
        AnalysysAgent.setUploadURL(this, UPLOAD_URL);
        // 设置 WebSocket 连接 Url
        AnalysysAgent.setVisitorDebugURL(this, SOCKET_URL);
        // 设置配置下发 Url
        AnalysysAgent.setVisitorConfigURL(this, CONFIG_URL);
    }
}
