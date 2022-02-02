// ignore_for_file: avoid_print, avoid_web_libraries_in_flutter

import 'dart:html' show Event, EventListener;
import 'dart:js' show allowInterop;

import 'package:flutter/material.dart';
import 'package:web_usb/web_usb.dart';

import 'ledger_nano_s_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('web_usb example'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              child: const Text('canUse'),
              onPressed: () {
                bool canUse = canUseUsb();
                print('canUse $canUse');
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text('usb.subscribeConnect'),
                  onPressed: () {
                    usb.subscribeConnect(_handleConnect);
                    print('usb.subscribeConnect success');
                  },
                ),
                ElevatedButton(
                  child: const Text('usb.unsubscribeConnect'),
                  onPressed: () {
                    usb.unsubscribeConnect(_handleConnect);
                    print('usb.unsubscribeConnect success');
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text('usb.subscribeDisconnect'),
                  onPressed: () {
                    usb.subscribeDisconnect(_handleDisconnect);
                    print('usb.subscribeDisconnect success');
                  },
                ),
                ElevatedButton(
                  child: const Text('usb.unsubscribeDisconnect'),
                  onPressed: () {
                    usb.unsubscribeDisconnect(_handleDisconnect);
                    print('usb.unsubscribeDisconnect success');
                  },
                ),
              ],
            ),
            ElevatedButton(
              child: const Text('Ledger Nano S'),
              onPressed: () {
                var route = MaterialPageRoute(builder: (context) {
                  return const LedgerNanoSPage();
                });
                Navigator.of(context).push(route);
              },
            ),
          ],
        ),
      ),
    );
  }
}

final EventListener _handleConnect = allowInterop((Event event) {
  print('_handleConnect $event');
});

final EventListener _handleDisconnect = allowInterop((Event event) {
  print('_handleDisconnect $event');
});
