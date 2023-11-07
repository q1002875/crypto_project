import 'package:crypto_project/main.dart';

import 'common.dart';

class AppLifecycleObserver with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // 在這裡執行相應的操作，根據應用程式生命週期狀態
    switch (state) {
      case AppLifecycleState.resumed:
        debugPrint('應用程式回到前景');
        break;
      case AppLifecycleState.inactive:
        debugPrint('應用程式不處於活躍狀態');
        // 應用程式不處於活躍狀態
        break;
      case AppLifecycleState.paused:
        debugPrint('應用程式進入背景');
        // 應用程式進入背景
        break;
      case AppLifecycleState.detached:
        debugPrint('應用程式完全停止運行');
        mongodb.close();
        // 應用程式完全停止運行
        break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
        break;
    }
  }
}
