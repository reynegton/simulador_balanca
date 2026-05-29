import 'package:adwaita_flutter/src/popover_gtk/src/popover_direction.dart';
import 'package:adwaita_flutter/src/popover_gtk/src/utils/popover_utils.dart';
import 'package:adwaita_flutter/src/popover_gtk/src/utils/utils.dart';
import 'package:flutter/rendering.dart';

class PopoverPositionRenderObject extends RenderShiftedBox {
  PopoverPositionRenderObject({
    required this.arrowHeight,
    RenderBox? child,
    Rect? attachRect,
    BoxConstraints? constraints,
    PopoverDirection? direction,
  }) : super(child) {
    _attachRect = attachRect;
    _additionalConstraints = constraints;
    _direction = direction;
  }
  PopoverDirection? _direction;
  Rect? _attachRect;
  BoxConstraints? _additionalConstraints;
  double? arrowHeight;

  BoxConstraints? get additionalConstraints => _additionalConstraints;
  set additionalConstraints(BoxConstraints? value) {
    if (_additionalConstraints == value) return;
    _additionalConstraints = value;
    markNeedsLayout();
  }

  Rect? get attachRect => _attachRect;
  set attachRect(Rect? value) {
    if (_attachRect == value) return;
    _attachRect = value;
    markNeedsLayout();
  }

  PopoverDirection? get direction => _direction;
  set direction(PopoverDirection? value) {
    if (_direction == value) return;
    _direction = value;
    markNeedsLayout();
  }

  Offset calculateOffset(Size size) {
    final direction = PopoverUtils.popoverDirection(
      attachRect,
      size,
      _direction,
      arrowHeight,
    );

    if (direction == PopoverDirection.top ||
        direction == PopoverDirection.bottom) {
      return _dxOffset(direction, _horizontalOffset(size), size);
    } else {
      return _dyOffset(direction, _verticalOffset(size), size);
    }
  }

  @override
  void performLayout() {
    child!.layout(
      _additionalConstraints!.enforce(constraints),
      parentUsesSize: true,
    );
    size = Size(constraints.maxWidth, constraints.maxHeight);
    final childParentData = child!.parentData! as BoxParentData;
    childParentData.offset = calculateOffset(child!.size);
  }

  Offset _dxOffset(
    PopoverDirection direction,
    double horizontalOffset,
    Size size,
  ) {
    if (direction == PopoverDirection.bottom) {
      return Offset(horizontalOffset, attachRect!.bottom);
    } else {
      return Offset(horizontalOffset, attachRect!.top - size.height);
    }
  }

  Offset _dyOffset(
    PopoverDirection direction,
    double verticalOffset,
    Size size,
  ) {
    if (direction == PopoverDirection.right) {
      return Offset(attachRect!.right, verticalOffset);
    } else {
      return Offset(attachRect!.left - size.width, verticalOffset);
    }
  }

  double _horizontalOffset(Size size) {
    var offset = 0.0;

    if (attachRect!.left > size.width / 2 &&
        Utils().screenWidth - attachRect!.right > size.width / 2) {
      offset = attachRect!.left + attachRect!.width / 2 - size.width / 2;
    } else if (attachRect!.left < size.width / 2) {
      offset = arrowHeight!;
    } else {
      offset = Utils().screenWidth - arrowHeight! - size.width;
    }
    return offset;
  }

  double _verticalOffset(Size size) {
    var offset = 0.0;

    if (attachRect!.top > size.height / 2 &&
        Utils().screenHeight - attachRect!.bottom > size.height / 2) {
      offset = attachRect!.top + attachRect!.height / 2 - size.height / 2;
    } else if (attachRect!.top < size.height / 2) {
      offset = arrowHeight!;
    } else {
      offset = Utils().screenHeight - arrowHeight! - size.height;
    }
    return offset;
  }
}
