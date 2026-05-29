import 'package:adwaita_flutter/src/popover_gtk/src/popover_direction.dart';
import 'package:adwaita_flutter/src/popover_gtk/src/popover_position_render_object.dart';
import 'package:flutter/material.dart';

class PopoverPositionWidget extends SingleChildRenderObjectWidget {
  const PopoverPositionWidget({
    super.key,
    required this.arrowHeight,
    this.attachRect,
    this.constraints,
    this.scale,
    this.direction,
    super.child,
  });
  final Rect? attachRect;
  final Animation<double>? scale;
  final BoxConstraints? constraints;
  final PopoverDirection? direction;
  final double? arrowHeight;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return PopoverPositionRenderObject(
      attachRect: attachRect,
      direction: direction,
      constraints: constraints,
      arrowHeight: arrowHeight,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    PopoverPositionRenderObject renderObject,
  ) {
    renderObject
      ..attachRect = attachRect
      ..direction = direction
      ..additionalConstraints = constraints;
  }
}
