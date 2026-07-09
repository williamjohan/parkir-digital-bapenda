import 'package:flutter/material.dart';

enum PbRadiusType { normal, full }

extension PbRadiusTypeExtension on PbRadiusType {
  BorderRadiusGeometry get value {
    switch (this) {
      case PbRadiusType.normal:
        return BorderRadius.circular(4);

      case PbRadiusType.full:
        return BorderRadius.circular(100);
    }
  }
}
