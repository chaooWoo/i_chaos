
import 'package:i_chaos/base_framework/config/storage_manager.dart';

class AppConfig{
  static init() async {
    // 启动本地存储工具
    await StorageManager.init();
  }
}