import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i_chaos/base_framework/config/router_manager.dart';
import 'package:i_chaos/base_framework/utils/image_helper.dart';
import 'package:i_chaos/base_framework/widget_state/base_state.dart';
import 'package:i_chaos/base_framework/widget_state/widget_state.dart';
import 'package:i_chaos/icons/ali_icons.dart';

export 'package:i_chaos/base_framework/extension/size_adapter_extension.dart';

/// * 如果是页面，继承 [PageState]
/// * 如果是view，继承 [WidgetState]
/// 确保你的页面名字在项目中唯一，
/// 否则一些页面跳转的结果可能非你预期
/// ensure your page's name is unique in project,
/// will cause unexpected in navigator action if not.
///

/// 此处扩展功能应该只与page相关

abstract class PageState extends BaseState with WidgetGenerator, RouteAware, _RouteHandler {
  ///所有页面请务必使用此方法作为根布局
  ///[isSetDark]切换状态栏 模式：light or dark
  ///[child] 你的页面
  ///[edgeInsets] 一般用于屏幕虚拟的适配
  ///[needSlideOut]是否支持右滑返回、如果整个项目不需要，可以配置默认值为false
  Widget switchStatusBar2Dark({bool isSetDark = true, required Widget child, EdgeInsets? edgeInsets, bool needSlideOut = false}) {
    if (!needSlideOut) {
      ///不含侧滑退出
      return _getNormalPage(isSetDark: isSetDark, child: child, edgeInsets: edgeInsets);
    } else {
      ///侧滑退出
      return _getPageWithSlideOut(
        isSetDark: isSetDark,
        child: child,
        edgeInsets: edgeInsets,
      );
    }
  }

  Widget _getNormalPage({bool isSetDark = true, required Widget child, EdgeInsets? edgeInsets}) {
    return AnnotatedRegion(
        value: isSetDark ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
        child: Material(
          color: Colors.white,
          child: Padding(
            padding: edgeInsets ?? EdgeInsets.only(bottom: ScreenUtil.getInstance().bottomBarHeight),
            child: child,
          ),
        ));
  }

  ///页面左边距
  double marginLeft = 0.0;

  ///拖动位置
  double dragPosition = 0.0;

  ///触发页面滑动动画
  bool slideOutActive = false;

  Widget _getPageWithSlideOut({bool isSetDark = true, required Widget child, EdgeInsets? edgeInsets}) {
    return AnnotatedRegion(
        value: isSetDark ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: edgeInsets ?? EdgeInsets.only(bottom: ScreenUtil.getInstance().bottomBarHeight),
            child: GestureDetector(
              onHorizontalDragStart: (dragStart) {
                slideOutActive = dragStart.globalPosition.dx < (screenWidth / 10);
              },
              onHorizontalDragUpdate: (dragDetails) {
                if (!slideOutActive) return;
                marginLeft = dragDetails.globalPosition.dx;
                dragPosition = marginLeft;
                //if(marLeft > 250) return;
                if (marginLeft < 50.w) marginLeft = 0;
                setState(() {});
              },
              onHorizontalDragEnd: (dragEnd) {
                if (dragPosition > screenWidth / 5) {
                  pop();
                } else {
                  marginLeft = 0.0;
                  setState(() {});
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.only(left: marginLeft),
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: child,
                ),
              ),
            ),
          ),
        ));
  }

  // 自定义通用appBar
  AppBar customCommonAppBar(
      {String? title,
        Widget? customTitle,
      Color titleColor = Colors.white,
      List<Widget>? actions,
      Color backgroundColor = Colors.black,
      bool centerTitle = false,
      double? elevation = 0.0,
      Color leadingButtonColor = Colors.white,
      bool? needPop,
      IconData? leadingButtonIcon,
      VoidCallback? leadingButtonOnTap}) {
    Widget? leadingWidget;
    if (needPop != null && needPop) {
      leadingWidget = InkWell(
        child: Icon(
          AliIcons.IconReturn,
          color: leadingButtonColor,
        ),
        onTap: () {
          pop();
        },
      );
    } else {
      if (leadingButtonIcon != null) {
        leadingWidget = leadingButtonOnTap != null
            ? InkWell(
                child: Icon(
                  leadingButtonIcon,
                  color: leadingButtonColor,
                ),
                onTap: () {
                  leadingButtonOnTap.call();
                },
              )
            : Icon(
                leadingButtonIcon,
                color: leadingButtonColor,
              );
      }
    }

    return AppBar(
      titleSpacing: leadingWidget != null ? -5 : null,
      toolbarHeight: 40,
      elevation: elevation,
      centerTitle: centerTitle,
      actions: actions,
      title: title != null ? Text(
        title,
        style: TextStyle(color: titleColor, fontSize: 18, fontFamily: 'Lexend Deca'),
      ) : customTitle,
      backgroundColor: backgroundColor,
      leading: leadingWidget,
    );
  }

  /// 一般页面的通用APP BAR 具体根据项目需求调整
  Widget commonAppBar(
      {Widget? leftWidget,
      String? title,
      List<Widget>? rightWidget,
      Color bgColor = Colors.white,
      required double leftPadding,
      required double rightPadding}) {
    return Container(
      width: 750.w,
      height: 115.h,
      color: bgColor,
      padding: EdgeInsets.only(bottom: 10.h, left: leftPadding, right: rightPadding),
      alignment: Alignment.bottomCenter,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          Positioned(
            left: 0,
            child: leftWidget ?? Container(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Visibility(
              visible: title != null,
              child: Text(
                "$title",
                style: TextStyle(fontSize: 36.sp, color: Colors.black, decoration: TextDecoration.none),
              ),
            ),
          ),
          if (rightWidget != null) ...rightWidget,
        ],
      ),
    );
  }

  ///通用APP bar 统一后退键
  Widget buildAppBarLeft() {
    return GestureDetector(
      onTap: () {
        if (canPop()) {
          pop();
        } else {
          /// 增加需要的提示信息
        }
      },
      child: Container(
        color: Colors.white,
        width: 150.w,
        height: 90.h,
        alignment: Alignment.bottomLeft,
        child: const Icon(AliIcons.IconReturn),
      ),
    );
  }

  //////////////////////////////////////////////////////
  ///页面出/入 监测
  //////////////////////////////////////////////////////
  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute<dynamic>);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    handleDidPush();
    super.didPush();
  }

  @override
  void didPop() {
    handleDidPop();
    super.didPop();
  }

  @override
  void didPopNext() {
    handleDidPopNext();
    super.didPopNext();
  }

  @override
  void didPushNext() {
    handleDidPushNext();
    super.didPushNext();
  }
}

/// route aware's util
/// you can do something in this
/// e.g. create recordList at [_RouteHandler] and record something

mixin _RouteHandler on BaseState implements HandleRouteNavigate {
  @override
  void handleDidPop() {
    debugPrint("已经pop的页面 ${this.runtimeType}");
  }

  @override
  void handleDidPush() {
    debugPrint("push后,显示的页面 ${this.runtimeType}");
  }

  @override
  void handleDidPopNext() {
    debugPrint("pop后，将要显示的页面 ${this.runtimeType}");
  }

  @override
  void handleDidPushNext() {
    debugPrint("push后，被遮挡的页面 ${this.runtimeType}");
  }
}

abstract class HandleRouteNavigate {
  void handleDidPush();

  void handleDidPop();

  void handleDidPopNext();

  void handleDidPushNext();
}
