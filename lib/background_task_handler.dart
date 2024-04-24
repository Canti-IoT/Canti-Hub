import 'dart:isolate';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class BackgroundTaskHandler extends TaskHandler {
  SendPort? _sendPort;
  int _counter = 0;
  // Called when the task is started.
  @override
  void onStart(DateTime timestamp, SendPort? sendPort) async {
    _sendPort = sendPort;

    // You can use the getData function to get the stored data.
    final customData =
        await FlutterForegroundTask.getData<String>(key: 'customData');
    print('customData: $customData');
  }

  // Called every [interval] milliseconds in [ForegroundTaskOptions].
  @override
  void onRepeatEvent(DateTime timestamp, SendPort? sendPort) async {
    FlutterForegroundTask.updateService(
      notificationTitle: 'MyTaskHandler',
      notificationText: 'eventCount: $_counter',
    );

    // Send data to the main isolate.
    _counter++;
    // Send the counter value through the send port
    if (sendPort != null) {
      sendPort!.send(_counter);
      // sendPort!.send(timestamp);
    }
  }

  // Called when the notification button on the Android platform is pressed.
  @override
  void onDestroy(DateTime timestamp, SendPort? sendPort) async {}

  // Called when the notification button on the Android platform is pressed.
  @override
  void onNotificationButtonPressed(String id) {
    print('onNotificationButtonPressed >> $id');
    _sendPort?.send(id);
  }

  // Called when the notification itself on the Android platform is pressed.
  //
  // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
  // this function to be called.
  @override
  void onNotificationPressed() {
    // Note that the app will only route to "/resume-route" when it is exited so
    // it will usually be necessary to send a message through the send port to
    // signal it to restore state when the app is already started.
    FlutterForegroundTask.launchApp();
    _sendPort?.send('onNotificationPressed');
  }
}
