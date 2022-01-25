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
}