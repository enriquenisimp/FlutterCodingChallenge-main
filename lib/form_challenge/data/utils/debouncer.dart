import 'dart:async';
import 'dart:ui';

class Debounce {
  Debounce();

  Timer? _timer;

  void run({required int milliseconds, required VoidCallback action}) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void close() {
    _timer?.cancel();
  }
}
