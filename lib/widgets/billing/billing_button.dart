import 'package:flutter/material.dart';

class BillingButton extends StatelessWidget {
  const BillingButton({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  final String title;
  final String child;

  @override
  Widget build(BuildContext context) {
    final mHeight = MediaQuery.of(context).size.height;
    final mWidth = MediaQuery.of(context).size.width;
    return Row(
      children: [
        SizedBox(
            // color: Colors.amber,
            width: mWidth * .15,
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
        SizedBox(width: mWidth * .03),
        const Text(":"),
        SizedBox(width: mWidth * .03),
        Container(
          alignment: Alignment.center,
          child: Text(
            child,
            textAlign: TextAlign.center,
          ),
          width: mWidth * .70,
          height: mHeight * .07,
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: Colors.grey,
            ),
          ),
        )
      ],
    );
  }
}
