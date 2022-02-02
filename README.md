Dart wrapper via `dart:js` for https://wicg.github.io/webusb/

## Features

- canUseUsb
- getDevices/requestDevice
- subscribeConnect/unsubscribeConnect
- subscribeDisconnect/unsubscribeDisconnect
- open/close
- reset
- selectConfiguration
- claimInterface/releaseInterface
- transferIn/transferOut

## Usage

### canUseUsb

```dart
bool canUse = canUseUsb();
print('canUse $canUse');
```

### getDevices/requestDevice

- https://developer.mozilla.org/en-US/docs/Web/API/USB/getDevices

```dart
List<UsbDevice> getDevices = await usb.getDevices();
_device = getDevices[0];
```

- https://developer.mozilla.org/en-US/docs/Web/API/USB/requestDevice

```dart
UsbDevice requestDevice = await usb.requestDevice(RequestOptions(
  filters: [ledgerDeviceIds],
));
_device = requestDevice;
```

### subscribeConnect/unsubscribeConnect

https://developer.mozilla.org/en-US/docs/Web/API/usb/onconnect

```dart
final EventListener _handleConnect = allowInterop((Event event) {}
...
usb.subscribeConnect(_handleConnect);
...
usb.unsubscribeConnect(_handleConnect);
```

### subscribeDisconnect/unsubscribeDisconnect

https://developer.mozilla.org/en-US/docs/Web/API/usb/ondisconnect

```dart
final EventListener _handleDisconnect = allowInterop((Event event) {}
...
usb.subscribeDisconnect(_handleDisconnect);
...
usb.unsubscribeDisconnect(_handleDisconnect);
```

### open/close

- https://developer.mozilla.org/en-US/docs/Web/API/USBDevice/open

```dart
_device?.open().then((value) {
  print('device.open success');
}).catchError((error) {
  print('device.open $error');
});
```

- https://developer.mozilla.org/en-US/docs/Web/API/USBDevice/close

```dart
_device?.close().then((value) {
  print('device.close success');
}).catchError((error) {
  print('device.close $error');
});
```

### reset

https://developer.mozilla.org/en-US/docs/Web/API/USBDevice/reset

```dart
_device?.reset().then((value) {
  print('device.reset success');
}).catchError((error) {
  print('device.reset $error');
});
```

### selectConfiguration

https://developer.mozilla.org/en-US/docs/Web/API/USBDevice/selectConfiguration

```dart
await _device?.selectConfiguration(configurationValue);
_configuration = _device?.configuration;
```

### claimInterface/releaseInterface

- https://developer.mozilla.org/en-US/docs/Web/API/USBDevice/claimInterface

```dart
_device?.claimInterface(_interface!.interfaceNumber).then((value) {
  print('device.claimInterface success');
}).catchError((error) {
  print('device.claimInterface $error');
});
```

- https://developer.mozilla.org/en-US/docs/Web/API/USBDevice/releaseInterface

```dart
_device?.releaseInterface(_interface!.interfaceNumber).then((value) {
  print('device.releaseInterface success');
}).catchError((error) {
  print('device.releaseInterface $error');
});
```

### transferIn/transferOut

- https://developer.mozilla.org/en-US/docs/Web/API/USBDevice/transferIn

```dart
var usbInTransferResult = await _device!.transferIn(endpointNumber, packetSize);
print('usbInTransferResult ${usbInTransferResult.data.lengthInBytes}');
```

- https://developer.mozilla.org/en-US/docs/Web/API/USBDevice/transferOut

```dart
var usbOutTransferResult = await _device?.transferOut(endpointNumber, makeBlock(getAppAndVersion));
print('usbOutTransferResult ${usbOutTransferResult?.bytesWritten}');
```

## Additional information

Status in Chromium: https://chromestatus.com/feature/5651917954875392
