import 'package:bill_creator/screens/order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderItem extends StatelessWidget {
  const OrderItem(
      {this.i, this.name, this.itemCount, this.deliveryDate, this.orderId});
  final int? i;
  final String? orderId;
  final DateTime? deliveryDate;
  final String? name;
  final int? itemCount;

  // final formatedDate = DateTime.parse(deliveryDate!);

  @override
  Widget build(BuildContext context) {
    final mWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(OrderDetailsScreen.routeName, arguments: orderId);
      },
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order ${i! + 1}'),
                    SizedBox(height: 10),
                    Text(
                      'Order id :',
                    ),
                    Text(orderId!)
                  ],
                ),
                Column(
                  children: [
                    Text('Due date'),
                    Text("${DateFormat.yMMMd().format(deliveryDate!)}"),
                  ],
                )
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  // color: Colors.amber,
                  width: mWidth * .5,
                  child: Text(
                    name!,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 7),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(7)),
                    child: Text(
                      '$itemCount items',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
