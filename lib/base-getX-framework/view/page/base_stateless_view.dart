
import 'package:flutter/material.dart';
import 'package:i_chaos/base-getX-framework/mixin/get_x_dependency_mixin.dart';
import 'package:i_chaos/base-getX-framework/mixin/get_x_navigation_mixin.dart';
import 'package:i_chaos/base-getX-framework/mixin/magic-ww-dialog/magic_ww_dialog_mixin.dart';
import 'package:i_chaos/base-getX-framework/mixin/pak_common_widget_mixin.dart';
import 'package:i_chaos/base-getX-framework/mixin/screen_adapter_mixin.dart';
import 'package:i_chaos/base-getX-framework/mixin/toast_mixin.dart';

abstract class BaseStatelessView extends StatelessWidget
    with GetXDependencyMixin, GetXNavigationMixin, ToastMixin, MagicWWDialogMixin, ScreenAdapterMixin, PakCommonWidget {

  BaseStatelessView({Key? key}) : super(key: key);
}