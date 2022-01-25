// ignore_for_file: avoid_print, avoid_web_libraries_in_flutter

import 'package:flutter/material.dart';
import 'package:web_usb/web_usb.dart';

final ledgerDeviceIds = RequestOptionsFilter(
  vendorId: 0x2c97,
);

class LedgerNanoSPage extends StatefulWidget {
  const LedgerNanoSPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LedgerNanoSState();
  }
}

class _LedgerNanoSState extends State<LedgerNanoSPage> {
  UsbDevice? _device;

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
}
