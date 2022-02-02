@JS()
library web_usb;

import 'dart:html' show EventListener, EventTarget;
import 'dart:js_util' show promiseToFuture;
import 'dart:typed_data';

import 'package:js/js.dart';

import 'src/js_facade.dart';

part 'src/web_usb_base.dart';

@JS('navigator.usb')
external EventTarget? get _usb;

bool canUseUsb() => _usb != null;

Usb? _instance;
Usb get usb {
  if (_usb != null) {
    return _instance ??= Usb._(_usb!);
  }
  throw 'navigator.usb unavailable';
}
