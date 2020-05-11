import 'dart:convert';

import 'package:argo_flutter_plugin/AnalysysAgent.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '方舟SDK',
      theme: new ThemeData(
        primaryColor: Colors.red,
      ),
      home: new DemoApp(),
    );
  }
}

class DemoApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new SDKDemoList();
  }
}

class SDKDemoList extends State<DemoApp> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('方舟SDK Demo'),
      ),
      body: _functionList(),
    );
  }

  String _distinctId = '';

  Future<void> getDistinctId() async {
    String distinctId;
    distinctId = await AnalysysAgent.getDistinctId();
    setState(() {
      _distinctId = distinctId;
    });
  }

  Widget _functionList() {
    return new ListView(children: <Widget>[
      ListTile(
        title: Text('distinctid:\n' +
            (_distinctId.length > 0 ? _distinctId : '点击获取匿名标识')),
        onTap: () {
          getDistinctId();
        },
      ),
      Divider(color: Colors.grey,),
      ListTile(
        title: Text('track事件'),
        onTap: () {
          AnalysysAgent.track('purchase');
        },
      ),
      Divider(color: Colors.grey,),
      ListTile(
        title: Text('pageView事件'),
        onTap: () {
          AnalysysAgent.pageView('HomePage');
        },
      ),
      Divider(color: Colors.grey,),
      ListTile(
        title: Text('alias事件'),
        onTap: () {
          AnalysysAgent.alias('18688889999');
        },
      ),
      Divider(color: Colors.grey,),
      ListTile(
        title: Text('添加通用属性'),
        onTap: () {
          AnalysysAgent.registerSuperProperties({'birthday': '1990-1-1'});
        },
      ),
      Divider(color: Colors.grey,),
      ListTile(
        title: Text('清理通用属性'),
        onTap: () {
          // AnalysysAgent.clearSuperProperties();
          AnalysysAgent.unRegisterSuperProperty('birthday');
        },
      ),
      Divider(color: Colors.grey,),
      ListTile(
        title: Text('添加用户属性'),
        onTap: () {
          AnalysysAgent.profileSet({"hobby": "pinpang"});
        },
      ),
      Divider(color: Colors.grey,),
      ListTile(
        title: Text('删除用户属性'),
        onTap: () {
          // AnalysysAgent.profileDelete();
          AnalysysAgent.profileUnset('hobby');
        },
      ),
      Divider(color: Colors.grey,),
      ListTile(
        title: Text('自定义测试代码'),
        onTap: () {
          test();
        },
      ),
      Divider(color: Colors.grey,),

    ]);
  }

  void test() {
    //todo 其他测试代码可放在此处
  }
}
