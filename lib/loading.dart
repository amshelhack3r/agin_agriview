import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  String time = 'loading';

 void setWorldTime() async{
   /*WorldTime instance = WorldTime(location: 'Berlin', url: 'Europe/Berlin', flag: 'germany.jpg');
   await instance.getWorldTime();
   print(instance.time);
   Navigator.pushReplacementNamed(context, '/home', arguments: {
     'location' : instance.location,
     'flag' : instance.flag,
     'time' : instance.time,
     'isDayTime' : instance.isDayTime,
   });*/

 }

  @override
  void initState() {
    super.initState();
    setWorldTime();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Center(
          child: SpinKitFadingGrid(
            color: Colors.white,
            size: 50.0,
          ),
      ),

    );
  }
}
