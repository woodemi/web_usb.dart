// ignore_for_file: avoid_print, avoid_web_libraries_in_flutter

import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web_usb/web_usb.dart';
import 'package:collection/collection.dart';

final ledgerDeviceIds = RequestOptionsFilter(
  vendorId: 0x2c97,
);

const configurationValue = 1;
const endpointNumber = 3;

Uint8List transport(
  int cla,
  int ins,
  int p1,
  int p2, [
  Uint8List? data,
]) {
  data ??= Uint8List.fromList([]);
  return Uint8List.fromList([cla, ins, p1, p2, data.length, ...data]);
}

final getAppAndVersion = transport(0xb0, 0x01, 0x00, 0x00);

String parseAppAndVersion(Uint8List data) {
  var readBuffer = ReadBuffer(data.buffer.asByteData());
  assert(readBuffer.getUint8() == 1);
  var nameLength = readBuffer.getUint8();
  var name = String.fromCharCodes(readBuffer.getUint8List(nameLength));
  var versionLength = readBuffer.getUint8();
  var version = String.fromCharCodes(readBuffer.getUint8List(versionLength));
  return '$name, $version';
}

class LedgerNanoSPage extends StatefulWidget {
  const LedgerNanoSPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LedgerNanoSState();
  }
}

class _LedgerNanoSState extends State<LedgerNanoSPage> {
  UsbDevice? _device;
  UsbConfiguration? _configuration;
  UsbInterface? _interface;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ledger Nano S'),
      ),
      body: Center(
        child: Column(
          children: [
            _buildRequestGet(),
            _buildOpenClose(),
            _buildReset(),
            _buildGetSelectConfiguration(),
            _buildGetClaimInterface(),
            _buildTransferInOut(),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestGet() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          child: const Text('requestDevice'),
          onPressed: () async {
            UsbDevice requestDevice = await usb.requestDevice(RequestOptions(
              filters: [ledgerDeviceIds],
            ));
            print('requestDevice $requestDevice');
            _device = requestDevice;
          },
        ),
        ElevatedButton(
          child: const Text('getDevices'),
          onPressed: () async {
            List<UsbDevice> getDevices = await usb.getDevices();
            print('getDevices $getDevices');
            _device = getDevices[0];
          },
        ),
      ],
    );
  }

  Widget _buildOpenClose() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          child: const Text('device.open'),
          onPressed: () {
            _device?.open().then((value) {
              print('device.open success');
            }).catchError((error) {
              print('device.open $error');
            });
          },
        ),
        ElevatedButton(
          child: const Text('device.close'),
          onPressed: () {
            _device?.close().then((value) {
              print('device.close success');
            }).catchError((error) {
              print('device.close $error');
            });
          },
        ),
      ],
    );
  }

  Widget _buildReset() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          child: const Text('device.reset'),
          onPressed: () {
            _device?.reset().then((value) {
              print('device.reset success');
            }).catchError((error) {
              print('device.reset $error');
            });
          },
        ),
      ],
    );
  }

  Widget _buildGetSelectConfiguration() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          child: const Text('device.configuration'),
          onPressed: () {
            print('device.configuration ${_device?.configuration}');
            _configuration = _device?.configuration;
            print('configuration $_configuration');
          },
        ),
        ElevatedButton(
          child: const Text('device.selectConfiguration'),
          onPressed: () async {
            await _device?.selectConfiguration(configurationValue);
            print('device.selectConfiguration success');
            _configuration = _device?.configuration;
          },
        ),
      ],
    );
  }

  Widget _buildGetClaimInterface() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          child: const Text('configuration.interfaces'),
          onPressed: () {
            print('configuration.interfaces ${_configuration?.interfaces}');
            _interface = _configuration?.interfaces.firstWhereOrNull((i) {
              return i.alternates.firstWhereOrNull((a) => a.interfaceClass == 255) != null;
            });
            print('interface $_interface');
          },
        ),
        ElevatedButton(
          child: const Text('device.claimInterface'),
          onPressed: () {
            _device?.claimInterface(_interface!.interfaceNumber).then((value) {
              print('device.claimInterface success');
            }).catchError((error) {
              print('device.claimInterface $error');
            });
          },
        ),
        ElevatedButton(
          child: const Text('device.releaseInterface'),
          onPressed: () {
            _device?.releaseInterface(_interface!.interfaceNumber).then((value) {
              print('device.releaseInterface success');
            }).catchError((error) {
              print('device.releaseInterface $error');
            });
          },
        ),
      ],
    );
  }

  Widget _buildTransferInOut() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          child: const Text('device.transferIn'),
          onPressed: () async {
            var usbInTransferResult = await _device!.transferIn(endpointNumber, packetSize);
            print('usbInTransferResult ${usbInTransferResult.data.lengthInBytes}');
            var data = parseBlock(usbInTransferResult.data);
            var response = parseAppAndVersion(data);
            print(response);
          },
        ),
        ElevatedButton(
          child: const Text('device.transferOut'),
          onPressed: () async {
            var usbOutTransferResult = await _device?.transferOut(endpointNumber, makeBlock(getAppAndVersion));
            print('usbOutTransferResult ${usbOutTransferResult?.bytesWritten}');
          },
        ),
      ],
    );
  }
}

const packetSize = 64;
final channel = Random().nextInt(0xffff);
const Tag = 0x05;

/// 
/// +---------+--------+------------+-----------+
/// | channel |  Tag   | blockSeqId | blockData |
/// +---------+--------+------------+-----------+
/// | 2 bytes | 1 byte | 2 bytes    |       ... |
/// +---------+--------+------------+-----------+
Uint8List makeBlock(Uint8List apdu) {
  // TODO Multiple blocks

  var apduBuffer = WriteBuffer();
  apduBuffer.putUint16(apdu.length, endian: Endian.big);
  apduBuffer.putUint8List(apdu);
  var blockSize = packetSize - 5;
  var paddingLength = blockSize - apdu.length - 2;
  apduBuffer.putUint8List(Uint8List.fromList(List.filled(paddingLength, 0)));
  var apduData = apduBuffer.done();

  var writeBuffer = WriteBuffer();
  writeBuffer.putUint16(channel, endian: Endian.big);
  writeBuffer.putUint8(Tag);
  writeBuffer.putUint16(0, endian: Endian.big);
  writeBuffer.putUint8List(apduData.buffer.asUint8List());
  return writeBuffer.done().buffer.asUint8List();
}

Uint8List parseBlock(ByteData block) {
  var readBuffer = ReadBuffer(block);
  assert(readBuffer.getUint16(endian: Endian.big) == channel);
  assert(readBuffer.getUint8() == Tag);
  assert(readBuffer.getUint16(endian: Endian.big) == 0);

  var dataLength = readBuffer.getUint16(endian: Endian.big);
  var data = readBuffer.getUint8List(dataLength);

  return Uint8List.fromList(data);
}