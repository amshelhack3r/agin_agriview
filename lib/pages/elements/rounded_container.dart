import 'package:flutter/material.dart';

class RoundedContainer extends StatelessWidget {
  const RoundedContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 3,
      decoration: BoxDecoration(
        color: Colors.greenAccent,
        borderRadius: BorderRadius.only(
            bottomLeft:
                Radius.circular(MediaQuery.of(context).size.width / 2.5),
            bottomRight:
                Radius.circular(MediaQuery.of(context).size.width / 2.5)),
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.only(
              bottomLeft:
                  Radius.circular(MediaQuery.of(context).size.width / 2.5),
              bottomRight:
                  Radius.circular(MediaQuery.of(context).size.width / 2.5)),
          child: Image.asset(
            "assets/images/dashboard_mask.png",
            fit: BoxFit.cover,
          )),
    );
  }
}
