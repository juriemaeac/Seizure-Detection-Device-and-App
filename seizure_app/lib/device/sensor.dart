//PAGE KUNG SAN UNG READING NG SENSOR

import 'dart:async';
import 'dart:convert' show utf8;

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:oscilloscope/oscilloscope.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:seizure_app/constant.dart';

class SensorPage extends StatefulWidget {
  const SensorPage({ Key? key, this.device}) : super(key: key);
  final BluetoothDevice? device; //remove ? if may mga errors

  @override
  _SensorPageState createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  final String SERVICE_UUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
  final String CHARACTERISTIC_UUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8";
  late bool isReady;
  late Stream<List<int>> stream;
  List<double> traceDust = [];

  @override
  void initState() {
    super.initState();
    isReady = false;
    connectToDevice();
  }

  connectToDevice() async {
    if (widget.device == null) {
      _Pop();
      return;
    }

    Timer(const Duration(seconds: 15), () {
      if (!isReady) {
        disconnectFromDevice();
        _Pop();
      }
    });

    await widget.device!.connect();
    discoverServices();
  }

  disconnectFromDevice() {
    if (widget.device == null) {
      _Pop();
      return;
    }

    widget.device!.disconnect();
  }

  discoverServices() async {
    if (widget.device == null) {
      _Pop();
      return;
    }

    List<BluetoothService> services = await widget.device!.discoverServices();
    services.forEach((service) {
      if (service.uuid.toString() == SERVICE_UUID) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
            characteristic.setNotifyValue(!characteristic.isNotifying);
            stream = characteristic.value;

            setState(() {
              isReady = true;
            });
          }
        });
      }
    });

    if (!isReady) {
      _Pop();
    }
  }

  Future<bool> _onWillPop() async{
    bool willPop = false;
    await showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: const Text('Are you sure?'),
              content: Text('Do you want to disconnect device and go back?'),
              actions: <Widget>[
                FlatButton(
                    onPressed: (){
                      Navigator.of(context).pop(false); 
                      willPop = false;},
                    child: Text('No')),
                FlatButton(
                    onPressed: () {
                      disconnectFromDevice();
                      willPop = true;
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Yes')),
              ],
            ));
     return willPop;
  }

  _Pop() {
    Navigator.of(context).pop(true);
  }

  String _dataParser(List<int> dataFromDevice) {
    return utf8.decode(dataFromDevice);
  }

  @override
  Widget build(BuildContext context) {
    Oscilloscope oscilloscope = Oscilloscope(
      showYAxis: true,
      padding: 0.0,
      backgroundColor: Colors.pink,
      traceColor: Colors.white,
      yAxisMax: 3000.0,
      yAxisMin: 0.0,
      dataSet: traceDust,
    );

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text('Records Page'),
        // ),
        body: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            margin: const EdgeInsets.only(
              top: 50,
            ),
            child: !isReady
                ? Column(
                  children: [
                    Row(
                      children: [
                    //         IconButton(
                    //   icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    //   onPressed: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => const ProfilePage(),
                    //       ),
                    //     );
                    //   },
                    // ),
                      const Text(
                        'Records',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                // const SizedBox(
                //   width: 40,
                // ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                    ),
                    Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: darkBlue,
                        size: 50,
                      ),
                    ),
                  ],
                )
                : Container(
                    child: StreamBuilder<List<int>>(
                      stream: stream,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<int>> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          var currentValue = _dataParser(snapshot.data ?? []);
                          traceDust.add(double.tryParse(currentValue) ?? 0);

                          return Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      const Text('Current value from Sensor',
                                          style: TextStyle(fontSize: 14)),
                                      Text('${currentValue}data reading',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24))
                                    ]),
                              ),
                              Expanded(
                                flex: 1,
                                child: oscilloscope,
                              )
                            ],
                          ));
                        } else {
                          return Text('Check the stream');
                          
                        }
                      },
                    ),
                  )),
      ),
    );
  }
}