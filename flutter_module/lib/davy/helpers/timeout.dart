import 'dart:async';

Timer setTimeout(void Function() callback, int countdown) {
  Duration timeDelay = Duration(milliseconds: countdown);
  return Timer(timeDelay, callback);
}
