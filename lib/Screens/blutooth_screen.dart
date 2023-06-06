import 'dart:convert';

import 'package:fininfocom/Screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import '../resources/colors.dart';
import '../routes/app_routes.dart';
import '../utils/display_utils.dart';


class BlutoothScreen extends StatefulWidget {
  @override
  _BlutoothScreenState createState() => _BlutoothScreenState();
}

class _BlutoothScreenState extends State<BlutoothScreen> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  final GlobalKey<ScaffoldState> _scaffoldKey =  GlobalKey<ScaffoldState>();
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
 BluetoothConnection ? connection;

  int ? _deviceState;

  bool isDisconnecting = false;

 

  bool get isConnected => connection != null && connection!.isConnected;

  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice? _device;
  bool _connected = false;
  bool _isButtonUnavailable = false;

  @override
  void initState() {
    super.initState();

    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    _deviceState = 0; 

  
    enableBluetooth();

    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
        if (_bluetoothState == BluetoothState.STATE_OFF) {
          _isButtonUnavailable = true;
        }
        getPairedDevices();
      });
    });
  }

  @override
  void dispose() {
    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    }

    super.dispose();
  }

  Future<bool> enableBluetooth() async {
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

 
    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
      return true;
    } else {
      await getPairedDevices();
    }
    return false;
  }

  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

    try {
      devices = await _bluetooth.getBondedDevices();
    } on PlatformException {
      print("Error");
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _devicesList = devices;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
         appBar: AppBar(
        title: const Text(
          "Blutooth Screen",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, color: cWhiteColor),
        ),
        centerTitle: true,
        backgroundColor: cBgColor,
        leading: IconButton(
          icon:const  Icon(
            Icons.arrow_back,
            color: cWhiteColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      actions: [
        IconButton(
            icon: const Icon(Icons.person, color: cWhiteColor,),
            onPressed: () {
            // Navigator.pushNamed(context, AppRoutes.profileScreen);

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
    
      ],
        
      ),
        body:Column(
          children: [
            vGap(40),
            bluetoothBody()
          ],
        )
      ),
    );
  }

  

  void _connect() async {
    setState(() {
      _isButtonUnavailable = true;
    });
    if (_device == null) {
      Text('No device selected');
    } else {
      if (!isConnected) {
        await BluetoothConnection.toAddress(_device?.address)
            .then((_connection) {
          print('Connected to the device');
          connection = _connection;
          setState(() {
            _connected = true;
          });

          connection?.input?.listen(null).onDone(() {
            if (isDisconnecting) {
              print('Disconnecting locally!');
            } else {
              print('Disconnected remotely!');
            }
            if (this.mounted) {
              setState(() {});
            }
          });
        }).catchError((error) {
          print('Cannot connect, exception occurred');
          print(error);
        });
        showSuccessMessage(context ,'Device connected');

        setState(() => _isButtonUnavailable = false);
      }
    }
  }

  

  void _disconnect() async {
    setState(() {
      _isButtonUnavailable = true;
      _deviceState = 0;
    });

    await connection?.close();
    showSuccessMessage(context ,'Device disconnected');
    if (!connection!.isConnected) {
      setState(() {
        _connected = false;
        _isButtonUnavailable = false;
      });
    }
  }

  void _sendOnMessageToBluetooth() async {
    await connection?.output.allSent;
    setState(() {
      _deviceState = 1; 
    });
  }

  void _sendOffMessageToBluetooth() async {
    await connection?.output.allSent;
    setState(() {
      _deviceState = -1; 
    });
  }

 

Widget bluetoothBody (){
  return  Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Visibility(
                visible: _isButtonUnavailable &&
                    _bluetoothState == BluetoothState.STATE_ON,
                child: const LinearProgressIndicator(
                  backgroundColor: Colors.yellow,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                  const   Expanded(
                      child:   Text(
                        'Enable Bluetooth',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Switch(
                      value: _bluetoothState.isEnabled,
                      onChanged: (bool value) {
                        future() async {
                          if (value) {
                            await FlutterBluetoothSerial.instance
                                .requestEnable();
                          } else {
                            await FlutterBluetoothSerial.instance
                                .requestDisable();
                          }

                          await getPairedDevices();
                          _isButtonUnavailable = false;

                          if (_connected) {
                            _disconnect();
                          }
                        }

                        future().then((_) {
                          setState(() {});
                        });
                      },
                    )
                  ],
                ),
              ),

            ],
          ),
        );

}

}