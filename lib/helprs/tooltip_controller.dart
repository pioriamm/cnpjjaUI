import 'package:flutter/material.dart';

class TooltipController {
  static OverlayEntry? _current;

  /// abre novo tooltip
  static void show(
      OverlayState overlay, OverlayEntry entry) {
    hide();
    _current = entry;
    overlay.insert(entry);
  }

  /// fecha tooltip atual
  static void hide() {
    _current?.remove();
    _current = null;
  }
}