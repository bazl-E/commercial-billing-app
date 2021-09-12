import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'order_item.dart';

class Tile extends StatelessWidget {
  Tile(this.snap);
  final snap;
  final _shimmerGradient = const LinearGradient(
    colors: [
      Color(0xFFEBEBF4),
      Color(0xFFF4F4F4),
      Color(0xFFEBEBF4),
    ],
    stops: [
      0.1,
      0.3,
      0.4,
    ],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    tileMode: TileMode.clamp,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height - 155,
          child: ListView.builder(
              padding: const EdgeInsets.only(top: 0),
              itemCount: snap.data!.docs.length,
              shrinkWrap: true,
              itemBuilder: (ctx, i) {
                final doc = snap.data!.docs[i];
                return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('bills')
                        .doc(doc.id)
                        .collection('products')
                        .snapshots(),
                    builder: (ctx, subSnap) {
                      if (subSnap.connectionState == ConnectionState.waiting) {
                        return ShaderMask(
                          blendMode: BlendMode.srcATop,
                          shaderCallback: (bounds) {
                            return _shimmerGradient.createShader(bounds);
                          },
                          child: Card(
                            child: OrderItem(
                              i: i,
                              name: 'null',
                              orderId: '123',
                              deliveryDate: DateTime.now(),
                              // itemCount:,
                              itemCount: 1,
                            ),
                          ),
                        );
                      }

                      return Card(
                        child: OrderItem(
                          i: i,
                          name: (doc['name']).toString(),
                          orderId: doc.id,
                          deliveryDate:
                              DateTime.parse((doc['delivaryDate']).toString()),
                          // itemCount:,
                          itemCount: subSnap.data!.docs.length,
                        ),
                      );
                    });
              }),
        ),
      ],
    );
  }
}
