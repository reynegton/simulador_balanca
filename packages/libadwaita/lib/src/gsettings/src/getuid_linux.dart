// ignore_for_file: only_throw_errors
import 'dart:ffi';
import 'dart:io';

/// Gets the user ID of the current user.
int getuid() {
  if (!Platform.isLinux) {
    throw 'Unable to determine UID on this system';
  }

  final dylib = DynamicLibrary.open('libc.so.6');
  final getuidP =
      dylib.lookupFunction<Int32 Function(), int Function()>('getuid');
  return getuidP();
}
