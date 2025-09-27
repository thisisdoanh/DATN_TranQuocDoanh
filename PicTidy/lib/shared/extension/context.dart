import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  ThemeData theme() {
    return Theme.of(this);
  }
}
