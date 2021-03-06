import 'dart:io';

import 'package:flustars/flustars.dart';
import 'package:path_provider/path_provider.dart';

class StorageManager {
  // 临时目录  （华为手机可能会随机删除这个目录下的文件）
  static Directory? temporaryDirectory;

  // 应用目录
  static late Directory appDirectory;

  // 外部存储 (仅限安卓)
  static Directory? externalDirectory;

  static init() async {
    await SpUtil.getInstance();
    temporaryDirectory = await getTemporaryDirectory();
    appDirectory = await getApplicationDocumentsDirectory();
    if (Platform.isAndroid) {
      externalDirectory = await getExternalStorageDirectory();
    }
  }
}
