class LoggerHelper {
  final String _tag;
  final bool _isEnabled;

  LoggerHelper(this._tag, this._isEnabled);

  void debug(String message) {
    if (_isEnabled) {
      print('[$_tag] DEBUG: $message');
    }
  }

  void info(String message) {
    if (_isEnabled) {
      print('[$_tag] INFO: $message');
    }
  }

  void warn(String message) {
    if (_isEnabled) {
      print('[$_tag] WARNING: $message');
    }
  }

  void error(String message) {
    if (_isEnabled) {
      print('[$_tag] ERROR: $message');
    }
  }
}
