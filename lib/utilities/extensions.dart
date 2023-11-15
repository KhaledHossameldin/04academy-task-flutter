import 'package:flutter/material.dart';

// This file includes Extensions that are used to add more properties or
// function to existing Flutter objects which makes coding much easier if the
// added code is used very often

extension NullableStringExtension on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}

extension NumExtension on num {
  SizedBox get emptyHeight => SizedBox(height: toDouble());
}
