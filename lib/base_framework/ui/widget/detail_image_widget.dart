import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:i_chaos/base_framework/widget_state/page_state.dart';

class DetailImageWidgetState extends PageState {
  final List<String?>? imageList;
  final int initIndex;
  int indexStr = 1;

  DetailImageWidgetState(this.imageList, {this.initIndex = 0});

  @override
  Widget build(BuildContext context) {
    return switchStatusBar2Dark(
        isSetDark: true,
        edgeInsets: EdgeInsets.all(0),
        child: Container(
          width: 750.w,
          height: 1334.h,
          child: Stack(
            children: <Widget>[
              Container(
                color: Colors.black,
                width: 750.w,
                height: 1334.h,

                ///可增加滑动退出等功能、具体可以查看插件的文档
                child: ExtendedImageGesturePageView.builder(
                  controller: ExtendedPageController(initialPage: initIndex),
                  itemCount: imageList!.length,
                  itemBuilder: (ctx, index) {
                    var url = "${imageList![index]}";
                    //var url = "http://a0.att.hudong.com/78/52/01200000123847134434529793168.jpg";
                    Widget image = ExtendedImage.network(
                      url,
                      fit: BoxFit.contain,
                      mode: ExtendedImageMode.gesture,
                      initGestureConfigHandler: (state) {
                        return GestureConfig(inPageView: imageList!.length > 1);
                      },
                    );
                    return image;
                  },
                  onPageChanged: (int index) {
                    setState(() {
                      indexStr = index + 1;
                    });
                  },
                ),
              ),
              commonAppBar(title: "$indexStr/${imageList!.length}", leftWidget: buildAppBarLeft(), leftPadding: 40.w, rightPadding: 40.h),
            ],
          ),
        ));
  }
}
