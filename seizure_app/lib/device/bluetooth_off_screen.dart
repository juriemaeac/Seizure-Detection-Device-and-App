import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:seizure_app/constant.dart';
import 'package:seizure_app/pages/profile_page.dart';

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({ Key? key,  this.state}) : super(key: key);

  final BluetoothState? state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBlue,
      body: Column(
        children: <Widget>[
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top:60.0),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white,),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.bluetooth_disabled,
                size: 200.0,
                color: Colors.white54,
              ),
              Text(
                'Bluetooth Adapter is ${state.toString().substring(15)}.',
                style: const TextStyle(color: Colors.white, fontSize: 14.0),
              ),
            ],
          ),
        ],
      ),
    );
  }
}