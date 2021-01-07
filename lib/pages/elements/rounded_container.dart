import 'package:flutter/material.dart';

class RoundedContainer extends StatelessWidget {
  const RoundedContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 3,
      decoration: BoxDecoration(
        color: Colors.greenAccent,
        borderRadius: BorderRadius.only(
            bottomLeft:
                Radius.circular(MediaQuery.of(context).size.width / 2.5),
            bottomRight:
                Radius.circular(MediaQuery.of(context).size.width / 2.5)),
      ),
    );
  }
}
