// ignore_for_file: only_throw_errors, lines_longer_than_80_chars
import 'dart:convert';
import 'dart:typed_data';

import 'package:dbus/dbus.dart';

class GVariantBinaryCodec {
  GVariantBinaryCodec();

  /// Encode a value using GVariant binary format.
  Uint8List encode(DBusValue value, {required Endian endian}) {
    final builder = BytesBuilder();
    _encode(builder, value, endian);
    return builder.takeBytes();
  }

  /// Parse a single GVariant value. [type] is expected to be a valid single type.
  DBusValue decode(String type, ByteData data, {required Endian endian}) {
    // struct
    if (type.startsWith('(')) {
      return _parseGVariantStruct(type, data, endian: endian);
    }

    // array / dict
    if (type.startsWith('a')) {
      if (type.startsWith('a{')) {
        return _parseGVariantDict(type, data, endian: endian);
      } else {
        final childType = type.substring(1);
        return _parseGVariantArray(childType, data, endian: endian);
      }
    }

    // maybe
    if (type.startsWith('m')) {
      final childType = type.substring(1);
      return _parseGVariantMaybe(childType, data, endian: endian);
    }

    switch (type) {
      case 'b': // boolean
        if (data.lengthInBytes != 1) {
          throw 'Invalid length of ${data.lengthInBytes} for boolean GVariant';
        }
        return DBusBoolean(data.getUint8(0) != 0);
      case 'y': // byte
        if (data.lengthInBytes != 1) {
          throw 'Invalid length of ${data.lengthInBytes} for byte GVariant';
        }
        return DBusByte(data.getUint8(0));
      case 'n': // int16
        if (data.lengthInBytes != 2) {
          throw 'Invalid length of ${data.lengthInBytes} for int16 GVariant';
        }
        return DBusInt16(data.getInt16(0, endian));
      case 'q': // uint16
        if (data.lengthInBytes != 2) {
          throw 'Invalid length of ${data.lengthInBytes} for uint16 GVariant';
        }
        return DBusUint16(data.getUint16(0, endian));
      case 'i': // int32
        if (data.lengthInBytes != 4) {
          throw 'Invalid length of ${data.lengthInBytes} for int32 GVariant';
        }
        return DBusInt32(data.getInt32(0, endian));
      case 'u': // uint32
        if (data.lengthInBytes != 4) {
          throw 'Invalid length of ${data.lengthInBytes} for uint32 GVariant';
        }
        return DBusUint32(data.getUint32(0, endian));
      case 'x': // int64
        if (data.lengthInBytes != 8) {
          throw 'Invalid length of ${data.lengthInBytes} for int64 GVariant';
        }
        return DBusInt64(data.getInt64(0, endian));
      case 't': // uint64
        if (data.lengthInBytes != 8) {
          throw 'Invalid length of ${data.lengthInBytes} for uint64 GVariant';
        }
        return DBusUint64(data.getUint64(0, endian));
      case 'd': // double
        return DBusDouble(data.getFloat64(0, endian));
      case 's': // string
        if (data.lengthInBytes < 1) {
          throw 'Invalid length of ${data.lengthInBytes} for string GVariant';
        }
        if (data.getUint8(data.lengthInBytes - 1) != 0) {
          throw 'Missing trailing nul character for string GVariant';
        }
        return DBusString(
          utf8.decode(
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes - 1),
          ),
        );
      case 'o': // object path
        if (data.lengthInBytes < 1) {
          throw 'Invalid length of ${data.lengthInBytes} for object path GVariant';
        }
        if (data.getUint8(data.lengthInBytes - 1) != 0) {
          throw 'Missing trailing nul character for object path GVariant';
        }
        return DBusObjectPath(
          utf8.decode(
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes - 1),
          ),
        );
      case 'g': // signature
        if (data.lengthInBytes < 1) {
          throw 'Invalid length of ${data.lengthInBytes} for signature GVariant';
        }
        if (data.getUint8(data.lengthInBytes - 1) != 0) {
          throw 'Missing trailing nul character for object path GVariant';
        }
        return DBusSignature(
          utf8.decode(
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes - 1),
          ),
        );
      case 'v': // variant
        // Type is a suffix on the data
        var childType = '';
        var offset = data.lengthInBytes - 1;
        while (offset >= 0 && data.getUint8(offset) != 0) {
          childType = ascii.decode([data.getUint8(offset)]) + childType;
          offset--;
        }
        if (offset < 0) {
          throw 'GVariant variant missing child type';
        }
        final childData = ByteData.sublistView(data, 0, offset);
        return DBusVariant(decode(childType, childData, endian: endian));
      default:
        throw "Unsupported GVariant type: '$type'";
    }
  }

  void _encode(BytesBuilder builder, DBusValue value, Endian endian) {
    /// Align this value.
    final offset = _align(builder.length, _getAlignment(value.signature.value));
    for (var i = builder.length; i < offset; i++) {
      builder.addByte(0);
    }

    if (value is DBusBoolean) {
      builder.addByte(value.value ? 0x01 : 0x00);
    } else if (value is DBusByte) {
      _writeUint8(builder, value.value);
    } else if (value is DBusInt16) {
      final buffer = Uint8List(2).buffer;
      ByteData.view(buffer).setInt16(0, value.value, endian);
      builder.add(buffer.asUint8List());
    } else if (value is DBusUint16) {
      _writeUint16(builder, value.value, endian);
    } else if (value is DBusInt32) {
      final buffer = Uint8List(4).buffer;
      ByteData.view(buffer).setInt32(0, value.value, endian);
      builder.add(buffer.asUint8List());
    } else if (value is DBusUint32) {
      _writeUint32(builder, value.value, endian);
    } else if (value is DBusInt64) {
      final buffer = Uint8List(8).buffer;
      ByteData.view(buffer).setInt64(0, value.value, endian);
      builder.add(buffer.asUint8List());
    } else if (value is DBusUint64) {
      _writeUint64(builder, value.value, endian);
    } else if (value is DBusDouble) {
      final buffer = Uint8List(8).buffer;
      ByteData.view(buffer).setFloat64(0, value.value, endian);
      builder.add(buffer.asUint8List());
    } else if (value is DBusString) {
      builder.add(utf8.encode(value.value));
      builder.addByte(0);
    } else if (value is DBusObjectPath) {
      builder.add(utf8.encode(value.value));
      builder.addByte(0);
    } else if (value is DBusSignature) {
      builder.add(utf8.encode(value.value));
      builder.addByte(0);
    } else if (value is DBusVariant) {
      _encode(builder, value.value, endian);
      builder.addByte(0);
      builder.add(utf8.encode(value.value.signature.value));
    } else if (value is DBusMaybe) {
      if (value.value != null) {
        final childSize = _getElementSize(value.valueSignature.value);
        _encode(builder, value.value!, endian);
        if (childSize == -1) {
          builder.addByte(0);
        }
      }
    } else if (value is DBusStruct) {
      _encodeStruct(builder, value.children, endian);
    } else if (value is DBusArray) {
      _encodeArray(builder, value.childSignature.value, value.children, endian);
    } else if (value is DBusDict) {
      _encodeDict(
        builder,
        value.keySignature.value,
        value.valueSignature.value,
        value.children,
        endian,
      );
    } else {
      throw "Unsupported DBus type: '$value'";
    }
  }

  void _encodeStruct(
    BytesBuilder builder,
    List<DBusValue> values,
    Endian endian,
  ) {
    var isVariable = false;
    final endOffsets = <int>[];
    final startOffset = builder.length;
    var alignment = 0;
    for (final value in values) {
      _encode(builder, value, endian);

      // Variable sized elements will have end offsets appended.
      final valueSize = _getElementSize(value.signature.value);
      if (value != values.last && valueSize == -1) {
        isVariable = true;
        endOffsets.add(builder.length - startOffset);
      }

      // Struct is alignent to largest element size.
      if (valueSize == -1) {
        alignment = -1;
      } else if (alignment != -1 && valueSize > alignment) {
        alignment = valueSize;
      }
    }

    if (isVariable) {
      // Calculate smallest size that can be used for offset values.
      final dataLength = builder.length - startOffset;
      var offsetSize = 1;
      while (_getOffsetSize(dataLength + endOffsets.length * offsetSize) !=
          offsetSize) {
        offsetSize *= 2;
      }

      // Append en offsets of variable sized elements.
      for (var i = endOffsets.length - 1; i >= 0; i--) {
        _writeOffset(builder, endOffsets[i], offsetSize, endian);
      }
    } else {
      // Fixed structures must be padded to their alignment.
      if (alignment > 0) {
        final offset = _align(builder.length, alignment);
        for (var i = builder.length; i < offset; i++) {
          builder.addByte(0);
        }
      }
    }
  }

  void _encodeArray(
    BytesBuilder builder,
    String childType,
    List<DBusValue> values,
    Endian endian,
  ) {
    final endOffsets = <int>[];
    final startOffset = builder.length;
    for (final value in values) {
      _encode(builder, value, endian);
      endOffsets.add(builder.length - startOffset);
    }

    // If the elements are of variable length, then each end position needs to recorded.
    final isVariable = _getElementSize(childType) == -1;
    if (isVariable) {
      // Calculate smallest size that can be used for offset values.
      final dataLength = builder.length - startOffset;
      var offsetSize = 1;
      while (_getOffsetSize(dataLength + values.length * offsetSize) !=
          offsetSize) {
        offsetSize *= 2;
      }

      // Write the end offsets of each element.
      for (var i = 0; i < values.length; i++) {
        _writeOffset(builder, endOffsets[i], offsetSize, endian);
      }
    }
  }

  void _encodeDict(
    BytesBuilder builder,
    String keyType,
    String valueType,
    Map<DBusValue, DBusValue> values,
    Endian endian,
  ) {
    final endOffsets = <int>[];
    final startOffset = builder.length;
    for (final entry in values.entries) {
      _encode(builder, DBusStruct([entry.key, entry.value]), endian);
      endOffsets.add(builder.length - startOffset);
    }

    // If the elements are of variable length, then each end position needs to recorded.
    final isVariable =
        _getElementSize(keyType) == -1 || _getElementSize(valueType) == -1;
    if (isVariable) {
      // Calculate smallest size that can be used for offset values.
      final dataLength = builder.length - startOffset;
      var offsetSize = 1;
      while (_getOffsetSize(dataLength + values.length * offsetSize) !=
          offsetSize) {
        offsetSize *= 2;
      }

      // Write the end offsets of each element.
      for (var i = 0; i < values.length; i++) {
        _writeOffset(builder, endOffsets[i], offsetSize, endian);
      }
    }
  }

  void _writeUint8(BytesBuilder builder, int value) {
    builder.addByte(value);
  }

  void _writeUint16(BytesBuilder builder, int value, Endian endian) {
    final buffer = Uint8List(2).buffer;
    ByteData.view(buffer).setUint16(0, value, endian);
    builder.add(buffer.asUint8List());
  }

  void _writeUint32(BytesBuilder builder, int value, Endian endian) {
    final buffer = Uint8List(4).buffer;
    ByteData.view(buffer).setUint32(0, value, endian);
    builder.add(buffer.asUint8List());
  }

  void _writeUint64(BytesBuilder builder, int value, Endian endian) {
    final buffer = Uint8List(8).buffer;
    ByteData.view(buffer).setUint64(0, value, endian);
    builder.add(buffer.asUint8List());
  }

  void _writeOffset(
    BytesBuilder builder,
    int offset,
    int offsetSize,
    Endian endian,
  ) {
    switch (offsetSize) {
      case 1:
        _writeUint8(builder, offset);
        break;
      case 2:
        _writeUint16(builder, offset, endian);
        break;
      case 4:
        _writeUint32(builder, offset, endian);
        break;
      case 8:
        _writeUint64(builder, offset, endian);
        break;
      default:
        throw 'Unsupported offset size $offsetSize';
    }
  }

  DBusStruct _parseGVariantStruct(
    String type,
    ByteData data, {
    required Endian endian,
  }) {
    if (!type.startsWith('(') || !type.endsWith(')')) {
      throw 'Invalid struct type: $type';
    }
    final childTypes = DBusSignature(type.substring(1, type.length - 1))
        .split()
        .map((s) => s.value)
        .toList();
    final childSizes = childTypes.map(_getElementSize).toList();

    // Check if the sizes of the elements can be determined before parsing.
    // The last element can be variable, as it takes up the remaining space.
    var variableSize = false;
    for (var i = 0; i < childSizes.length - 1; i++) {
      if (childSizes[i] == -1) {
        variableSize = true;
        break;
      }
    }

    if (variableSize) {
      return _parseGVariantVariableStruct(childTypes, data, endian: endian);
    } else {
      return _parseGVariantFixedStruct(childTypes, data, endian: endian);
    }
  }

  DBusStruct _parseGVariantFixedStruct(
    List<String> childTypes,
    ByteData data, {
    required Endian endian,
  }) {
    final children = <DBusValue>[];
    var offset = 0;
    for (var i = 0; i < childTypes.length; i++) {
      final type = childTypes[i];
      final start = _align(offset, _getAlignment(type));
      var size = _getElementSize(type);
      if (size < 0) {
        size = data.lengthInBytes - start;
      }
      children.add(
        decode(
          type,
          ByteData.sublistView(data, start, start + size),
          endian: endian,
        ),
      );
      offset += size;
    }

    return DBusStruct(children);
  }

  DBusStruct _parseGVariantVariableStruct(
    List<String> childTypes,
    ByteData data, {
    required Endian endian,
  }) {
    final offsetSize = _getOffsetSize(data.lengthInBytes);
    var dataEnd = data.lengthInBytes;
    final children = <DBusValue>[];
    var offset = 0;
    for (var i = 0; i < childTypes.length; i++) {
      final type = childTypes[i];
      final size = _getElementSize(type);
      final start = _align(offset, _getAlignment(type));
      int end;
      if (size > 0) {
        // Fixed elements
        end = start + size;
      } else if (i == childTypes.length - 1) {
        // Last variable element ends where the data ends.
        end = dataEnd;
      } else {
        // Read the offset from the end of the data.
        end =
            _getOffset(data, dataEnd - offsetSize, offsetSize, endian: endian);
        if (end > dataEnd) {
          throw 'Invalid element end offset in struct';
        }
        dataEnd -= offsetSize;
      }
      children.add(
        decode(type, ByteData.sublistView(data, start, end), endian: endian),
      );
      offset = end;
    }

    return DBusStruct(children);
  }

  DBusDict _parseGVariantDict(
    String type,
    ByteData data, {
    required Endian endian,
  }) {
    if (!type.startsWith('a{') || !type.endsWith('}')) {
      throw 'Invalid dict type: $type';
    }
    final childTypes = DBusSignature(type.substring(2, type.length - 1))
        .split()
        .map((s) => s.value)
        .toList();
    final keyType = childTypes[0];
    final valueType = childTypes[1];
    // Data is stored as an array, this could be optimised to avoid being unpacked and repacked as a dict.
    final array =
        _parseGVariantArray('($keyType$valueType)', data, endian: endian);
    final values = <DBusValue, DBusValue>{};
    for (final child in array.children) {
      final keyValue = child.asStruct();
      values[keyValue[0]] = keyValue[1];
    }
    return DBusDict(DBusSignature(keyType), DBusSignature(valueType), values);
  }

  DBusArray _parseGVariantArray(
    String childType,
    ByteData data, {
    required Endian endian,
  }) {
    final elementSize = _getElementSize(childType);
    if (elementSize > 0) {
      return _parseGVariantFixedArray(
        childType,
        elementSize,
        data,
        endian: endian,
      );
    } else {
      return _parseGVariantVariableArray(childType, data, endian: endian);
    }
  }

  DBusArray _parseGVariantFixedArray(
    String childType,
    int elementSize,
    ByteData data, {
    required Endian endian,
  }) {
    final arrayLength = data.lengthInBytes ~/ elementSize;

    final children = <DBusValue>[];
    for (var i = 0; i < arrayLength; i++) {
      final start = i * elementSize;
      final childData = ByteData.sublistView(data, start, start + elementSize);
      children.add(decode(childType, childData, endian: endian));
    }

    return DBusArray(DBusSignature(childType), children);
  }

  DBusArray _parseGVariantVariableArray(
    String childType,
    ByteData data, {
    required Endian endian,
  }) {
    // Get end of last element.
    final offsetSize = _getOffsetSize(data.lengthInBytes);
    int arrayLength;
    if (data.lengthInBytes > 0) {
      final lastOffset = _getOffset(
        data,
        data.lengthInBytes - offsetSize,
        offsetSize,
        endian: endian,
      );
      final dataLength = data.lengthInBytes - lastOffset;
      if (dataLength < 0 || dataLength % offsetSize != 0) {
        throw 'Invalid element end offset in array';
      }

      // Array size is the number of offsets after the last element.
      arrayLength = dataLength ~/ offsetSize;
    } else {
      arrayLength = 0;
    }

    final children = <DBusValue>[];
    var start = 0;
    final offsetStart = data.lengthInBytes - offsetSize * arrayLength;
    final childAlignment = _getAlignment(childType);
    for (var i = 0; i < arrayLength; i++) {
      final end = _getOffset(
        data,
        offsetStart + offsetSize * i,
        offsetSize,
        endian: endian,
      );
      if (end > offsetStart) {
        throw 'Invalid element end offset in array';
      }
      final childData = ByteData.sublistView(data, start, end);
      children.add(decode(childType, childData, endian: endian));
      start = _align(end, childAlignment);
    }

    return DBusArray(DBusSignature(childType), children);
  }

  DBusMaybe _parseGVariantMaybe(
    String childType,
    ByteData data, {
    required Endian endian,
  }) {
    DBusValue? value;
    if (data.lengthInBytes > 0) {
      ByteData childData;
      final childSize = _getElementSize(childType);
      if (childSize == -1) {
        if (data.getUint8(data.lengthInBytes - 1) != 0) {
          throw 'Invalid padding byte on maybe GVariant';
        }
        childData = ByteData.sublistView(data, 0, data.lengthInBytes - 1);
      } else {
        childData = data;
      }
      value = decode(childType, childData, endian: endian);
    }
    return DBusMaybe(DBusSignature(childType), value);
  }

  int _align(int offset, int alignment) {
    final x = offset % alignment;
    return x == 0 ? offset : offset + (alignment - x);
  }

  int _getElementSize(String type) {
    /// Containers are variable length.
    if (type.startsWith('a') || type.startsWith('m')) {
      return -1;
    }

    if (type.startsWith('(') || type.startsWith('{')) {
      final childTypes = DBusSignature(type.substring(1, type.length - 1))
          .split()
          .map((s) => s.value);
      var size = 0;
      for (final type in childTypes) {
        size = _align(size, _getAlignment(type));
        final s = _getElementSize(type);
        if (s < 0) {
          return -1;
        }
        size += s;
      }
      return size;
    }

    switch (type) {
      case 'y': // byte
      case 'b': // boolean
        return 1;
      case 'n': // int16
      case 'q': // uint16
        return 2;
      case 'i': // int32
      case 'u': // uint32
        return 4;
      case 'x': // int64
      case 't': // uint64
      case 'd': // double
        return 8;
      case 's': // string
      case 'o': // object path
      case 'g': // signature
      case 'v': // variant
        return -1; // variable size
      default:
        throw ArgumentError.value(type, 'type', 'Unknown type');
    }
  }

  int _getAlignment(String type) {
    if (type.startsWith('a') || type.startsWith('m')) {
      return _getAlignment(type.substring(1));
    }
    if (type.startsWith('(') || type.startsWith('{')) {
      final childTypes = DBusSignature(type.substring(1, type.length - 1))
          .split()
          .map((s) => s.value);
      var alignment = 1;
      for (final type in childTypes) {
        final a = _getAlignment(type);
        if (a > alignment) {
          alignment = a;
        }
      }
      return alignment;
    }

    switch (type) {
      case 'y': // byte
      case 'b': // boolean
      case 's': // string
      case 'o': // object path
      case 'g': // signature
        return 1;
      case 'n': // int16
      case 'q': // uint16
        return 2;
      case 'i': // int32
      case 'u': // uint32
        return 4;
      case 'x': // int64
      case 't': // uint64
      case 'd': // double
      case 'v': // variant
        return 8;
      default:
        throw ArgumentError.value(type, 'type', 'Unknown type');
    }
  }

  int _getOffsetSize(int size) {
    if (size > 0xffffffff) {
      return 8;
    } else if (size > 0xffff) {
      return 4;
    } else if (size > 0xff) {
      return 2;
    } else {
      return 1;
    }
  }

  int _getOffset(
    ByteData data,
    int offset,
    int offsetSize, {
    required Endian endian,
  }) {
    switch (offsetSize) {
      case 1:
        return data.getUint8(offset);
      case 2:
        return data.getUint16(offset, endian);
      case 4:
        return data.getUint32(offset, endian);
      case 8:
        return data.getUint64(offset, endian);
      default:
        throw 'Unknown offset size $offsetSize';
    }
  }
}
