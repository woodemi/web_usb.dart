part of '../web_usb.dart';

class Usb extends Delegate<Object> {
  Usb._(delegate) : super(delegate);

  Future<UsbDevice> requestDevice([RequestOptions? options]) {
    var promise = callMethod('requestDevice', [options ?? RequestOptions(filters: [])]);
    return promiseToFuture(promise).then((value) => UsbDevice._(value));
  }

  Future<List<UsbDevice>> getDevices() {
    var promise = callMethod('getDevices');
    return promiseToFuture(promise).then((value) {
      return (value as List).map((e) => UsbDevice._(e)).toList();
    });
  }
}

@JS()
@anonymous
class RequestOptions {
  external factory RequestOptions({
    required List<dynamic> filters,
  });
}

@JS()
@anonymous
class RequestOptionsFilter {
  external factory RequestOptionsFilter({
    int vendorId,
    int productId,
    int classCode,
    int subclassCode,
    int protocolCode,
    int serialNumber,
  });
}

class UsbDevice extends Delegate<Object> {
  UsbDevice._(Object delegate) : super(delegate);

  Future<void> open() {
    var promise = callMethod('open');
    return promiseToFuture(promise);
  }

  Future<void> close() {
    var promise = callMethod('close');
    return promiseToFuture(promise);
  }

  Future<void> reset() {
    var promise = callMethod('reset');
    return promiseToFuture(promise);
  }

  UsbConfiguration? get configuration {
    var property = getProperty('configuration');
    if (property == null) return null;
    return UsbConfiguration._(property);
  }

  Future<void> selectConfiguration(int configurationValue) {
    var promise = callMethod('selectConfiguration', [configurationValue]);
    return promiseToFuture(promise);
  }

  Future<void> claimInterface(int interfaceNumber) {
    var promise = callMethod('claimInterface', [interfaceNumber]);
    return promiseToFuture(promise);
  }

  Future<void> releaseInterface(int interfaceNumber) {
    var promise = callMethod('releaseInterface', [interfaceNumber]);
    return promiseToFuture(promise);
  }
}

class UsbConfiguration extends Delegate<Object> {
  UsbConfiguration._(Object delegate) : super(delegate);

  List<UsbInterface> get interfaces {
    var property = getProperty('interfaces');
    if (property == null) return [];
    return (property as List).map((e) => UsbInterface._(e)).toList();
  }
}

class UsbInterface extends Delegate<Object> {
  UsbInterface._(Object delegate) : super(delegate);

  int get interfaceNumber => getProperty('interfaceNumber');

  List<UsbAlternateInterface> get alternates {
    var property = getProperty('alternates');
    if (property == null) return [];
    return (property as List).map((e) => UsbAlternateInterface._(e)).toList();
  }
}

class UsbAlternateInterface extends Delegate<Object> {
  UsbAlternateInterface._(Object delegate) : super(delegate);

  int get interfaceClass => getProperty('interfaceClass');
}
