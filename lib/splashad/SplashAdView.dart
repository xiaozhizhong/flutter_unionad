import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unionad/flutter_unionad.dart';

import '../flutter_unionad_code.dart';

class SplashAdView extends StatefulWidget {
  final bool mIsExpress;
  final String androidCodeId;
  final String iosCodeId;
  final bool supportDeepLink;
  final double expressViewWidth;
  final double expressViewHeight;
  final callBack;

  const SplashAdView(
      {Key? key,
      required this.mIsExpress,
      required this.androidCodeId,
      required this.iosCodeId,
      required this.supportDeepLink,
      required this.expressViewWidth,
      required this.expressViewHeight,
      this.callBack})
      : super(key: key);

  @override
  _SplashAdViewState createState() => _SplashAdViewState();
}

class _SplashAdViewState extends State<SplashAdView> {
  String _viewType = "com.gstory.flutter_unionad/SplashAdView";

  MethodChannel? _channel;

  //广告是否显示
  bool _isShowAd = true;

  @override
  void initState() {
    super.initState();
    _isShowAd = true;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isShowAd) {
      return Container();
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return Container(
        width: widget.expressViewWidth,
        height: widget.expressViewHeight,
        child: AndroidView(
          viewType: _viewType,
          creationParams: {
            "mIsExpress": widget.mIsExpress,
            "androidCodeId": widget.androidCodeId,
            "supportDeepLink": widget.supportDeepLink,
            "expressViewWidth": widget.expressViewWidth,
            "expressViewHeight": widget.expressViewHeight,
          },
          onPlatformViewCreated: _registerChannel,
          creationParamsCodec: const StandardMessageCodec(),
        ),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return Container(
        width: widget.expressViewWidth,
        height: widget.expressViewHeight,
        child: UiKitView(
          viewType: _viewType,
          creationParams: {
            "mIsExpress": widget.mIsExpress,
            "iosCodeId": widget.iosCodeId,
            "supportDeepLink": widget.supportDeepLink,
            "expressViewWidth": widget.expressViewWidth,
            "expressViewHeight": widget.expressViewHeight,
          },
          onPlatformViewCreated: _registerChannel,
          creationParamsCodec: const StandardMessageCodec(),
        ),
      );
    } else {
      return Container();
    }
  }

  //注册cannel
  void _registerChannel(int id) {
    _channel = MethodChannel("${_viewType}_$id");
    _channel?.setMethodCallHandler(_platformCallHandler);
  }

  //监听原生view传值
  Future<dynamic> _platformCallHandler(MethodCall call) async {
    switch (call.method) {
      //广告加载完成
      case onAdLoaded:
        break;
      //显示广告
      case onShow:
        break;
      //广告加载失败
      case onFail:
        if (mounted) {
          setState(() {
            _isShowAd = false;
          });
        }
        break;
      //开屏广告点击
      case onAplashClick:
        break;
      //开屏广告跳过
      case onAplashSkip:
        break;
      //开屏广告倒计时结束
      case onAplashFinish:
        break;
      //开屏广告加载超时
      case onAplashTimeout:
        if (mounted) {
          setState(() {
            _isShowAd = false;
          });
        }
        break;
    }
    if (widget.callBack != null) {
      widget.callBack(
          _channel, FlutterUnionadState(call.method, call.arguments));
    }
  }
}
