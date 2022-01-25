// ignore_for_file: avoid_print, avoid_web_libraries_in_flutter

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:web_usb/web_usb.dart';
import 'package:collection/collection.dart';

final ledgerDeviceIds = RequestOptionsFilter(
  vendorId: 0x2c97,
);

const configurationValue = 1;
const endpointNumber = 3;

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
}
