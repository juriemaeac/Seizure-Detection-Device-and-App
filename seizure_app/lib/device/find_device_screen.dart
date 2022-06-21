import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:seizure_app/constant.dart';
import 'package:seizure_app/device/blu_connection.dart';
import 'package:seizure_app/device/sensor.dart';
import 'package:seizure_app/device/widget.dart';
import 'package:seizure_app/pages/profile_page.dart';

class FindDevicesScreen extends StatelessWidget {
  const FindDevicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              //horizontal: 15,
              vertical: 10,
            ),
            margin: const EdgeInsets.only(
              top: 50,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                // IconButton(
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
                Text(
                  'Find Device',
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
          ),
          RefreshIndicator(
            onRefresh: () =>
                FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  StreamBuilder<List<BluetoothDevice>>(
                    stream: Stream.periodic(Duration(seconds: 2))
                        .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                    initialData: [],
                    builder: (c, snapshot) => Column(
                      children: snapshot.data!
                          .map((d) => ListTile(
                                title: Text(d.name),
                                subtitle: Text(d.id.toString()),
                                trailing: StreamBuilder<BluetoothDeviceState>(
                                  stream: d.state,
                                  initialData: BluetoothDeviceState.disconnected,
                                  builder: (c, snapshot) {
                                    if (snapshot.data ==
                                        BluetoothDeviceState.connected) {
                                      return ElevatedButton(
                                        child: const Padding(
                                          padding:  EdgeInsets.only(left: 20, right: 20),
                                          child: Text('OPEN', 
                                            style: TextStyle(
                                              color: Colors.white
                                            )
                                          ),
                                        ),
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(darkBlue),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20.0),
                                            
                                          ),
                                          ),
                                          ),
                                        onPressed: () => Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DeviceScreen(device: d))),
                                      );
                                    }
                                    return Text(snapshot.data.toString());
                                  },
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  StreamBuilder<List<ScanResult>>(
                    stream: FlutterBlue.instance.scanResults,
                    initialData: [],
                    builder: (c, snapshot) => Column(
                      children: snapshot.data!
                          .map(
                            (r) => ScanResultTile(
                              result: r,
                              onTap: () => Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                    r.device.connect();
                                    //return DeviceScreen(device: r.device); WALA TO
                                    return SensorPage(device: r.device);
                                  }
                                )
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data == true) { //nilagyan ng true
            return FloatingActionButton(
              child: const Icon(Icons.stop),
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
                child: const Icon(Icons.search,),
                backgroundColor: darkBlue,
                onPressed: () => FlutterBlue.instance
                    .startScan(timeout: const Duration(seconds: 4)));
          }
        },
      ),
    );
  }
}