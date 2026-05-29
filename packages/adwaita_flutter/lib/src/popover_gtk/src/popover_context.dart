import 'package:adwaita_flutter/src/popover_gtk/src/popover_direction.dart';
import 'package:adwaita_flutter/src/popover_gtk/src/popover_render_shifted_box.dart';
import 'package:flutter/material.dart';

class PopoverContext extends SingleChildRenderObjectWidget {
  const PopoverContext({
    super.key,
    super.child,
    this.attachRect,
    this.backgroundColor,
    this.boxShadow,
    this.animation,
    this.radius,
    this.direction,
    this.arrowWidth,
    this.arrowHeight,
  });
  final Rect? attachRect;
  final Color? backgroundColor;
  final List<BoxShadow>? boxShadow;
  final Animation<double>? animation;
  final double? radius;
  final PopoverDirection? direction;
  final double? arrowWidth;
  final double? arrowHeight;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return PopoverRenderShiftedBox(
      attachRect: attachRect,
      color: backgroundColor,
      boxShadow: boxShadow,
      direction: direction,
      radius: radius,
      arrowWidth: arrowWidth,
      arrowHeight: arrowHeight,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    PopoverRenderShiftedBox renderObject,
  ) {
    renderObject
      ..attachRect = attachRect
      ..color = backgroundColor
      ..boxShadow = boxShadow
      ..direction = direction
      ..radius = radius
      ..arrowWidth = arrowWidth
      ..arrowHeight = arrowHeight;
  }
}
