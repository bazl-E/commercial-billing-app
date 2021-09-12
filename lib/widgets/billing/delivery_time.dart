import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/models/product_manage.dart';

class DeliveryTime extends StatefulWidget {
  DeliveryTime(this.ctx, this.setTime, {Key? key})
      : super(
          key: key,
        );

  final BuildContext ctx;
  final Function setTime;

  @override
  _DeliveryTimeState createState() => _DeliveryTimeState();
}

class _DeliveryTimeState extends State<DeliveryTime> {
  ProductMange? data;
  String? date;

  @override
  void initState() {
    data = Provider.of<ProductMange>(context, listen: false);
    super.initState();
  }

  Future<void> showDateTimePicker(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    if (pickedDate == null) {
      return;
    }
    setState(() {
      data!.selectedDate = pickedDate;
      date = DateFormat.yMMMd().format(pickedDate);
      widget.setTime(data!.selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mHeight = MediaQuery.of(context).size.height;
    final mWidth = MediaQuery.of(context).size.width;
    return Row(
      children: [
        SizedBox(
            // color: Colors.amber,
            width: mWidth * .15,
            child: const Text(
              'Delivery time',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
        SizedBox(width: mWidth * .03),
        const Text(":"),
        SizedBox(width: mWidth * .03),
        Container(
          alignment: Alignment.center,
          child: Text(
            data!.selectedDate == null ? 'no date selected' : '$date',
            textAlign: TextAlign.center,
          ),
          width: mWidth * .45,
          height: mHeight * .07,
          decoration: BoxDecoration(
              border: Border.all(
            width: 2,
            color: Colors.grey,
          )),
        ),
        const SizedBox(width: 10),
        TextButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              showDateTimePicker(context);
            },
            child: const Text('Pick a date'))
      ],
    );
  }
}
