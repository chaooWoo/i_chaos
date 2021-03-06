import 'package:flutter/material.dart';
import 'package:i_chaos/base-getX-framework/mixin/pak_common_widget_mixin.dart';
import 'package:i_chaos/base-getX-framework/view-model/base_view_state_controller.dart';
import 'package:i_chaos/base-getX-framework/view/base_controller_view.dart';

typedef StateViewBuilder<T> = Widget Function(T controller);

abstract class BasePageControllerView<T extends BaseViewStateController> extends BaseControllerView<T> with PakCommonWidget {
  BasePageControllerView({Key? key}) : super(key: key);

  // 页面刷新
  void updatePage({List<Object>? ids}) {
    controller.update(ids);
  }
}
