import 'dart:ui';

enum Result {
  success, pending, fail, cancelAccepted, pauseAccepted

}

extension ResultExt on Result {
  Color getBackgroundColor() {
    switch (this) {
      case Result.pauseAccepted:
        return const Color(0xFF74CDE7);
      case Result.cancelAccepted:
        return const Color(0xFF74CDE7);
      case Result.success:
        return const Color(0xFFE5F1FA);
      case Result.pending:
        return const Color(0xFFFAF4E5);
      case Result.fail:
        return const Color(0xFFFAE5E9);
    }
  }

  String getText() {
    switch (this) {
      case Result.success:
        return "Success";
      case Result.pending:
        return "Pending";
      case Result.fail:
        return "Fail";
      case Result.cancelAccepted:
        return "Cancel accepted";
      case Result.pauseAccepted:
        return "Pause accepted";
    }
  }

  String getIcon() {
    switch (this) {
      case Result.success:
        return "assets/images/ic_success.png";
      case Result.pending:
        return "assets/images/ic_pending.png";
      case Result.fail:
        return "assets/images/ic_error.png";
      case Result.cancelAccepted:
        return "";
      case Result.pauseAccepted:
        return "";
    }
  }
}
