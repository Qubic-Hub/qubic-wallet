import 'package:flutter/material.dart';
import 'package:qubic_wallet/globals.dart';

/// A global snackbar that can be shown from anywhere in the app
class GlobalSnackBar {
  bool _isVisible = false;

  /// The visibility of the snackbar
  get isVisible => _isVisible;

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>?
      _snackbarController;

  /// Shows a snackbar with the given message
  /// @param message The message to show
  /// @param forceShow If true, the snackbar will be shown even if it is already visible
  /// @param shownCallback A callback that is called when the snackbar is shown
  /// @param closeCallback A callback that is called when the snackbar is closed
  void show(String message,
      [bool forceShow = false,
      Function? shownCallback,
      Function? closeCallback]) {
    if (_isVisible && !forceShow) return;
    if (_isVisible && forceShow && _snackbarController != null) {
      _snackbarController!.close();
    }

    _snackbarController = snackbarKey.currentState!.showSnackBar(SnackBar(
      elevation: 199,
      showCloseIcon: true,
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      content: Text(message),
      onVisible: () {
        _isVisible = true;
        if (shownCallback == null) return;
        shownCallback.call();
      },
    ));
    _snackbarController!.closed.then((reason) {
      _isVisible = false;
      if (closeCallback == null) return;
      closeCallback.call(reason);
    });
  }

  void hide() {
    if (_snackbarController != null) _snackbarController!.close();
  }
}
