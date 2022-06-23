import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seizure_app/constant.dart';
import 'package:seizure_app/device/widget.dart';

class DeviceScreen extends StatelessWidget {
  const DeviceScreen({Key? key, this.device}) : super(key: key);

  final BluetoothDevice? device;

  List<Widget> _buildServiceTiles(List<BluetoothService> services) {
    return services
        .map(
          (s) => ServiceTile(
            service: s,
            characteristicTiles: s.characteristics
                .map(
                  (c) => CharacteristicTile(
                    characteristic: c,
                    onReadPressed: () => c.read(),
                    onWritePressed: () => c.write([13, 24]),
                    onNotificationPressed: () =>
                        c.setNotifyValue(!c.isNotifying),
                    descriptorTiles: c.descriptors
                        .map(
                          (d) => DescriptorTile(
                            descriptor: d,
                            onReadPressed: () => d.read(),
                            onWritePressed: () => d.write([11, 12]),
                          ),
                        )
                        .toList(),
                  ),
                )
                .toList(),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 60,
          ),
          Container(
            padding: EdgeInsets.all(40),
            width: double.infinity,
            height: MediaQuery.of(context).size.height /3,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            margin: EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                StreamBuilder<BluetoothDeviceState>(
                  stream: device!.state,
                  initialData: BluetoothDeviceState.connecting,
                  builder: (c, snapshot) => Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (snapshot.data ==
                            BluetoothDeviceState.connected) ...[
                          const Icon(
                            Icons.bluetooth_connected,
                            color: Colors.blue,
                            size: 40,
                          )
                        ] else ...[
                          const Icon(
                            Icons.bluetooth_disabled,
                            color: lightGrey,
                            size: 40,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                StreamBuilder<BluetoothDeviceState>(
                  stream: device!.state,
                  initialData: BluetoothDeviceState.connecting,
                  builder: (c, snapshot) => Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(device!.name, 
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                          ),
                        ),
                        SizedBox(height: 20,),
                        Text('ID: ${device!.id.toString()}'),
                        Text(
                            'Device is ${snapshot.data.toString().split('.')[1]}.',
                            style: TextStyle(
                              color: lightBlue
                            ),),
                            SizedBox(height: 8),
                            Divider(thickness: 1,),
                            SizedBox(height: 8),
                        Container(
                          child: StreamBuilder<BluetoothDeviceState>(
                            stream: device!.state,
                            initialData: BluetoothDeviceState.connecting,
                            builder: (c, snapshot) {
                              VoidCallback onPressed;
                              String text;
                              switch (snapshot.data) {
                                case BluetoothDeviceState.connected:
                                  onPressed = () {
                                    device!.disconnect();
                                    Navigator.pop(context);
                                  };
                                  text = 'DISCONNECT';
                                  break;
                                case BluetoothDeviceState.disconnected:
                                  onPressed = () => device!.connect();
                                  text = 'CONNECT';
                                  break;
                                default:
                                  onPressed = (() => {});
                                  text =
                                      snapshot.data.toString().substring(21).toUpperCase();
                                  break;
                              }
                              return ElevatedButton(
                                  onPressed: onPressed,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20.0, right:20.0),
                                    child: Text(
                                      text,
                                      style: TextStyle(
                                        fontSize: 15,
                                              color: Colors.white)
                                    ),
                                  ),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              darkBlue),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                    ),);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
